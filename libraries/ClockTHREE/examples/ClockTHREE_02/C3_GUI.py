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
                    tm = time.localtime()
                self.date = Pmw.EntryField(self.f,
                                           label_text=label,
                                           labelpos='w',
                                           value=time.strftime('%Y/%m/%d', tm),
                                           validate = 'date')
                self.time = Pmw.EntryField(self.f,
                                           value=time.strftime('%H:%M:%S', tm),
                                           validate='time')
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

        class Repeat:
            def __init__(self, parent, row, column):
                vars = [Tkinter.IntVar() for i in range(8)]
                for i, var in enumerate(vars):
                    c = Tkinter.Checkbutton(parent, text="", variable=var)
                    c.grid(row=row, column=column + i)

        class Countdown:
            def __init__(self, parent, row, column):
                var = Tkinter.IntVar()
                for i in range(6):
                    c = Tkinter.Radiobutton(parent, text="", variable=var, value=i)
                    c.grid(row=row, column=column + i)

        class DID_AlarmField:
            def __init__(self, parent, row):
                self.did = None
                def set():
                    print 'set', row
                def clear():
                    print 'clear', row
                Tkinter.Button(parent, text='Set', command=set).grid(row=row, column=0)
                Tkinter.Button(parent, text='Clear', command=clear).grid(row=row, column=1)
                when = DatetimeField(parent, '', None, getcmd=None, setcmd=None, clearcmd=None)
                when.grid(row=row, column=2)
                scrollable = Pmw.EntryField(parent, value='Scrollable Text')
                scrollable.component('entry').config(width=40)
                scrollable.grid(row=row, column=3)
                Repeat(parent, row=row, column=4)
                Countdown(parent, row=row, column=12)

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
        combo = Pmw.ComboBox(self.control_right,
                             label_text='GMT Offset (Hours):',
                             labelpos='w',
                             scrolledlist_items=map(str, arange(-12, 12, .5))
                             )
        combo.component('entry').config(width=6)
        combo.grid(row=3)
        alarm_frame = Tkinter.Frame(self.control_right)
        alarm = Pmw.EntryField(alarm_frame,
                               label_text='Daily Alarm:',
                               labelpos='w',
                               value='00:00:00',
                               validate='time')

        alarm.component('entry').config(width=7)
        alarm.grid(row=0, column=0)
        alarmset = Tkinter.IntVar()
        c = Tkinter.Checkbutton(alarm_frame, text="", variable=alarmset)
        c.grid(row=0, column=2)
        Tkinter.Button(alarm_frame, text="Set", command=alarm_set).grid(row=0, column=3)
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

        for row in range(2, 14):
            dida = DID_AlarmField(did_frame, row)
        did_frame.grid(row=5)

        self.root.title('Pmw megawidgets example')
        self.root.after(1000, self.tick)
        self.root.mainloop()

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

def synctime(args=None):
    C3_interface.time_set()

def alarm_set():
    print 'alarm_set()'

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
