#!/usr/bin/python

import shapefile 
import csv
import struct

from Polygon import *
from Polygon.Shapes import Star, Circle, Rectangle, SierpinskiCarpet
from Polygon.IO import *
from Polygon.Utils import convexHull, tile, tileEqual, tileBSP, reducePoints, cloneGrid
import random, math

def makeDB():
    tz_shapes = shapefile.Reader('tz_world.shp')

    gmts = [l.split('\t') for l in open('gmt_offsets.csv').readlines()]
    header = gmts[0]
    gmts = gmts[1:]
    ST_i = 5
    DST_i = 6
    NAME_i = 3

    def toMin(st):
        sign = [-1, 1][st[0] == '+']
        hh = st[1:3]
        if ':' in st:
            mm = st[4:6]
        else:
            mm = 0
        minutes = sign * (int(hh) * 60 + int(mm))
        return int(minutes)

    def getST(tz):
        st = tz[ST_i][3:]
        return toMin(st)

    def getDST(tz):
        if tz[DST_i] == '-':
            out = getST(tz)
        else:
            out = toMin(tz[DST_i][3:])
        return out

    class TimeZone:
        def __init__(self, tz):
            self.name = tz[NAME_i]
            self.tz = tz
            self.st = getST(tz)
            self.dst = getDST(tz)
            self.shapes = []
            self.polygons = []

        def contains(self, x, y):
            out = False
            for poly in self.polygons:
                if poly.isInside(x, y):
                    out = True
                    break
            return out
        def add(self, shape):
            self.polygons.append(Polygon(shape.points))
            self.shapes.append(shape)

    tzs = {}    
    tz_db = {}
    for tz in gmts:
        tzs[tz[NAME_i]] = tz
        tz_db[tz[NAME_i]] = TimeZone(tz)
    print len(tz_shapes.records())
    here
    for record, shape in zip(tz_shapes.records(), tz_shapes.shapes()):
        name = record[0]
        try:
            if name == 'uninhabited':
                continue
            tz = tz_db[name]
            tz.add(shape)
        except KeyError:
            print name, 'missing'
            pass
            # skip for now, can choose closest later

    def findtz(lat, lon):
        out = None
        for name in tz_db:
            tz = tz_db[name]
            if tz.contains(lon, lat):
                out = tz
        return out

    f = open('latlontzXX.txt', 'w')    
    for lat in range(-60, 61, 1):
        print lat
        for lon in range(-1800, 1800):
            tz = findtz(lat, lon/10.)
            if tz:
                name = tz.name
                st = tz.st
                dst = tz.dst
            else:
                name = 'Not found'
                st = (lon / 10) / 15 * 60
                dst = st
            print >> f, '%03d %05d %s %05d %05d' % (lat, lon, name[-30:].rjust(30), st, dst)
makeDB()
def makelatfiles():
    f = open('latlontz.txt')
    for lat in range(-60, 61):
        if lat < 0:
            ns = 'S'
        else:
            ns = 'N'
        out = open('LAT_FILES/%02d%s.BIN' % (abs(lat), ns), 'wb')
        print out.name
        current = []
        for lon in range(0, 3600):
            line = f.readline()
            _lat = int(line.split()[0])
            assert lat == _lat, '%s != %s' % (lat, _lat)
            _lon = int(line.split()[1])
            name = line[10:40].rjust(30)
            if name.endswith('Not found'):
                name = ' ' * 30
            st = int(line[41:46])
            dst = int(line[47:52])
            current.append((_lon % 3600, name, st, dst))
        current.sort()
        for lon, name, st, dst in current:
            out.write(name)
            out.write(struct.pack('hhhh', lat, lon%3600, st, dst))
# makelatfiles()          
def test_file():
    f = open('LAT_FILES/30S.BIN')
    lat = 49
    for i in range(1800, 3600, 100):
        lon = i
        f.seek(38 * i)
        name = f.read(30)
        lat, lon, st, dst = struct.unpack('hhhh', f.read(8))
        print name, lat, lon, st, dst
test_file()
