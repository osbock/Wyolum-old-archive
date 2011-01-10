import serial
import time
import datetime
import wx
from wx.lib.analogclock import *
import struct

from C3_interface import *

ping()
print 'ping ok'

time_set()

t = int(round(time.time())) + gmt_offset
alm_time = time.gmtime(t + 2)
is_set = True
set_tod_alarm(alm_time.tm_hour, alm_time.tm_min, alm_time.tm_sec, is_set)
now = time.gmtime(time_req())
print 'my alarm time:', alm_time.tm_hour, alm_time.tm_min, alm_time.tm_sec, is_set
print 'set alarm time:', get_tod_alarm();
if 1:
    now = time.gmtime(time_req())
    print 'now:', now.tm_hour, now.tm_min, now.tm_sec
    trigger_mode()
