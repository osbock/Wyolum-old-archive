 # -*- coding: latin-1 -*-
import sys
sys.path.append('/home/justin/Ubuntu One/WyoLum/CNC')
from cnc import MyPath
import os.path
from random import choice
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

DEFAULT_FONT_SIZE = 60
LASER_THICKNESS = .006 * inch
DTHETA = 1
DEG = pi/180.


test = '''\
1ABCEDFGHIJ1
2KLIMOPQRST2
3UVWXYZABCD3
4EFGHIJKLMN4
5OPQRSTUVWX5
6YZABCDEFGH6
7IJKLMNOPQR7
8STUVWXYZAB8
9ABCDEFGHIJ9
0KLMNOPQRST0
1UVWXYZABCD1
2EFGHIJKLMN2'''.splitlines()

english = '''\
it is a ten 
twenty five  
quarter half
pasto twelve
tenineightwo
three seven 
four one siz
fiveleven at
in the night
 morning    
  afternoon 
ymshsevening'''.splitlines()
  


letters = english

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

MARGIN = 2 * LASER_THICKNESS


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


dx = .453 * inch
dy = .453 * inch
DY = (2 * dx)
DX = (2 * dy) 

N_ROW = 12
N_COL = 12
n_row = 25
n_col = 25

baffle_v = create_baffle(baffle_height=baffle_height, 
                  baffle_thickness=baffle_thickness,
                  n_notch=N_ROW,
                  delta=DY,
                  overhang=.2*inch,
                  overhang_height=baffle_height,
                  overhang_taper=True,
                  margin=MARGIN)

locator = MyPath()
locator.moveTo(MARGIN, MARGIN)
locator.lineTo(.28*inch - MARGIN, MARGIN)
locator.lineTo(.28*inch - MARGIN, DY - baffle_thickness - MARGIN)
locator.lineTo(MARGIN, DY - baffle_thickness - MARGIN)
locator.lineTo(MARGIN, MARGIN)

locator.drill((.28 * inch)/2, (DY - baffle_thickness)/2, 1.8 * mm)

def draw(filename, data, fontname='Times-Roman', images=[],
         fontsize= DEFAULT_FONT_SIZE,
         reverse=False,
         case=string.upper,
         seven_seg=False,
         ):
    PCB_W = (11 + 5./16) * inch
    PCB_H = (14 + 7./8) *inch
    W = PCB_W + 2 * inch
    H = PCB_H + 1 * inch
    PAGE_MARGIN = 1*inch
    can = canvas.Canvas(filename,
                        pagesize=(W + 2 * PAGE_MARGIN, H + 2 * PAGE_MARGIN))
    can.translate(1.5 * inch, 1 * inch) ## PCB Lower left is origen
    data = [[case(char) for char in line] for line in data]
    YS = arange(N_ROW) * DY + (3 + 7/16.) * inch + dy / 4
    XS = arange(N_COL) * DX
    ys = arange(n_row) * dy + (3 + 7/16.) * inch
    xs = arange(n_col) * dx +  dx/2

    for x in xs:
        for y in ys[:1]:
	    can.circle(x, y, 2.5 * mm, fill=1)
    for x in xs[-1:]:
        for y in ys:
	    can.circle(x, y, 2.5 * mm, fill=1)
            
			    
    led_xs = XS + DX / 2.
    led_ys = YS + DY / 2.
    baffle_xs = arange(N_COL + 1) * DX + 1.3 * inch
    baffle_ys = arange(N_ROW + 1) * DY + 1.7 * inch

    baffle_h = create_baffle(baffle_height=baffle_height, 
                             baffle_thickness=baffle_thickness,
                             n_notch=N_COL,
                             delta=DX,
                             overhang=.3*inch,
                             margin=MARGIN)

    can.setTitle("Peggy2 Faceplate: %s" % fontname)
    can.setFont(fontname, 15)
    can.drawCentredString(4.5 * inch, -.75* inch, 'Peggy2 Faceplate, %s, 0.25" Painted/Etched Acrylic' % fontname)

    can.setFont(fontname, 80)
    can.drawCentredString(PCB_W/2, 1.5 * inch, 'Peggy2.0')

    can.setFont(fontname, fontsize)

    # label font
    can.drawString(1.25*inch, H + .25 * inch , fontname)

    if reverse:
        can.translate(9 * inch, 0 * inch)
        can.scale(-1, 1)

    ldr_x = 48.8 * mm + 1 * inch
    ldr_y = 9*inch - 6.38*mm
    ldr_r = 2.5*mm
    # can.circle(ldr_x, ldr_y, ldr_r, fill=True) # ldr

    can.setLineWidth(1)
    margin = 10*mm
    letter_bbox = (XS[0], YS[0], XS[-1] - XS[0] + DX, YS[-1] - YS[0] + DY)
    bbox = (0, 0, W, H)
    faceplate = MyPath()
    faceplate.rect(bbox)
    

    backplate = MyPath()
    backplate.rect(bbox)
    keyhole = Keyhole()
    backplate.route(keyhole)
    keyhole.translate((9 - .75 - .75) * inch, 0 * inch)
    backplate.route(keyhole)
        
    pcb_bbox = (0, 0, PCB_W, PCB_H)
    pcb = MyPath()
    pcb.rect(pcb_bbox)
    # pcb.drawOn(can, 1)

    bbox = (-1 * inch, -.5 * inch, W, H)
    edge = MyPath()
    edge.rect(bbox)
    edge.drawOn(can, 1)

