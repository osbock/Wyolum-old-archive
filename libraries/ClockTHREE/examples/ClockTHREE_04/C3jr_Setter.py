from __future__ import print_function
from Tkinter import *
from C3jr_interface import *
connect()

def do_set(*args, **kw):
    for i in range(10):
        try:
            time_set(time.time() - 3600 * 4)
            break
        except AssertionError:
            print('here')
            time.sleep(1000)
    print('      C3JR time',  fmt_time(time.gmtime(time_req())))

def do_get(*args):
    print('      C3JR time',  fmt_time(time.gmtime(time_req())))

tk = Tk()
f = Frame(tk)
Button(f, text="Set!", command=do_set).pack()
Button(f, text="Get!", command=do_get).pack()

f.pack()
tk.mainloop()
