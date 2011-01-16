import sys
import glob
import serial
import time
import datetime
import wx
from wx.lib.analogclock import *
import struct

MAX_ALARM_DID = chr(0x3F)
DID_ALARM_LEN = 12
class PingError(Exception):
    pass

class MsgDef:
    def __init__(self, v, const):
        v = v.strip()
        v = v[1:-1]
        val, msg_size, callback = v.split(',')
        msg_size = msg_size.strip()
        if 'x' in val:
            self.val = int(val, 16)
        else:
            if val not in const:
                print const.keys()
                raise Exception('Unknown constant %s' % val)
            self.val = const[val]
        try:
            self.n_byte = int(msg_size)
        except:
            try:
                self.n_byte = const[msg_size]
            except:
                # print msg_size in const.keys()
                # print const.keys()
                raise
        self.callback = callback
    def __str__(self):
        return chr(self.val)

'''
A record is did,len,paylaod
where did, len are one byte, payload is len - 2 bytes
did is a char
payload is a str
'''

def form_record(did, payload):
    assert len(payload) < const.MAX_MSG_LEN - 2
    out = did + ord(len(payload) + 2) + payload
    return out

def parse_record(record):
    assert len(record) == ord(record[1])
    return record[0], record[2:]
def read_constants(fn):
    f = open(fn)
    out = {}
    for line in f.readlines():
        if line.startswith('const'):
            line = line.split(';')[0]
            try:
                d, v = line.split('=')
                c, t, n = d.split()
                if 'int' in t:
                    if 'X' in v.upper():
                        base = 16
                    else:
                        base = 10
                        out[n] = int(v, base)
                elif t == 'MsgDef':
                    try:
                        out[n] = MsgDef(v, out)
                    except Exception, e:
                        if '*' not in line:
                            print 'problem with ', line, e
                else:
                    out[n] = v
            except:
                pass
                # print 'could not read', line
    return out
            
class Struct:
    def __init__(self, **dict):
        self.d = dict
    def __getattr__(self, name):
        return self.d[name]
    def __add__(self, other):
        out = {}
        for key in self.d:
            out[key] = self.d[key]
        for key in other.d:
            out[key] = other.d[key]
        return Struct(**out)

const = {}
c_files = ['ClockTHREE_02.pde']
c_files.extend(glob.glob("../../*.cpp"))
c_files.extend(glob.glob("../../*.h"))
for file in c_files:
    next = read_constants(file)
    for key in next:
        const[key] = next[key]
const = Struct(**const)

serialport = '/dev/ttyUSB0'

# raw_input('...')
ser = serial.Serial(serialport, baudrate=const.BAUDRATE, timeout=.5)
ser.flush()

payload = 'A23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
gmt_offset = -5 * 3600

def time_req():
    ser.flush()
    ser.write(str(const.ABS_TIME_REQ))
    id = ser.read(1)
    assert id == str(const.ABS_TIME_SET)
    dat = ser.read(4)
    if len(dat) < 4:
        out = 0
    else:
        out = c3_to_wall_clock(dat)
    return out

def time_set():
    now = int(round(time.time())) + gmt_offset
    dat = wall_clock_to_c3(now)
    ser.write(str(const.ABS_TIME_SET))
    ser.write(dat)
    
def c3_to_wall_clock(bytes):
    return struct.unpack('<I', bytes)[0]

def wall_clock_to_c3(t):
    return struct.pack('<I', t)

def test_wall_clock_conversion():
    # time_set()
    ser.flush()
    ser.write(str(const.ABS_TIME_REQ))
    id = ser.read(1)
    assert id == str(const.ABS_TIME_SET)
    dat = ser.read(4)
    if len(dat) < 4:
        out = 0
    else:
        print c3_to_wall_clock(dat[:4])

def set_tod_alarm(h, m, s, is_set):
    dat = (h * 60 + m) * 60 + s
    dat = wall_clock_to_c3(dat)
    ser.write(str(const.TOD_ALARM_SET))
    ser.write(dat)
    ser.write(chr(is_set))

def get_tod_alarm():
    ser.write(str(const.TOD_ALARM_REQ))
    ser_data = ser.read(6)
    if len(ser_data) < 6:
        raise ValueError('Got bad tod_alarm_msg, l=%d: "%s"' % (len(ser_data), ser_data))
    assert ser_data[0] == str(const.TOD_ALARM_SET)
    hms = c3_to_wall_clock(ser_data[1:5])
    h, ms = divmod(hms , 60 * 60)
    m, s = divmod(ms, 60)
    return h, m, s, bool(ser_data[5])

