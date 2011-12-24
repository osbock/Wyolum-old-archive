from pylab import *
from numpy import *
from scipy import *

f = open('pps.dat')
gdat = []
ddat = []
rdat = []
for l in f.readlines():
    try:
        if l.startswith('G '):
            l = l.split()
            gdat.append((int(l[1]), int(l[2]), int(l[3])));
        elif l.startswith('R '):
            l = l.split()
            rdat.append((int(l[1]), int(l[2]), int(l[3])));
        elif l.startswith('D '):
            l = l.split()
            ddat.append((int(l[1]),int(l[2])))
    except Exception, e:
        print e
gdat = array(gdat)
rdat = array(rdat)
ddat = array(ddat)
figure(1)
plot(gdat[:,0], gdat[:,1], 'r--')
plot(gdat[:,0], gdat[:,2], 'r-')
plot(rdat[:,0], rdat[:,1], 'b--')
plot(rdat[:,0], rdat[:,2], 'b-')
figure(2)
plot(ddat)
show()
