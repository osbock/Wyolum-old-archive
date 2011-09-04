 # -*- coding: latin-1 -*-

import string
from numpy import *
import PIL.Image
from reportlab.pdfgen import canvas
from reportlab.graphics import renderPDF
from reportlab.graphics.shapes import Drawing, Group, String, Circle, Rect
from reportlab.lib.units import inch, mm, cm
from reportlab.lib.colors import pink, black, red, blue, green, white
from reportlab.platypus import Paragraph, SimpleDocTemplate, Table, TableStyle
import reportlab.rl_config
import codecs
reportlab.rl_config.warnOnMissingFontGlyphs = 0
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
import glob
import os.path

from numpy import arange
from copy import deepcopy

DEFAULT_FONT_SIZE = 30
LASER_THICKNESS = .006 * inch
DTHETA = 1
DEG = pi/180.


letters = '''KITRISCTENHALFX english = '''KITRISCTENHALFX 
QUARTERTWENTYBZ 
IFIVECMINUTESAL 
PASTOBTWONEIGHTS
THREELEVENSIXTEN
FOURFIVESEVENINE
TWELVEXOCLOCKYAM
PMYDMTHWMFSUALR!'''.splitlines()

temps = '''\
ITS-A-LITTLE----
WARMERCOOLER----
HOTTERCOLDER----
THAN-UNBEARABLY-
HOTCOLD-PERFECT-
CHILLYFREEZING--
TOASTYOUTSIDE---
IN-HEREWYOLUM---'''.splitlines()

german = '''\
ES-IST-VIERTEL--
FÜNF-ZWANZIGZEHN
VORNACH-HALB----
EINSZWEIDREI---- 
VIERFÜNFSECHS-- 
SIEBENACHTZWÖLF 
ZEHNELFNEUN-UHR 
-JMTUMSALARM---'''.splitlines()

# letters = ['.' * 16] * 8
letters = german

class MyPath:
    UNIT = mm
    def __init__(self):
        self.points = []
        self.paths = []
        self.holes = []
        self.subtract = []
    def copy(self):
        out = MyPath()
        out.points = deepcopy(self.points)
        out.paths = deepcopy(self.paths)
        out.holes = deepcopy(self.holes)
        out.subtract = deepcopy(self.subtract)
        return out
        
    def moveTo(self, x, y):
        self.points.append([x, y])
        self.paths.append([])
        self.paths[-1].append(len(self.points) - 1)
    def lineTo(self, x, y):
        self.points.append([x, y])
        self.paths[-1].append(len(self.points) - 1)

    def getleft(self):
        return min([l[0] for l in self.points])
    def getright(self):
        return max([l[0] for l in self.points])
    def getbottom(self):
        return min([l[1] for l in self.points])
    def gettop(self):
        return max([l[1] for l in self.points])
    
    def toPDF(self, filename):
        W = self.getright() - self.getleft()
        H = self.gettop() - self.getbottom()
        c = canvas.Canvas(filename,
                          pagesize=(W + .5 * inch, H + .5 * inch)
                          )
        # c.setLineWidth(LASER_THICKNESS)#px
        c.setLineWidth(.5)#px
        self.translate(-self.getleft() + .25 * inch, -self.getbottom() + .25 * inch)
        self.drawOn(c)
        return c

    def drawOn(self, c, linewidth=LASER_THICKNESS):
        c.setStrokeColor(red)
        c.setLineWidth(linewidth)
        p = c.beginPath()
        for path in self.paths:
            p.moveTo(*self.points[path[0]])
            for i in path[1:]:
                p.lineTo(*self.points[i])
        for x, y, r in self.holes:
            c.circle(x, y, r)
        for poly in self.subtract:
            poly.drawOn(c)
        c.drawPath(p)

    def rotate(self, rotate_deg):
        theta = rotate_deg * pi / 180.
        rot_mat = array([[cos(theta), -sin(theta)],
                         [sin(theta), cos(theta)]])
        self.points = list(dot(self.points, rot_mat))

    def translate(self, dx, dy):
        for l in self.points:
            l[0] += dx
            l[1] += dy
        for xyr in self.holes:
            xyr[0] += dx
            xyr[1] += dy
        for s in self.subtract:
            s.translate(dx, dy)
    def scale(self, f):
        for l in self.points:
            l[0] *= f
            l[1] *= f
        for xyr in self.holes:
            xyr[0] *= f
            xyr[1] *= f
            xyr[2] *= f
        for s in self.subtract:
            s.scale(f)
    def rect(self, bbox):
        self.moveTo(bbox[0], bbox[1])
        self.lineTo(bbox[0] + bbox[2], bbox[1])
        self.lineTo(bbox[0] + bbox[2], bbox[1] + bbox[3])
        self.lineTo(bbox[0], bbox[1] + bbox[3])
        self.lineTo(bbox[0], bbox[1])
        
    def drill(self, x, y, r):
        self.holes.append([x, y, r])
    def route(self, polygon):
        self.subtract.append(deepcopy(polygon))
    def getBottom(self):
        return min(l[1] for l in self.points)
    def getTop(self):
        return max(l[1] for l in self.points)
    def getLeft(self):
        return min(l[0] for l in self.points)
    def getRight(self):
        return max(l[0] for l in self.points)
    def toOpenScad(self, thickness, outfile, module_name=None, color=None):
        if module_name is not None:
            print >> outfile, 'module %s(){' % module_name
        if color is not None:
            print >> outfile, 'color([%s, %s, %s, %s])' % tuple(color)
        if len(self.holes) > 0 or len(self.subtract) > 0:
            print >> outfile, 'difference(){'
        print >> outfile, '''\