def set_data(id, data):
    # MID, len(payload)
    l = len(data)
    out = '%s%s%s%s%s' % (str(const.DATA_SET), chr(l + 4), id, chr(l + 2),  data)
    assert len(out) == len(data) + 4, '%s != %s' % (len(out), len(data) + 4)
    ser.write(out)
    time.sleep(.1)
    err = ser.read(4)
    if err:
        raise Exception(get_err(err))

def get_err(err):
    id = '0x%02x' % ord(err[0])
    len = ord(err[1])
    # print id, len, err[2:len]
    return err[2:]

def err_check():
    err = ser.read(1024)
    if err:
        print err
    assert len(err) == 0, get_err(err)

def to_gmt(t):
    return t + gmt_offset

def from_gmt(t):
    return t - gmt_offset

def delete_did(did):
    print 'DELETING', ord(did)
    ser.write(str(const.DATA_DELETE))
    ser.write(did)
    time.sleep(1)
    err_check()

def trigger_mode():
    ser.write(str(const.TRIGGER_MODE) * const.TRIGGER_MODE.n_byte)

def scroll_data(did):
    ser.write(str(const.SCROLL_DATA))
    ser.write(did)

def set_alarm(t, countdown, repeat, scroll_msg, 
              effect_id, sound_id):
    if scroll_msg:
        scroll_did = eeprom.add_record(scroll_msg)
    else:
        scroll_did = chr(0)
    dat = [
           struct.pack('<I', t),
           chr(countdown),
           chr(repeat),
           scroll_did,
           chr(effect_id),
           chr(sound_id),
           chr(0xFE) #  show alarm as unallocated
           ]
    msg = ''.join(dat)
    assert len(msg) == DID_ALARM_LEN - 2

    alarm_did = eeprom.add_record(msg, alarm_flag=True)
    
    # finally inform C3 new alarm is waiting
    ser.write(str(const.DID_ALARM_SET))
    ser.write(alarm_did)
    err_check()
    return alarm_did

def delete_alarm(did):
    ser.flush()
    ser.write(str(const.DID_ALARM_DELETE))
    ser.write(did)
    err_check()
    

def get_next_alarm():
    ser.flush()
    ser.write(str(const.NEXT_ALARM_REQ))
    ser.read(1)
    dat = ser.read(4)
    if len(dat) < 4:
        out = 0
    else:
        out = struct.unpack('<I', dat)[0]
    return out
    
class EEPROM: # singleton!
    # mirror of C3 EEPROM
    
    def __init__(self):
        if hasattr(self, 'singleton'):
            raise Exception("Singlton can only be instantiated once")
        else:
            self.read()
            self.dids = self.__get_dids()
            for did in [d for d in self.dids if d <= MAX_ALARM_DID]:
                data = self.read_did_from_mem(did)
                print 'DATA? "%s"' % data, len(data)
                if data:
                    assert data[0] == did
                    assert len(data) == ord(data[1])
                    assert len(data) == DID_ALARM_LEN
                    t = c3_to_wall_clock(data[2:6])
                    tr = time_req()
                    print t, tr, '?', t < tr, '?', (tr - t)
                    if t < tr:
                        self.delete_did(did)
                        print 'deleted'
                        continue
            EEPROM.singleton = self

    def delete_did(self, did):
        delete_did(did)
        del self.dids[did]
        
    def read_did_from_mem(self, did):
        addr, data = self.dids[did]
        assert data[0] == did
        return data
        
    def read(self):
        ser.write(str(const.EEPROM_DUMP))
        self.eeprom = ser.read(const.MAX_EEPROM_ADDR + 1)
        if len(self.eeprom) < const.MAX_EEPROM_ADDR + 1:
            raise ValueError("Could not read EEPROM")

    def __get_dids(self):
        n = ord(self.eeprom[-1])
        addr = 0
        out = {}
        for i in range(n):
            did = self.eeprom[addr]
            l = ord(self.eeprom[addr + 1])
            out[did] = (addr, self.eeprom[addr: addr + l])
            addr += l
        return out

    def next_did(self, alarm_flag=False):
        if alarm_flag:
            out = 1
        else:
            out = 0x40
        while chr(out) in self.dids and out < 255:
            out = out + 1
        if alarm_flag and out >= 0x3f:
            raise ValueError("no alarm did's available")
        if out >= 255:
            raise ValueError("no did's available")
        out = chr(out)
        assert out not in self.dids, 'did "%s" already used! ord: %s' % (out, ord(out))
        print ord(out), 'is next id value!', [ord(did) for did in self.dids]
        return out
    
    def add_record(self, payload, alarm_flag=False):
        did = None
        if payload in self.eeprom:
            addr = self.eeprom.find(payload) - 2
            if ord(self.eeprom[addr + 1]) == len(payload) + 2:
                print 'eeprom already has payload at address %s' % addr, payload
                # we already have it
                did = self.eeprom[addr]
        if did is None:
            print 'writing new payload', payload
            did = self.next_did(alarm_flag)
            if did < MAX_ALARM_DID:
                print 'Alarm DID:', did, ord(did)
                assert len(payload) + 2 == DID_ALARM_LEN
            self.write(did, payload)
        return did

    def write(self, did, payload):
        assert did not in self.dids, 'DID with num %d not available %s' % (ord(did), [ord(k) for k in self.dids.keys()])
        print 'Trying to write ord(did):', ord(did)
        set_data(did, payload)
        self.dids[did] = (-1, payload)
        time.sleep(.1)

