import struct
import time

def euroDST_times(year):
    ## last sunday of March at 1:00
    day = 31
    wday = time.localtime(time.mktime((year, 3, day, 1, 0, 0, 0, 0, 0))).tm_wday
    day -= wday + 1
    start = time.mktime((year, 3, day, 1, 0, 0, 0, 0, 0))

    # to last sunday in october at 1:00
    day = 31
    wday = time.localtime(time.mktime((year, 10, day, 1, 0, 0, 0, 0, 0))).tm_wday
    day -= wday + 1
    end = time.mktime((year, 10, day, 1, 0, 0, 0, 0, 0))
    return int(start), int(end)

def amerDST_times(year):
    ## 2nd sunday of March at 1:00
    day = 8
    wday = time.localtime(time.mktime((year, 3, day, 1, 0, 0, 0, 0, 0))).tm_wday
    day += 6 - wday
    start = time.mktime((year, 3, day, 1, 0, 0, 0, 0, 0))
    # to last sunday in october at 1:00
    day -= 7
    end = time.mktime((year, 11, day, 1, 0, 0, 0, 0, 0))
    return int(start), int(end)

def write_EU():
    f = open('EU_DST.DAT', 'wb')
    for year in range(2000, 2100, 1):
        start, end = euroDST_times(year)
        assert(time.localtime(start)).tm_wday == 6
        assert(time.localtime(end)).tm_wday == 6
        f.write(struct.pack('LL', start, end))
    print 'wrote', f.name
def write_dst():
    f = open('DST.DAT', 'wb')
    for year in range(2000, 2100, 1):

        start, end = amerDST_times(year)
        assert(time.localtime(start)).tm_wday == 6, 'start %s !=6' % (time.localtime(start)).tm_wday
        assert(time.localtime(end)).tm_wday == 6, 'end %s !=6' % (time.localtime(end)).tm_wday

        estart, eend = euroDST_times(year)
        assert(time.localtime(start)).tm_wday == 6, 'start %s !=6' % (time.localtime(start)).tm_wday
        assert(time.localtime(end)).tm_wday == 6, 'end %s !=6' % (time.localtime(end)).tm_wday
        f.write(struct.pack('IIII', start, end, estart, eend))
        print start, end, estart,eend
    print 'wrote', f.name
write_dst()