linear_extrude(height=%s, center=true, convexity=10, twist=0)
polygon(points=[''' % (thickness / self.UNIT)
        for x, y in self.points:
            print >> outfile, '[%s, %s],' % (x / self.UNIT, y / self.UNIT)
        print >> outfile, '],'
        print >> outfile, 'paths=['
        for path in self.paths:
            print >> outfile, '%s,' % path
        print >> outfile, ']);'

        if len(self.holes) > 0 or len(self.subtract) > 0:
            for hole in self.holes:
                x, y, r = hole
                print >> outfile, 'translate(v=[%s, %s, %s])' % (x/self.UNIT, y/self.UNIT, -5*inch)
                print >> outfile, 'cylinder(h=%s, r=%s, $fn=25);' % (10*inch, r / self.UNIT)
            for poly in self.subtract:
                print >> outfile, '//subtract'
                ## print >> outfile, 'translate(v=[0, 0, -%s])' % (thickness / self.UNIT)
                poly.toOpenScad(thickness * 2, outfile)
            print >> outfile, '}'
        if module_name is not None:
            print >> outfile, '}'

class Keyhole(MyPath):
        def __init__(self):
            MyPath.__init__(self)

            Center = 0.75 * inch, 7.5 * inch  # larger keyhole circle center
            center = 0.75 * inch, 7.875 * inch # smaller keyhole circle center
            r = .125 * inch # smaller keyhole circle radius
            R = .25 * inch  # larger keyhole circle radius
            phi = arcsin(r/R)
            
            start = Center[0] + R * cos(pi/2 + phi), Center[1] + R * sin(pi/2 + phi)
            self.moveTo(*start)
            for theta in arange(pi/2 + phi,
                                2 * pi + pi / 2 - phi +DTHETA*DEG/2,
                                DTHETA * DEG):
                next = Center[0] + R * cos(theta), Center[1] + R * sin(theta)
                self.lineTo(*next)
            for theta in arange(0, pi, DTHETA * DEG):
                next = center[0] + r * cos(theta), center[1] + r * sin(theta)
                self.lineTo(*next)
            self.lineTo(*start)

MARGIN = LASER_THICKNESS/2

def create_baffle(baffle_height, 
                  baffle_thickness, 
                  n_notch, 
                  delta,
                  overhang=0,
                  overhang_height=None,
                  overhang_taper=False,
                  margin=MARGIN):
    '''
    delta = DX/DY
    overhang = amount of extra plastic from center of last notch    
    overhang_height = height of overhang.  if None, baffle_height
    margin = extra gap for slots
    '''

    if overhang_height is None:
        overhang_height = baffle_height

    p = MyPath()
    p.moveTo(0, 0)
    if overhang > 0:
        p.lineTo(-overhang, 0)
        if overhang_taper:
            p.lineTo(-overhang, overhang_height/2)
        else:
            p.lineTo(-overhang, overhang_height)
        p.lineTo(-baffle_thickness / 2. - margin, overhang_height)
        p.lineTo(-baffle_thickness / 2. - margin,
                  baffle_height / 2 - margin)
    p.lineTo(0, baffle_height / 2 - margin)
    for i in range(n_notch):
        p.lineTo(i * delta + baffle_thickness / 2. + margin,
                  baffle_height / 2 - margin)
        p.lineTo(i * delta + baffle_thickness / 2. + margin,
                  baffle_height)

        p.lineTo((i + 1) * delta - baffle_thickness / 2. - margin,
                  baffle_height)
        p.lineTo((i + 1) * delta - baffle_thickness / 2. - margin,
                  baffle_height / 2 - margin)
        p.lineTo((i + 1) * delta,
                  baffle_height / 2 - margin)
    if overhang > 0:
        p.lineTo(n_notch * delta + baffle_thickness / 2 + margin,
                 baffle_height / 2 - margin)
        p.lineTo(n_notch * delta + baffle_thickness / 2 + margin,
                 overhang_height)
        if overhang_taper:
            p.lineTo(n_notch * delta + overhang, overhang_height/2)
        else:
            p.lineTo(n_notch * delta + overhang, overhang_height)
        p.lineTo(n_notch * delta + overhang, 0)
    p.lineTo(n_notch * delta, 0)
    p.lineTo(0, 0)
    return p

pcb_thickness = 1.6 * mm
# nut_thickness = 0.05 * inch
nut_or = .27*inch / 2
nut_ir = .132*inch / 2
nut_thickness = 2.3 * mm # 2.4 * mm spec

standoff_thickness = 20 * mm
standoff_or = 5*mm / 2
standoff_ir = .132*inch / 2


baffle_thickness = .06 * inch
baffle_height = standoff_thickness - pcb_thickness - nut_thickness
print baffle_height / mm, (pcb_thickness + nut_thickness) / mm, pcb_thickness / inch

faceplate_thickness = .25*inch

dy = 0.7 * inch
dx = 0.4 * inch
N_ROW = 8
N_COL = 16

baffle_v = create_baffle(baffle_height=baffle_height, 
                  baffle_thickness=baffle_thickness,
                  n_notch=N_ROW,
                  delta=dy,
                  overhang=.2*inch,
                  overhang_height=baffle_height,
                  overhang_taper=True,
                  margin=MARGIN)

locator = MyPath()
locator.moveTo(MARGIN, MARGIN)
locator.lineTo(.28*inch - MARGIN, MARGIN)
locator.lineTo(.28*inch - MARGIN, dy - baffle_thickness - MARGIN)
locator.lineTo(MARGIN, dy - baffle_thickness - MARGIN)
locator.lineTo(MARGIN, MARGIN)

locator.drill((.28 * inch)/2, (dy - baffle_thickness)/2, 1.8 * mm)

class Image:
    def __init__(self, filename, x, y, w=None, h=None):
        self.filename = filename
        self.x = x
        self.y = y
        self.w = w
        self.h = h

    def drawOn(self, c):
        im = PIL.Image.open(self.filename)
        dims = im.size
        aspect = dims[1] / float(dims[0])
        if self.h is None and self.w is not None:
            self.h = aspect * self.w
            
        c.drawInlineImage(im, 
                          self.x, self.y, self.w, self.h)
    def translate(self, dx, dy):
        return Image(self.filename, self.x + dx, self.y + dy, self.w, self.h)


def add_crop(can, bbox):
    left = bbox[0]
    right = left + bbox[2]
    bottom = bbox[1]
    top = bottom + bbox[3]
    
    can.line(left - .5*inch, bottom, left - .05 * inch, bottom)
    can.line(right + .5*inch, bottom, right + .05 * inch, bottom)

    can.line(left - .5*inch, top, left - .05 * inch, top)
    can.line(right + .5*inch, top, right + .05 * inch, top)


    can.line(left, top + .5 * inch, left, top + .05 * inch)
    can.line(right, top + .5 * inch, right, top + .05 * inch)

    can.line(left, bottom - .5 * inch, left, bottom - .05 * inch)
    can.line(right, bottom - .5 * inch, right, bottom - .05 * inch)

def draw(filename, data, fontname='Times-Roman', images=[],
         fontsize= DEFAULT_FONT_SIZE,
         reverse=False,
         case=string.upper,
         seven_seg=False,
         ):
    W = 11 * inch
    H = 11 *inch
    can = canvas.Canvas(filename,
                        pagesize=(W, H))
    can.translate(1 * inch, 1 * inch)
    dx = .4 * inch
    dy = .7 * inch
    data = [[case(char) for char in line] for line in data]
    ys = arange(N_ROW) * dy + 1.7 * inch
    xs = arange(N_COL) * dx + 1.3 * inch
    led_xs = xs + dx / 2.
    led_ys = ys + dy / 2.
    baffle_xs = arange(N_COL + 1) * dx + 1.3 * inch
    baffle_ys = arange(N_ROW + 1) * dy + 1.7 * inch

    scad = open("ClockTHREEjr.scad", "w")
    scad_ex = open("ClockTHREEjr_exploded.scad", "w")
    print >> scad_ex, 'use <ClockTHREEjr.scad>'
    print >> scad, 'mm = 1;' 
    print >> scad, 'dy = %s;' % (dy / mm)
    print >> scad, 'dx = %s;' % (dx / mm)
    print >> scad, 'module baffle_v(){'
    print >> scad, 'color([ 0.1, 1, 0.1, 0.8 ])'
    print >> scad, "translate(v=[%s,%s, %s])" % (0 / mm,
                                                 0 / mm,
                                                 baffle_height / mm)
    print >> scad, "rotate(a=90, v=[0, -1, 0])"
    print >> scad, "rotate(a=90, v=[0, 0, 1])"
    baffle_v.toOpenScad(baffle_thickness, scad)
    print >> scad, '}'

    baffle_h = create_baffle(baffle_height=baffle_height, 
                      baffle_thickness=baffle_thickness,
                      n_notch=N_COL,
                      delta=dx,
                      overhang=.3*inch,
                      margin=MARGIN)

    print >> scad, 'module baffle_h(){'
    print >> scad, 'color([ 1, 0.1, 0.1, 0.8 ])'
    print >> scad, "translate(v=[%s, %s, 0])" % (0/mm, 0/mm)
    print >> scad, "rotate(a=90, v=[1, 0, 0])"
    baffle_h.toOpenScad(baffle_thickness, scad)
    print >> scad, '}'
    print >> scad, '''module baffle_grid(){
      for(i=[0:16]){
        translate(v=[i * dx, 0, 0])baffle_v();
      }
      for(i=[0:8]){
        translate(v=[0, i * dy, 0])baffle_h();
      }
    }
    '''
    locator.toOpenScad(baffle_thickness, scad, 'locator', color=[.1, .1, 1, .8])

    print >> scad, '''module nut(x, y, z){
      color([0.1, 0.1, 1, 0.8])translate([x, y, z]) difference(){cylinder(h=%s, r=%s);translate([0, 0, -1])cylinder(h=2*%s, r=%s);}
    }''' % (nut_thickness / mm, nut_or / mm, nut_thickness / mm, nut_ir / mm)


    print >> scad, '''module standoff(x, y){
      color([0.1, 0.1, 1, 0.8])translate([x, y]) difference(){cylinder(h=%s, r=%s);translate([0, 0, -1])cylinder(h=2*%s, r=%s);}
    }''' % (standoff_thickness / mm, standoff_or / mm, standoff_thickness / mm, standoff_ir / mm)


    if False:
        # leds
        can.setFillColor(blue)
        for x in led_xs:
            for y in led_ys:
                can.circle(x, y, 2.5 * mm, fill=1)
        can.setFillColor(black)

    can.setTitle("ClockTHREE Jr. Faceplate: %s" % fontname)
    can.setFont(fontname, 15)
    can.drawCentredString(4.5 * inch, -.75* inch, 'ClockTHREEjr Faceplate, %s, 0.25" Painted/Etched Acrylic' % fontname)

    can.setFont(fontname, fontsize)

    # label font
    can.drawString(1.25*inch, 9.25*inch , fontname)

    if reverse:
        can.translate(9 * inch, 0 * inch)
        can.scale(-1, 1)

    # can.setFont("Helvetica-Bold", 20)
    # can.drawCentredString(4.5*inch, (8.15 - .075)*inch , "Make:")
    # can.setFont(fontname, fontsize)

    for im in images:
        im.drawOn(can)
    ldr_x = 48.8 * mm + 1 * inch
    ldr_y = 9*inch - 6.38*mm
    ldr_r = 2.5*mm
    can.circle(ldr_x, ldr_y, ldr_r, fill=True) # ldr
    if False:
        can.circle(xs[-1] + dx/2, ys[-1] + dy/2 - .05*inch, 1*mm, fill=True) # 1 minute
        can.circle(xs[-1] + dx/2, ys[-2] + dy/2 + dy/8 - .05*inch, 1*mm, fill=True) # 2 minutes
        can.circle(xs[-1] + dx/2, ys[-2] + dy/2 - dy/8 - .05*inch, 1*mm, fill=True) # 2 minutes
        can.circle(xs[-1] + dx/2, ys[-3] + dy/2 - .05*inch, 1*mm, fill=True) # 1 minute
    
    # crop marks # update!
    # can.setLineWidth(LASER_THICKNESS)
    can.setLineWidth(.5)
    margin = 10*mm
    letter_bbox = (xs[0], ys[0], xs[-1] - xs[0] + dx, ys[-1] - ys[0] + dy)
    print >> scad, 'translate([%s, %s, %s])baffle_grid();' % (letter_bbox[0] / mm,
                                                              letter_bbox[1] / mm,
                                                              (nut_thickness + pcb_thickness) / mm
                                                              )
    print >> scad_ex, 'translate([%s, %s, %s])baffle_grid();' % (letter_bbox[0] / mm,
                                                                 letter_bbox[1] / mm,
                                                                 (nut_thickness + pcb_thickness) / mm
                                                                 )

    if False:
        can.rect(*letter_bbox)
    bbox = (0 * inch,
            0 * inch,
            9 * inch,
            9 * inch)
    faceplate = MyPath()
    faceplate.rect(bbox)

    backplate = MyPath()
    backplate.rect(bbox)
    keyhole = Keyhole()
    backplate.route(keyhole)
    keyhole.translate((9 - .75 - .75) * inch, 0 * inch)
    backplate.route(keyhole)
        
    pcb_bbox = (1 * inch,
                0 * inch,
                7 * inch,
                9 * inch)
    pcb = MyPath()
    pcb.rect(pcb_bbox)

################################################################################
    encName = 'winansi'
    decoder = codecs.lookup(encName)[1]
    def decodeFunc(txt):
        if txt is None:
            return ' '
        else:
            return decoder(txt, errors='replace')[0]
    data = [[decodeFunc(case(char)) for char in line] for line in data]
################################################################################

    for y, l in zip(ys + dy * .27, data[::-1]):
        for x, c in zip(xs + dx / 2., l):
            can.drawCentredString(x, y, c)

    if False:
        for x in baffle_xs:
            can.rect(x - baffle_thickness / 2, letter_bbox[1] - baffle_thickness/2 - .2*inch, 
                     baffle_thickness, (N_ROW) * dy + baffle_thickness + .4 * inch), 

        for y in baffle_ys:
            can.rect(pcb_bbox[0], y - baffle_thickness/2, 
                     pcb_bbox[2], baffle_thickness)
        
    mount_r = .12 * inch / 2
    pcb_mounts = array([[.15, .15],
                        [7 - .15, .15],
                        [7 - .15, .15 + 1.9],
                        [7 - .15, .15 + 1.9 + 4.9],
                        [7 - .15, .15 + 1.9 + 4.9 + 1.9],
                        [.15, .15 + 1.9 + 4.9 + 1.9],
                        [.15, .15 + 1.9 + 4.9],
                        [.15, .15 + 1.9],
                        ]) * inch + (1 * inch, 0)
    locator_mounts = array([
            [7 - .15, .15 + 1.9],
            [7 - .15, .15 + 1.9 + 4.9],
            [.15, .15 + 1.9],
            [.15, .15 + 1.9 + 4.9],
            ]) * inch + (1 * inch, 0) - (.28*inch/2, (dy - baffle_thickness) / 2)

    for x, y in pcb_mounts:
        pcb.drill(x, y, mount_r)
        backplate.drill(x, y, mount_r)
        print >> scad, 'nut(%s, %s, 0);' % (x / mm, y / mm)

        print >> scad_ex, 'nut(%s, %s, 0);' % (x / mm, y / mm)
        # can.circle(x, y, mount_r, fill=False)

    if False:
        pcb.drawOn(can)
    pcb.toOpenScad(pcb_thickness, scad, 'pcb')
    print >> scad, 'color([0, 1, 0, 0.3])translate([0, 0, %s])pcb();' % ((nut_thickness + pcb_thickness / 2) / mm)
    print >> scad_ex, 'color([0, 1, 0, 0.3])translate([0, 0, %s])pcb();' % ((nut_thickness + pcb_thickness / 2) / mm)
    
    for x, y in locator_mounts:
        if False:
            locator.translate(x, y)
            locator.drawOn(can)
            locator.translate(-x, -y)
        print >> scad, 'translate([%s, %s, %s])locator();' % (x / mm, y / mm, (nut_thickness + 1.5 * pcb_thickness) / mm)

        print >> scad_ex, 'translate([%s, %s, %s])locator();' % (x / mm, y / mm, (nut_thickness + 1.5 * pcb_thickness) / mm)

    face_mounts = array([[.15, .15],
                         [.15, 9 - .15],
                         [9 - .15, 9 - .15],
                         [9 - .15, .15]]) * inch
    for x, y in face_mounts:
        faceplate.drill(x, y, mount_r)
        backplate.drill(x, y, mount_r)
        # can.circle(x, y, mount_r, fill=False)
        print >> scad, 'standoff(%s, %s);' % (x/mm, y/mm);
        print >> scad_ex, 'standoff(%s, %s);' % (x/mm, y/mm);
    faceplate.toOpenScad(faceplate_thickness, scad, 'faceplate')
    print >> scad, 'color([0.1, 0.1, 0.1, 0.3])translate([0, 0, %s]) faceplate();' % ((standoff_thickness + faceplate_thickness / 2) / mm)
    print >> scad_ex, 'color([0.1, 0.1, 0.1, 0.3])translate([0, 0, %s])faceplate();' % (2 * inch/mm + (standoff_thickness + faceplate_thickness / 2) / mm)
    # faceplate.toOpenScad(faceplate_thickness, scad_ex)

    backplate.toOpenScad(faceplate_thickness, scad, 'backplate')
    print >> scad, 'color([0.1, 0.1, 0.1, 0.9])translate([0, 0, %s])backplate();' % ((-faceplate_thickness / 2) / mm)
    print >> scad_ex, 'color([0.1, 0.1, 0.1, 0.9])translate([0, 0, %s])backplate();' % (-2 * inch / mm + (-faceplate_thickness / 2) / mm)

    if seven_seg:
        x = 4.15*inch + 1 * inch - .5*inch
        w = 1.6*inch
        h = .5*inch
        y = 9*inch - .8 *inch  - .6*inch
        can.rect(x, y, w, h, fill=True)

    faceplate.drawOn(can)
    can.showPage()

    can.translate(1 * inch, 1 * inch)
    can.setStrokeColor(red)
    backplate.drawOn(can)
    # c3jr = Image("Images/ClockTHREEjr_logo2.png", 3*inch, 3.5*inch, w=3*inch, h=None)
    # c3jr.drawOn(can)

    # oshw = Image("Images/oshw-logo.png", .25*inch, .25*inch, w=1.5*inch)
    # oshw.drawOn(can)

    can.setFont("Futura", 30)
    # can.drawCentredString(4.5 * inch, 1. * inch, "WyoLum.com")
    # can.drawCentredString(4.5 * inch, .5 * inch, "TimeWithArduino")
    # can.setFont("Futura", 15)
    # can.drawString(6.1 * inch, .5 * inch, ".blogspot.com")

    can.setFont("Futura", 15)
    can.drawCentredString(4.5 * inch, -.75 * inch, 'ClockTHREEjr Backplate, 0.25" Engraved ABS')

    can.showPage()
    
    baffle_v.translate(1*inch, 9*inch)
    baffle_v.drawOn(can)
    baffle_v.translate(-1*inch, -9*inch)
    textobject = can.beginText()
    textobject.setTextOrigin(1 * inch, 8.75*inch)
    textobject.textOut("17 / clock")
    can.drawText(textobject)

    baffle_h.translate(1*inch, 7*inch)
    baffle_h.drawOn(can)
    baffle_h.translate(-1*inch, -7*inch)

    textobject = can.beginText()
    textobject.setTextOrigin(1 * inch, 6.75*inch)
    textobject.textOut("9 / clock")
    can.drawText(textobject)
    locator.translate(1 * inch, 5 * inch)
    locator.drawOn(can)
    locator.translate(-1 * inch, -5 * inch)
    textobject = can.beginText()
    textobject.setTextOrigin(1 * inch, 4.75*inch)
    textobject.textOut("4 / clock")
    can.drawText(textobject)

    can.setFont("Futura", 15)
    can.drawCentredString(4.5 * inch, 3 * inch, 'ClockTHREEjr Baffles 0.06" Laser Cut Acrylic')

    can.showPage()

    can.save()
    print 'wrote', filename
    scad.close()
    scad_ex.close()

def add_font(fontname):
    pdfmetrics.registerFont(TTFont(fontname, 'fonts/%s.ttf' % fontname))
add_font('Futura')
w = 6.57*mm
x = 73*mm + 1 * inch - w/2
y = .15 * inch
bug = Image('Images/NounProject/noun_project_198.png', x, y, w=w)

# draw('faceplate_jr_Futura.pdf', letters, fontname='Futura', images=[bug],reverse=False)
# draw('faceplate_jr_Futura_R.pdf', letters, fontname='Futura', images=[bug],reverse=True)
not_used = '''
'''
fontnames = '''Futura
PermanentMarker
Cantarell-Bold
Allerta-Medium
Futura
RuslanDisplay
Grenadie
GrenadierNF
'''
fontnames = '''
Futura
'''.split()
dir = 'Faceplates_jr/German_jr/'
if True: # ClockTHREEjr
    for fontname in fontnames:
        add_font(fontname)
        draw('%s/faceplate_jr_%s_upper_R.pdf' % (dir, fontname), letters, 
             fontname=fontname, images=[bug],reverse=True, case=string.upper)
        draw('%s/faceplate_jr_%s_lower_R.pdf' % (dir, fontname), letters, 
             fontname=fontname, images=[bug],reverse=True, case=string.lower)
        draw('%s/faceplate_jr_%s_upper.pdf' % (dir, fontname), letters, 
             fontname=fontname, images=[bug],reverse=False, case=string.upper)
        draw('%s/faceplate_jr_%s_lower.pdf' % (dir, fontname), letters, 
             fontname=fontname, images=[bug],reverse=False, case=string.lower)
    
else:
    for fontname in fontnames:
        add_font(fontname)
        draw('Faceplates_tempjr/faceplate_jr_%s_upper_R.pdf' % fontname, temps,
             fontname=fontname, images=[bug],reverse=True, case=string.upper,
             seven_seg=True)
        draw('Faceplates_tempjr/faceplate_jr_%s_lower_R.pdf' % fontname, temps, 
             fontname=fontname, images=[bug],reverse=True, case=string.lower,
             seven_seg=True)
        draw('Faceplates_tempjr/faceplate_jr_%s_upper.pdf' % fontname, temps, 
             fontname=fontname, images=[bug],reverse=False, case=string.upper,
             seven_seg=True)
        draw('Faceplates_tempjr/faceplate_jr_%s_lower.pdf' % fontname, temps, 
             fontname=fontname, images=[bug],reverse=False, case=string.lower,
             seven_seg=True)
    