def fmt_time(when):
    return '%02d/%02d/%04d %d:%02d:%02d' % (when.tm_mday, when.tm_mon, when.tm_year,
                                            when.tm_hour, when.tm_min, when.tm_sec)
def eeprom_read(full=False):
    err_check()
    ser.write(str(const.EEPROM_DUMP))
    eeprom = ser.read(1024)
    if len(eeprom) -- 1024:
        n = ord(eeprom[-1])
    else:
        raise ValueError('Eeprom is not 1024 bytes!')
    if full:
        for r in range(64):
            print '%04d 0x%03x  -- ' % (r * 16, r * 16),
            for i in range(16):
                print '%02x' % ord(eeprom[r * 16 + i]),
            print ""
    print ""
    print 'N:', n
    addr = 0
    try:
        for i in range(n):
            did = eeprom[addr]
            l = ord(eeprom[addr + 1])
            print ord(did), l, 
            for j in range(2, l):
                print '0x%02x' % ord(eeprom[addr + j]),

            record = eeprom[addr: addr + l]
            print record
            if did <= MAX_ALARM_DID:
                assert record[1] == chr(DID_ALARM_LEN)
                when = time.gmtime(c3_to_wall_clock(record[2:6]))
                print '       ALARM:', fmt_time(when),
                countdown = record[6]
                repeat = record[7]
                scroll_did = record[8]
                effect_id = record[9]
                sound_id = record[10]
                aid = record[11]
                print 'cd', ord(countdown),
                print 'rp', ord(repeat),
                print 'sc', ord(scroll_did),
                print 'ef', ord(effect_id),
                print 'sd', ord(sound_id),
                print 'aid', ord(aid)
            addr += l
    except Exception, e:
        print e
        pass

class ClockTHREE_Error(Exception):
    pass
def get_data(id):
    ser.write(str(const.DATA_REQ))
    ser.write(id)
    head = ser.read(1)
    if head == str(const.ERR_OUT):
        l = ord(ser.read(1))
        err = 'ERROR: ' + ser.read(l)
        raise ClockTHREE_Error(err)
    assert head == str(const.DATA_SET), ('? 0x%x' % ord(head))
    n_byte = ord(ser.read(1))
    # print 'N_BYTE:', n_byte
    assert ser.read(1) == id
    
    out = ser.read(n_byte - 3)
    # print 'out:', out
    # print 'equal?', len(out), n_byte - 3
    assert ord(out[0]) - 1 == len(out), '%s != %s' % (ord(out[0]), len(out))
    return out[1:]

def sync():
    ser.write(str(const.SYNC))

def ping():
    data_out = str(const.PING) + payload[:const.PING.n_byte - 1]
    assert len(data_out) == const.PING.n_byte, (
        'len(out) != %s' % const.PING.n_byte)
    ser.write(data_out)
    out = ser.read(const.PING.n_byte - 1)
    # print out
    if out != data_out[1:]:
        raise PingError('Recieved bad ping data:"%s"' % out)
    return True

def clear_eeprom():
    # print '0x%02x' % const.EEPROM_CLEAR.val
    out = str(const.EEPROM_CLEAR) * const.EEPROM_CLEAR.n_byte
    assert len(out) == const.EEPROM_CLEAR.n_byte
    ser.write(out)
    time.sleep(5)

