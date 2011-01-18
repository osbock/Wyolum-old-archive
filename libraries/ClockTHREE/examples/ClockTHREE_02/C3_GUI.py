import time
from numpy import *
import Tkinter
import Pmw
import C3_interface
    
class Main:
    def __init__(self, com):
        self.com = com
        self.root = Pmw.initialise(fontScheme='pmw1')
        self.eeprom = None
        class DatetimeField:
            def __init__(self, parent, label, tm=None, getcmd=None, setcmd=None, clearcmd=None):
                self.tk = parent
                self.f = Tkinter.Frame(parent)
                now = time.time()
                if tm is None:
                    time_val = ''
                    date_val = ''
                else:
                    time_val = time.strftime('%H:%M:%S', tm)
                    date_val = time.strftime('%Y/%m/%d', tm)
                self.date = Pmw.EntryField(self.f,
                                           label_text=label,
                                           value=date_val,
                                           labelpos='w',
                                           validate = 'date'
                                           )
                self.time = Pmw.EntryField(self.f,
                                           value=time_val,
                                           validate='time'
                                           )
                self.update(tm)
                self.wids = [self.date, self.time]
                self.wids[0].component('entry').config(width=9)
                self.wids[1].component('entry').config(width=7)
                if setcmd:
                    self.wids.insert(0, Tkinter.Button(self.f, text='Set', command=setcmd))
                if getcmd:
                    self.wids.insert(0, Tkinter.Button(self.f, text='Get', command=getcmd))
                if clearcmd:
                    self.wids.insert(0, Tkinter.Button(self.f, text='Clear', command=clearcmd))

            def grid(self, *args, **kw):
                for i, wid in enumerate(self.wids):
                    wid.grid(row=0, column=i)
                self.f.grid(*args,**kw)
            
            def update(self, tm=None):
                if tm is None:
                    time_val = ''
                    date_val = ''
                else:
                    time_val = time.strftime('%H:%M:%S', tm)
                    date_val = time.strftime('%Y/%m/%d', tm)
                self.date.setvalue(date_val)
                self.time.setvalue(time_val)
                self.date.checkentry()
                self.time.checkentry()

        class Repeat:
            def __init__(self, parent, row, column):
                self.vars = [Tkinter.IntVar() for i in range(8)]
                self.checks = []
                for i, var in enumerate(self.vars):
                    c = Tkinter.Checkbutton(parent, text="", variable=var, command=self.update)
                    c.grid(row=row, column=column + i)
                    self.checks.append(c)

            def update(self):
                annual = self.vars[-1].get()
                if annual:
                    for i, var in enumerate(self.vars[:-1]):
                        var.set(False)
                        self.checks[i].config(state=Tkinter.DISABLED)
                else:
                    for i, var in enumerate(self.vars[:-1]):
                        self.checks[i].config(state=Tkinter.NORMAL)
                    
            def set(self, byte):
                byte = ord(byte)
                n = True
                for i in range(8):
                    if byte & (1 << i):
                        n = False
                        self.vars[i].set(True)
                    else:
                        self.vars[i].set(False)
                if n:
                    pass # set annual
                else: 
                    pass # unset annual
                    
        class Countdown:
            def __init__(self, parent, row, column):
                self.radio_buttons = []
                var = Tkinter.IntVar()
                for i in range(6):
                    c = Tkinter.Radiobutton(parent, text="", variable=var, value=i)
                    c.grid(row=row, column=column + i)
                    self.radio_buttons.append(c)

            def set(self, byte):
                if type(byte) == type(''):
                    byte = ord(byte)
                val = byte & 0b00011111
                self.radio_buttons[-1].select()

                for i in range(5):
                    if val & (1 << i):
                        self.radio_buttons[-1].deselect()
                        self.radio_buttons[5 - i].select()
                    else:
                        self.radio_buttons[5 - i].deselect()
                        
                    
        class DID_AlarmField:
            def __init__(self, parent, row):
                self.did = None
                def set():
                    print 'set', row
                def clear():
                    print 'clear', row
                Tkinter.Button(parent, text='Set', command=set).grid(row=row, column=0)
                Tkinter.Button(parent, text='Clear', command=clear).grid(row=row, column=1)
                self.when = DatetimeField(parent, '', None, getcmd=None, setcmd=None, clearcmd=None)
                self.when.grid(row=row, column=2)
                self.scrollable = Pmw.EntryField(parent, value='')
                self.scrollable.component('entry').config(width=40)
                self.scrollable.grid(row=row, column=3)
                self.repeat = Repeat(parent, row=row, column=4)
                self.countdown = Countdown(parent, row=row, column=12)
                self.row = row
            def update(self, tm):
                self.when.update(tm)
                
        c3tm = self.getC3_time()
        pctm = time.localtime()
        self.control_frame = Tkinter.Frame(self.root)
        self.control_left = Tkinter.Frame(self.control_frame)
        self.control_right = Tkinter.Frame(self.control_frame)
        Tkinter.Button(self.control_left, text="Connect", command=self.connect).grid(row=0, column=0)
        self.ardtime = DatetimeField(self.control_right, 'Arduino Time', c3tm)
        self.ardtime.grid(row=0)
        self.pctime = DatetimeField(self.control_right, '       PC Time', pctm)
        self.pctime.grid(row=1)
        delta_frame = Tkinter.Frame(self.control_right)
        self.delta = Pmw.EntryField(delta_frame, 
                                    label_text='Delta Seconds:',
                                    labelpos='w',
                                    value='0',
                                    validate='real',
                                    )
        self.delta.component('entry').config(width=6)
        self.delta.grid(row=0, column=0)
        Tkinter.Button(delta_frame, text="SYNC", command=synctime).grid(row=0, column=1)
        delta_frame.grid(row=2)
        timezones = map(str, arange(-12, 12, .5))
        combo = Pmw.ComboBox(self.control_right,
                             label_text='GMT Offset (Hours):',
                             labelpos='w',
                             scrolledlist_items=timezones,
                             selectioncommand=self.gmt_change,
                             )
        combo.component('entry').config(width=6)
        local_time = time.localtime()
        tz = (local_time.tm_isdst - time.timezone / 3600.)
        i = timezones.index(str(tz))
        combo.selectitem(i)
        combo.grid(row=3)
        alarm_frame = Tkinter.Frame(self.control_right)
        self.alarm_entry = Pmw.EntryField(alarm_frame,
                                          label_text='Daily Alarm:',
                                          labelpos='w',
                                          value='00:00:00',
                                          validate='time')

        self.alarm_entry.component('entry').config(width=7)
        self.alarm_entry.grid(row=0, column=0)
        self.alarm_isset = Tkinter.IntVar()
        alarm_set_c = Tkinter.Checkbutton(alarm_frame, text="", variable=self.alarm_isset)
        alarm_set_c.grid(row=0, column=2)
        Tkinter.Button(alarm_frame, text="Set", command=self.alarm_set).grid(row=0, column=3)
        alarm_frame.grid(row=4)
        self.control_left.grid(row=0, column=0)
        self.control_right.grid(row=0, column=1)
        self.control_frame.grid(row=0)
        # f = Tkinter.Frame(self.root)
        def getter():
            pass
        def setter():
            pass

        did_frame = Tkinter.Frame(self.root)
        Tkinter.Label(did_frame, text='Repeat').grid(row=0, column=4, columnspan=8)
        Tkinter.Label(did_frame, text='Countdown').grid(row=0, column=11, columnspan=6)
        Tkinter.Label(did_frame, text='When').grid(row=1, column=2)
        Tkinter.Label(did_frame, text='Scrollable Text').grid(row=1, column=3)
        Tkinter.Label(did_frame, text="S").grid(row=1, column=4)
        Tkinter.Label(did_frame, text="M").grid(row=1, column=5)
        Tkinter.Label(did_frame, text="T").grid(row=1, column=6)
        Tkinter.Label(did_frame, text="W").grid(row=1, column=7)
        Tkinter.Label(did_frame, text="T").grid(row=1, column=8)
        Tkinter.Label(did_frame, text="F").grid(row=1, column=9)
        Tkinter.Label(did_frame, text="S").grid(row=1, column=10)
        Tkinter.Label(did_frame, text="A").grid(row=1, column=11)

        Tkinter.Label(did_frame, text="D").grid(row=1, column=12)
        Tkinter.Label(did_frame, text="H").grid(row=1, column=13)
        Tkinter.Label(did_frame, text="5M").grid(row=1, column=14)
        Tkinter.Label(did_frame, text="M").grid(row=1, column=15)
        Tkinter.Label(did_frame, text="10").grid(row=1, column=16)
        Tkinter.Label(did_frame, text="N").grid(row=1, column=17)

        didas = [] #did alarm fields
        for row in range(2, 14):
            dida = DID_AlarmField(did_frame, row)
            didas.append(dida)
        self.didas = didas
        did_frame.grid(row=5)

        self.root.title('Pmw megawidgets example')
        self.root.after(1000, self.tick)
        self.root.mainloop()

    def gmt_change(self, args):
        C3_interface.set_gmt_offset(float(args) * 3600)
        

    def tick(self):
        c3tm = self.getC3_time()
        pctm = time.localtime()
        diff = time.mktime(c3tm) - time.mktime(pctm)
        self.ardtime.date.component('entry').delete(0, Tkinter.END)
        self.ardtime.time.component('entry').delete(0, Tkinter.END)
        self.pctime.date.component('entry').delete(0, Tkinter.END)
        self.pctime.time.component('entry').delete(0, Tkinter.END)
        self.delta.component('entry').delete(0, Tkinter.END)
        
        self.ardtime.date.component('entry').insert(
            0, 
            time.strftime('%Y/%m/%d', c3tm))
        self.ardtime.time.component('entry').insert(
            0, 
            time.strftime('%H:%M:%S', c3tm))

        self.pctime.date.component('entry').insert(
            0, 
            time.strftime('%Y/%m/%d', pctm))
        self.pctime.time.component('entry').insert(
            0, 
            time.strftime('%H:%M:%S', pctm))
        self.delta.component('entry').insert(
            0,
            str(diff)
            )
        self.root.after(1000, self.tick)

    def getC3_time(self):
        if self.eeprom:
            t = C3_interface.time_req()
        else:
            t = 0
        out = time.gmtime(t)
        return out

    def connect(self):
        C3_interface.connect(self.com)
        self.eeprom = C3_interface.EEPROM()
        self.alarm_get()
        for i, did in enumerate([d for d in self.eeprom.dids if d <= C3_interface.MAX_ALARM_DID]):
            when, scroll_text, repeat, countdown = self.eeprom.read_did_alarm(did)
            self.didas[i].did = did
            self.didas[i].update(when)
            self.didas[i].scrollable.delete(0, Tkinter.END)
            self.didas[i].scrollable.insert(0, scroll_text)
            self.didas[i].repeat.set(repeat)
            self.didas[i].countdown.set(countdown)
                
            
            
    def alarm_set(self):
        h, m, s = self.alarm_entry.getvalue().split(':')
        is_set = self.alarm_isset.get()
        C3_interface.set_tod_alarm(int(h), int(m), int(s), is_set)
        
    def alarm_get(self):
        h, m, s, is_set = C3_interface.get_tod_alarm()
        self.alarm_entry.setvalue("%02d:%02d:%02d" % (h, m, s))
        self.alarm_isset.set(is_set)

def synctime(args=None):
    C3_interface.time_set()


usage = '''
Linux example:
python C3_GUI.py /dev/ttyusb0

Windows Example:
python C3_GUI.py COM1
'''

if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1:
        com = sys.argv[1]
        if sys.platform == 'win32':
            com = int(com[-1]) - 1
        Main(com)
    else:
        print usage
