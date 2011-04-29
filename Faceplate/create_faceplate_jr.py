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
LASER_THICKNESS = .01 * inch


letters = '''itrisctenhalf-
quartertwenty-
fivecminutesh-
pasttoeonetwo-
threefourfive-
sixseveneight-
nineteneleven-
twelveloclock-'''.splitlines()

class MyPath:
    UNIT = cm
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
        c.setLineWidth(1/64. * inch)
        self.translate(-self.getleft() + .25 * inch, -self.getbottom() + .25 * inch)
        self.drawOn(c)
        return c

    def drawOn(self, c, linewidth=LASER_THICKNESS):
        p = c.beginPath()
        c.setLineWidth(linewidth)
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
    def toOpenScad(self, thickness, outfile):
        if len(self.holes) > 0 or len(self.subtract) > 0:
            print >> outfile, 'difference(){'
        print >> outfile, '''\
linear_extrude(height=%s, center=true, convexity=10, twist=0)
polygon(points=[''' % (thickness / cm)
        for x, y in self.points:
            print >> outfile, '[%s, %s],' % (x / cm, y / cm)
        print >> outfile, '],'
        print >> outfile, 'paths=['
        for path in self.paths:
            print >> outfile, '%s,' % path
        print >> outfile, ']);'

        if len(self.holes) > 0 or len(self.subtract) > 0:
            for hole in self.holes:
                x, y, r = hole
                print >> outfile, 'translate(v=[%s, %s, %s])' % (x/cm, y/cm, -5*inch)
                print >> outfile, 'cylinder(h=%s, r=%s, $fn=25);' % (10*inch, r / cm)# ((STANDOFF_IR + .1 * mm) / cm)
            for poly in self.subtract:
                print >> outfile, '//subtract'
                ## print >> outfile, 'translate(v=[0, 0, -%s])' % (thickness / cm)
                poly.toOpenScad(thickness * 2, outfile)
            print >> outfile, '}'

MARGIN = 1/64.*inch

def create_baffle(baffle_height, baffle_thickness, n_notch, delta,
                  overhang=0,
                  margin=MARGIN):
    '''
    delta = DX/DY
    overhang = amount of extra plastic from center of last notch    
    margin = extra gap for slots
    '''

    p = MyPath()
    p.moveTo(0, 0)
    if overhang > 0:
        p.lineTo(-overhang, 0)
        p.lineTo(-overhang, baffle_height)
        p.lineTo(-baffle_thickness / 2. - margin, baffle_height)
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
                 baffle_height)
        p.lineTo(n_notch * delta + overhang, baffle_height)
        p.lineTo(n_notch * delta + overhang, 0)
    p.lineTo(n_notch * delta, 0)
    p.lineTo(0, 0)
    return p
c = canvas.Canvas('junk.pdf',
                  pagesize=(8.5*inch, 11*inch)
                  )
c.setLineWidth(1/64. * inch)

p = create_baffle(baffle_height=15*mm, baffle_thickness=.06*inch, n_notch=8,
                  delta=.7*inch,
                  overhang=0*cm,
                  margin=MARGIN)
p.translate(1*inch, 9*inch)
p.drawOn(c)
p = create_baffle(baffle_height=15*mm, baffle_thickness=.06*inch, n_notch=14,
                  delta=.4*inch,
                  overhang=1*cm,
                  margin=MARGIN)
p.translate(1*inch, 8*inch)
p.drawOn(c)
c.showPage()
c.save()

here
class Image:
    def __init__(self, filename, x, y, w=None, h=None):
        self.filename = filename
        self.x = x
        self.y = y
        self.w = w
        self.h = h

    def drawOn(self, c):
        im = PIL.Image.open(self.filename)
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

def draw(filename, data, fontname='Times-Roman', 
         fontsize= DEFAULT_FONT_SIZE,
         reverse=False,
         case=string.upper,
         ):
    can = canvas.Canvas(filename,
                        pagesize=(8.5 * inch, 11 *inch))
    N_ROW = 8
    N_COL = 14
    
    dx = .4 * inch
    dy = .7 * inch
    data = [[case(char) for char in line] for line in data]
    ys = arange(N_ROW) * dy
    ys += 9 * inch - max(ys) + dy / 2
    xs = arange(N_COL) * dx + 1 * inch + dx / 2

    if reverse:
        can.translate(11 * inch, 0 * inch)
        can.scale(-1, 1)
    can.setTitle("ClockTHREE Jr. Faceplate: %s" % fontname)
    can.setFont(fontname, fontsize)

    # label font
    textobject = can.beginText()
    textobject.setTextOrigin(1.25*inch, 10.5*inch)
    textobject.textOut(fontname)
    can.drawText(textobject)
    
    # crop marks # update!
    can.setLineWidth(1/64. * inch)
    margin = 10*mm
    letter_bbox = (xs[0], ys[0], xs[-1] - xs[0] + dx, ys[-1] - ys[0] + dy)
    # can.rect(*letter_bbox)
    bbox = (letter_bbox[0] - margin,
            letter_bbox[1] - margin,
            letter_bbox[2] + 2 * margin,
            letter_bbox[3] + 2 * margin)
    # can.rect(*bbox)
    add_crop(can, bbox)
    
    for y, l in zip(ys + dy * .25, data[::-1]):
        for x, c in zip(xs + dx / 2., l):
            can.drawCentredString(x, y, c)
    if False:
        for y in ys:
            can.line(0, y, 8.5 * inch, y)
        for x in xs:
            can.line(x, 0, x, 11 * inch)
    can.showPage()
    can.save()

def add_font(fontname):
    pdfmetrics.registerFont(TTFont(fontname, 'fonts/%s.ttf' % fontname))
add_font('Futura')
draw('test.pdf', letters, fontname='Futura')
                        
    