def read_write_test():
    dids = range(26, 28)
    for i in dids:
        did = chr(i)
        set_data(did, '%s: TEST' % ord(did))
    eeprom_read()
    for i in dids:
        did = chr(i)
        delete_did(did)
    eeprom_read(full=True)
def countdown(secs):
    for i in range(secs):
        print secs - i
        time.sleep(1)
def main():
    ser.flush()
    print eeprom.dids
    now = time_req()
    if False:
        print ord(set_alarm(now + 60, 
                        countdown=1<<1, 
                            repeat=0, 
                            scroll_msg="DUDE!!!!....--",
                            effect_id=0,
                            sound_id=0))
    print ord(set_alarm(now + 5, 
                        countdown=1 << 3, 
                        repeat=0, 
                        scroll_msg="Hooray!  ",
                        effect_id=0,
                        sound_id=0))
    trigger_mode()
    countdown(15)
    countdown(35)
    return

    if False:
        did  = set_alarm(now + 30, 
                         countdown=0, 
                         repeat=0xFF, 
                         scroll_msg="MMMMNNNNWWWWZZZZFFFFFHFHFHx",
                         effect_id=0,
                         sound_id=0)
        delete_alarm(did)
    return

    trigger_mode()
    for i in range(50):
        print i
        time.sleep(1)
    time.sleep(10);
    print 'done'
    return

    # trigger_mode()
    for i in range(30):
        time.sleep(1)
        print i
    return
    for i in range(10):
        print ser.read(100),
    print
    # eeprom_read()
    print now
    # print time.gmtime(now)
    print get_next_alarm()
    # print time.gmtime(now + 5)
    # trigger_mode()
    # return
    return
    eeprom_read()
    print 'PING ok?'
    for i in range(3):
        if ping():
            print '    YES!'
    clear_eeprom()
    ping()

    now = time.gmtime(time_req())
    year = now.tm_year
    print year
    if year != 2011:
        raise Exception('restart, got bad year')

    for i in range(3):
        now = time.gmtime(time_req())
        assert (now.tm_year == 2011), 'huh, year=%s' % now.tm_year
        print i, year
    set_tod_alarm(11, 12, 13, True)
    print get_tod_alarm()
    
    ping()
    print 'ping ok'

    time_set()
    print time_req()

    h = 0
    m = 0
    s = 0
    is_set = True
    set_tod_alarm(h, m, s, is_set)
    ahh, amm, ass, ais_set = get_tod_alarm()
    print ahh, amm, ass, h, m, s
    assert ahh == h and amm == m and ass == s

    for i in range(1):
        t = time_req()
        print time.gmtime(t)
        # print time.gmtime(t).tm_sec, time.gmtime(time.time()).tm_sec
        time.sleep(.1)
    
    clear_eeprom()
    J = 'J'
    set_data(J, 'JS: TEST')
    delete_did(J)
    err_check()

    eeprom_read()
    clear_eeprom()
    print 'eeprom cleared?'
    eeprom_read()

    err_check()
    eeprom_read()
    err_check()
    msg = 'J--2'
    set_data(J, msg)
    eeprom_read()
    assert get_data(J) == msg
    err_check()

    msg = 'This is a test. '
    set_data(chr(12), msg + '12')
    err_check()
    print 'msg 12?', get_data(chr(12))
    delete_did(chr(12))
    set_data(chr(1), msg + '1')
    err_check()
    print get_data(chr(1))
    set_data(chr(2), msg + '2')
    err_check()
    print get_data(chr(2))
    eeprom_read()
    clear_eeprom()
    eeprom_read()

if __name__ == '__main__':
    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            if arg == 'clear':
                clear_eeprom()
                print 'eeprom cleared'
            elif arg == 'set':
                time_set()
                print '      C3 time',  fmt_time(time.gmtime(time_req()))
            elif arg == 'read':
                eeprom_read(full=True)
            elif arg == 'time':
                print '      C3 time',  fmt_time(time.gmtime(time_req()))
            elif arg == 'next':
                next = get_next_alarm()
                try:
                    next = time.gmtime(next)
                    print 'next alarm at', fmt_time(next)
                except ValueError, e:
                    print 'error getting next alarm:'
                    print e
                    print next
            elif arg == 'mode':
                trigger_mode()
            elif arg == 'pc_time':
                print '     PC TIME:', fmt_time(time.gmtime(to_gmt(time.time())))
            else:
                print 'huh?', arg
    else:
        eeprom = EEPROM() # singlton instance
        # read_write_test()
        main()
