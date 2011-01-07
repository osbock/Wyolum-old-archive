import serial
import time
import datetime
import wx
from wx.lib.analogclock import *
import struct

# BAUDRATE = 115200
BAUDRATE = 57600

SYNC = chr(0xEF) * 2

serialport = '/dev/ttyUSB0'

ser = serial.Serial(serialport, baudrate=BAUDRATE, timeout=.5)
raw_input('...')
ser.flush()
PING = 0x12
payload = 'A23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
gmt_offset = -5 * 3600

def time_req():
    ser.write(chr(0x01))
    dat = ser.read(4)
    if len(dat) < 4:
        out = 0
    else:
        out = struct.unpack('<I', dat)[0]
    return out

def time_set():
    now = int(round(time.time())) + gmt_offset
    dat = struct.pack('<I', now)
    ser.write(chr(0x02))
    ser.write(dat)
    
def set_tod_alarm(h, m, s, is_set):
    dat = (h * 60 + m) * 60 + s
    dat = struct.pack('<I', dat)
    ser.write(chr(0x04))
    ser.write(dat)
    ser.write(chr(is_set))

def get_tod_alarm():
    ser.write(chr(0x03))
    ser_data = ser.read(6)
    if len(ser_data) < 6:
        raise ValueError('Got bad tod_alarm_msg, l=%d: "%s"' % (len(ser_data), ser_data))
    assert ser_data[0] == chr(0x04)
    hms = struct.unpack('<I', ser_data[1:5])[0]
    h, ms = divmod(hms , 60 * 60)
    m, s = divmod(ms, 60)
    return h, m, s, bool(ser_data[5])

def set_data(id, data):
    # MID, len(payload)
    l = len(data)
    out = '%s%s%s%s%s' % (chr(0x70), chr(l + 4), chr(id), chr(l + 2),  data)
    print 'OUT:', out
    assert len(out) == len(data) + 4, '%s != %s' % (len(out), len(data) + 4)
    ser.write(out)
    time.sleep(.1)

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

def eeprom_read():
    err_check()
    ser.write(chr(0x14))
    eeprom = ser.read(1024)
    print len(eeprom), ':len eeprom'
    for r in range(128):
        print '0x%03x  -- ' % (r * 8),
        for i in range(8):
            print '%2x' % ord(eeprom[r * 8 + i]),
        print ""
    print 
    n = ord(eeprom[-1])
    print 'N:', n
    addr = 0
    for i in range(n):
        did = eeprom[addr]
        l = ord(eeprom[addr + 1])
        print ord(did), l, 
        for j in range(2, l):
            print '0x%02x' % ord(eeprom[addr + j]),
        print eeprom[addr + 2: addr + l]
        addr += l
class ClockTHREE_Error(Exception):
    pass
def get_data(id):
    ser.write(chr(0x05))
    ser.write(chr(id))
    head = ser.read(1)
    if head == chr(0x71):
        l = ord(ser.read(1))
        err = 'ERROR: ' + ser.read(l)
        raise ClockTHREE_Error(err)
    assert head == chr(0x70), ('? 0x%x' % ord(head))
    n_byte = ord(ser.read(1))
    # print 'N_BYTE:', n_byte
    assert ord(ser.read(1)) == id
    
    out = ser.read(n_byte - 3)
    # print 'out:', out
    # print 'equal?', len(out), n_byte - 3
    assert ord(out[0]) - 1 == len(out), '%s != %s' % (ord(out[0]), len(out))
    return out[1:]

def sync():
    ser.write(SYNC)

def ping():
    ser.write(chr(PING))
    ser.write(payload)
    out = ser.read(99)
    # print out
    return out
def clear_eeprom():
    out = chr(0x13) * 20
    ser.write(out)
    time.sleep(5)
def delete_did(did):
    ser.write(chr(0x06))
    ser.write(chr(did))
    time.sleep(1)

while ping() != payload:
    sync();
print 'ping ok'

time_set()

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

# eeprom_read()
# clear_eeprom()
print 'eeprom cleared?'
eeprom_read()

J = ord('J')
set_data(J, 'ZERO')
print 'readback?', get_data(J), len(get_data(J))
delete_did(J)

err_check()
eeprom_read()
err_check()
msg = 'J--2'
set_data(J, msg)
eeprom_read()
get_data(J) == msg
err_check()

msg = 'This is a test. '
set_data(12, msg + '12')
err_check()
print 'msg 12?', get_data(12)
delete_did(12)
set_data(1, msg + '1')
err_check()
print get_data(1)
set_data(2, msg + '2')
err_check()
print get_data(2)
eeprom_read()
clear_eeprom()
eeprom_read()
