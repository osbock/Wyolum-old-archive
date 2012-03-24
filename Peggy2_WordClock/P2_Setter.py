from __future__ import print_function
from Tkinter import *
from P2_interface import *
connect()

def do_set(*args, **kw):
    time_set(time.time() - 3600 * 3)
    print('      P2 time',  fmt_time(time.gmtime(time_req())))

def do_get(*args):
    print('      P2 time',  fmt_time(time.gmtime(time_req())))

tk = Tk()
f = Frame(tk)
Button(f, text="Set!", command=do_set).pack()
Button(f, text="Get!", command=do_get).pack()

f.pack()
tk.mainloop()