################################################################################
    encName = 'winansi'
    decoder = codecs.lookup(encName)[1]
    def decodeFunc(txt):
        if txt is None:
            return ' '
        else:
            return case(decoder(txt, errors='replace')[0])
    data = [[decodeFunc(case(char)) for char in line] for line in data]
################################################################################

    for y, l in zip(YS + DY * .27, data[::-1]):
        for x, c in zip(XS + DX / 2., l):
            can.drawCentredString(x, y, c)

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

    for x, y in pcb_mounts:
        pcb.drill(x, y, mount_r)
        backplate.drill(x, y, mount_r)
    face_mounts = array([[.15, .15],
                         [.15, 9 - .15],
                         [9 - .15, 9 - .15],
                         [9 - .15, .15]]) * inch
    for x, y in face_mounts:
        faceplate.drill(x, y, mount_r)
        backplate.drill(x, y, mount_r)
    faceplate.drawOn(can)
    can.showPage()
    can.save()
    print 'wrote', filename

def findfilecb(target_dest, directory, names):
    target, dest = target_dest
    for name in names:
        if name == target:
            out = '/'.join([directory, name])
            dest[0] = out
            break
    else:
        pass
    
def add_font(fontname):
    arg = ['%s.ttf' % fontname, [None]]
    x = os.path.walk("fonts", findfilecb, arg)
    # pdfmetrics.registerFont(TTFont(fontname, 'fonts/%s.ttf' % fontname))
    if arg[1][0] is not None:
        pdfmetrics.registerFont(TTFont(fontname, arg[1][0]))

add_font('Futura')
w = 6.57*mm
x = 73*mm + 1 * inch - w/2
y = .15 * inch

fontnames = '''Futura
PermanentMarker
Cantarell-Bold
Futura
RuslanDisplay
Grenadie
GrenadierNF
Futura
Allerta-Medium
Meddon
SupermercadoOne-Regular
TerminalDosis-Light
Cantarell-Bold
'''
fontnames = '''
Helvetica-Bold
'''.split()
letters = english
dir = 'Faceplates_peggy/English_peggy/'

for fontname in fontnames:
    if "Helvetica" not in fontname:
        add_font(fontname)
    draw('%s/faceplate_jr_%s_upper.pdf' % (dir, fontname), letters, 
         fontname=fontname, images=[],reverse=False, case=string.upper)
    draw('%s/faceplate_jr_%s_lower.pdf' % (dir, fontname), letters, 
         fontname=fontname, images=[],reverse=False, case=string.lower)
    break
    draw('%s/faceplate_jr_%s_upper_R.pdf' % (dir, fontname), letters, 
         fontname=fontname,reverse=True, case=string.upper)
    draw('%s/faceplate_jr_%s_lower_R.pdf' % (dir, fontname), letters, 
         fontname=fontname, images=[],reverse=True, case=string.lower)
    
