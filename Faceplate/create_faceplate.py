'''
download fonts from: 
    http://openfontlibrary.org
    http://code.google.com/webfonts
    http://www.font-zone.com/

download images from:
    thenounproject.com
    
'''
test = 1
from numpy import *
import PIL.Image
from reportlab.pdfgen import canvas
from reportlab.graphics import renderPDF
from reportlab.graphics.shapes import Drawing, Group, String, Circle, Rect
from reportlab.lib.units import inch, mm
from reportlab.lib.colors import pink, black, red, blue, green, white
from reportlab.platypus import Paragraph, SimpleDocTemplate, Table, TableStyle
from numpy import arange

DEG = pi/180.
DTHETA = 180/5
THETA_EXTRA = 0
thetas = arange(-THETA_EXTRA, 180 + THETA_EXTRA, DTHETA)
class Line:
    def __init__(self, p1, p2):
        self.p1 = array(p1, copy=True)
        self.p2 = array(p2, copy=True)

    def __call__(self, s):
        return self.p1 + s * (self.p2 - self.p1)

    def intersect(self, other):
        M = transpose([self.p1 - self.p2, other.p2 - other.p1])
        x = dot(linalg.inv(M), self.p1 - other.p1)
        return self(x[0])
    
    def parallel(self, through):
        return Line(through, self.p2 + through - self.p1)
    
    def __add__(self, v):
        return Line(self.p1 + v, self.p2 + v)
    
    def __sub__(self, v):
        return self + (-v)
    
    def drawOn(self, canvas):
        canvas.line(self.p1[0], self.p1[1], self.p2[0], self.p2[1])

class MyPath:
    def __init__(self, c):
        self.c = c
        self.p = c.beginPath()
        self.points = []
    def moveTo(self, x, y):
        self.p.moveTo(x, y)
        self.points.append([x, y])
    def lineTo(self, x, y):
        self.p.lineTo(x, y)
        self.points.append([x, y])
    def draw(self):
        self.c.drawPath(self.p)
    def toOpenScad(self, height):
        print '''\

linear_extrude(height=%s, center=true, convexity=10, twist=0)\
translate([2, 0, 0])\
polygon(points=%s, \
paths=[%s]);

''' % (height, self.points, range(len(self.points)))
    
l1 = Line([0, 1], [1, 2])
l2 = Line([1, -1], [0, 0])
assert linalg.norm(l1.intersect(l2) - l2.intersect(l1)) < 1e-8

# we know some glyphs are missing, suppress warnings
# fonts available from http://openfontlibrary.org
# create your own fonts with fontforge! http://fontforge.sourceforge.net
# origianl hourglass by Clker.com
# http://commons.wikimedia.org/wiki/File:GreenHourglass.svg

import reportlab.rl_config
import codecs
reportlab.rl_config.warnOnMissingFontGlyphs = 0
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
import glob
import os.path

adobe2codec = {
    'WinAnsiEncoding':'winansi',
    'MacRomanEncoding':'macroman',
    'MacExpert':'macexpert',
    'PDFDoc':'pdfdoc',
    
    }


dx = 9/15. * inch
dy = 9/15. * inch
N_COL = 16
N_ROW = 12
H = 9 * inch
W = 12 * inch
TOP = 1 * inch - 7.5 * mm
LEFT = 1.5 * inch - 7.5 * mm
XS = arange(LEFT, LEFT + dx * (N_COL + .01), dx)
YS = arange(TOP, TOP + dy * (N_ROW + .01), dy) # from top

assert len(XS) == N_COL + 1, '%s != %s ' % (len(XS), N_COL + 1)
assert len(YS) == N_ROW + 1, '%s != %s ' % (len(YS), N_ROW + 1)
YS = H - YS # from bottom

DX = (W - 2 * LEFT) / float(N_COL)
dx = DX

class Image:
    def __init__(self, filename, x, y, w, h):
        self.filename = filename
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    def drawOn(self, c):
        im = PIL.Image.open(self.filename)
        c.drawInlineImage(im, 
                          self.x, self.y, self.w, self.h)

def draw(filename, data, images, fontname='Times-Roman', fontsize=30,
         faceplate=True, baffle=True):
    c = canvas.Canvas(filename,
                      pagesize=(W, H)
                      )
    c.setFont(fontname, fontsize)
    
    # c.getAvailableFonts()
    # c.stringWidth('Hello World')
    # c.drawString(0 * inch, 5 * inch, 'HelloWorld')
    
    c.setLineWidth(1/16. * inch)
    hole_sepx = 2.920 * inch
    hole_sepy = 2.887 * inch
    startx = .172 * inch
    starty = .172 * inch
    r = .172 / 2 * inch
    mounts = [] # lower left
    for i in range(5):          
        if i != 1:
            mounts.append(array([startx + i * hole_sepx, starty]))             # bottom row
    SW = mounts[0]
    SE = mounts[-1]
            
    for i in range(1, 3):
        mounts.append(array([startx + 4 * hole_sepx, starty + i * hole_sepy]))
    for i in range(4, -1, -1):
        mounts.append(array([startx + i * hole_sepx, starty + hole_sepy * 3])) # top row
    NE = mounts[-5]
    NW = mounts[-1]
    for i in range(3, -1, -1):
        mounts.append(array([startx, starty + i * hole_sepy]))

    if baffle:
        c.setLineJoin(1)
        lw = 1/32. * inch
        c.setLineWidth(1./64*inch)
        # c.grid(XS, YS)
        # c.rect(XS[0], YS[-1], XS[-1] - XS[0], YS[0] - YS[-1])
        for x in XS[:-1]:
            for y in YS[1:]:
                c.rect(x + lw, y + lw, dx - 2 * lw, dy -2 * lw)

        # bug
        # c.rect(2.826 * inch, .05 * inch, .3*inch, .4*inch)
        # ClockTHREE
        # c.rect(W - .75*inch, H - (3.3875 + .5)*inch, .5*inch, .5*inch)
     
        w = r + 2 * mm

        grid_SW = array([min(XS), min(YS)])
        grid_SE = array([max(XS), min(YS)])
        grid_NE = array([max(XS), max(YS)])
        grid_NW = array([min(XS), max(YS)])

        # Middle bottom
        # p = c.beginPath()
        p = MyPath(c)
        first = ((W + w)/2., grid_NW[1] + w)
        first = mounts[1][0] + w, grid_SE[1] - w
        p.moveTo(*first)
        
        if False: # right lower middle SSE
            next = mounts[2][0] - w, grid_SW[1]- w
            p.lineTo(*next)
            next = mounts[2][0] - w, mounts[2][1]
            p.lineTo(*next)

            for theta in (thetas - 180) * DEG:
                next = mounts[2] + [w * cos(theta), w * sin(theta)]
                p.lineTo(*next)
        else:
            next = first
        next = next[0], grid_SE[1] - w
        p.lineTo(*next)

        # SE corner
        V = SE - grid_SE
        d = linalg.norm(V)
        V /= d
        Vperp = array([-V[1], V[0]])

        l1 = Line(grid_SE, grid_SW) - array([0, w])
        l2 = Line(grid_SE, SE) - Vperp * w
        next = l1.intersect(l2)
        p.lineTo(*next)
        next = l2.p2
        p.lineTo(*next)

        for theta in (-thetas + 180) * DEG:
        # for theta in arange(180 + THETA_EXTRA, 0 - THETA_EXTRA, -DTHETA) * DEG:
            next = SE + w * sin(theta) * V + w * cos(theta) * Vperp
            p.lineTo(*next)

        l1 = Line(grid_SE, grid_NE) + array([w, 0])
        l2 = Line(grid_SE, SE) + Vperp * w
        next = l1.intersect(l2)
        p.lineTo(*next)
        
        if False: # right side
            for m_i in [4, 5]:
                next = grid_SE[0] + w, mounts[m_i][1] - w
                p.lineTo(*next)
                next = mounts[m_i][0], mounts[m_i][1] - w
                p.lineTo(*next)
                for theta in (thetas -90) * DEG:
                # for theta in arange(-90 - THETA_EXTRA, 90 + THETA_EXTRA, DTHETA) * DEG:
                    next = mounts[m_i] + [w * cos(theta), w * sin(theta)]
                    p.lineTo(*next)
                next = grid_SE[0] + w, mounts[m_i][1] + w
                p.lineTo(*next)

        V = NE - grid_NE
        d = linalg.norm(V)
        V /= d
        Vperp = array([-V[1], V[0]])

        l1 = Line(grid_NE, grid_SE) + [w, 0]
        l2 = Line(grid_NE, NE) - Vperp * w
        next = l1.intersect(l2)
        p.lineTo(*next)
        next = l2.p2
        p.lineTo(*next)
        for theta in (-thetas + 180) * DEG:
        # for theta in arange(180 + THETA_EXTRA, 0 - THETA_EXTRA, -DTHETA) * DEG:
            next = NE + w * sin(theta) * V + w * cos(theta) * Vperp
            p.lineTo(*next)
        l1 = Line(grid_NW, grid_NE) + [0, w]
        l2 = Line(grid_NE, NE) + Vperp * w
        next = l1.intersect(l2)
        p.lineTo(*next)
        
        for i in [8]: # [7, 8, 9] gets each hole in top
            next = mounts[i][0] + w, l1.p1[1]
            p.lineTo(*next)
            next = mounts[i] + [w, 0]
            p.lineTo(*next)
            for theta in (thetas) * DEG:
            # for theta in arange(0 - THETA_EXTRA, 180 + THETA_EXTRA, DTHETA) * DEG:
                next = mounts[i] + [w * cos(theta),  w * sin(theta)]
                p.lineTo(*next)

            next = mounts[i][0] - w, l1.p1[1]
            p.lineTo(*next)
        
        V = NW - grid_NW
        d = linalg.norm(V)
        V /= d
        Vperp = array([-V[1], V[0]])

        l1 = Line(grid_NW, grid_NE) + [0, w]
        l2 = Line(NW, grid_NW) - w * Vperp
        next = l1.intersect(l2)
        p.lineTo(*next)
        next = NW - w * Vperp
        p.lineTo(*next)
        for theta in (-thetas + 180) * DEG:
        # for theta in arange(180 + THETA_EXTRA, 0 - THETA_EXTRA, -DTHETA) * DEG:
            next = NW + w * sin(theta) * V + w * cos(theta) * Vperp
            p.lineTo(*next)
            
        l1 = Line(grid_NW, grid_SW) - array([w, 0])
        l2 = l2 + 2 * w * Vperp
        next = l2.intersect(l1)
        p.lineTo(*next)

        if False: # left side
            for i in [12, 13]:
                next = [grid_NW[0] - w, mounts[i][1] + w]
                p.lineTo(*next)
                next = mounts[i] + [0, w]
                p.lineTo(*next)
                for theta in (thetas + 90) * DEG:
                # for theta in arange(90 - THETA_EXTRA, 270 + THETA_EXTRA, DTHETA) * DEG:
                    next = mounts[i] + [w * cos(theta),  w * sin(theta)]
                    p.lineTo(*next)
                next = grid_NW[0] - w, mounts[i][1] - w
                p.lineTo(*next)

        V = SW - grid_SW
        d = linalg.norm(V)
        V /= d
        Vperp = array([-V[1], V[0]])

        l1 = Line(grid_NW, grid_SW) - array([w, 0])
        l2 = Line(grid_SW, SW) - w * Vperp
        next = l2.intersect(l1)
        p.lineTo(*next)
        next = l2.p2
        p.lineTo(*next)
        for theta in (-thetas + 180) * DEG:
        # for theta in arange(180 + THETA_EXTRA, 0 - THETA_EXTRA, -DTHETA) * DEG:
            next = SW + w * sin(theta) * V + w * cos(theta) * Vperp
            p.lineTo(*next)

        l1 = Line(grid_SW, grid_SE) - array([0, w])
        l2 = l2 + 2 * w * Vperp
        next = l1.intersect(l2)
        p.lineTo(*next)
        next = mounts[1][0] - w, grid_SW[1] - w
        p.lineTo(*next)
        
        next = mounts[1] - [w, 0]
        p.lineTo(*next)
        for theta in (thetas + 180) * DEG:
        # for theta in arange(180 - THETA_EXTRA, 360 + THETA_EXTRA, DTHETA) * DEG:
            next = mounts[1] + [w * cos(theta),  w * sin(theta)]
            p.lineTo(*next)
        p.lineTo(*first)
        # c.drawPath(p)
        p.draw()
        p.toOpenScad(10)
        
    if baffle:
        c.setLineWidth(1/64. * inch)
        for x, y in [mounts[0], mounts[1], mounts[3], mounts[6], mounts[8], mounts[10]]:
            c.circle(x, y, r, fill=False)
    else:
        c.setLineWidth(1/64. * inch)
        for x, y in mounts:
            c.circle(x, y, r, fill=False)

    t=Table(data, N_COL*[dx], N_ROW*[dy])
    t.setStyle(TableStyle(
            [('FONTNAME', (0, 0), (N_COL - 1, N_ROW - 1), fontname),
             ('FONTSIZE', (0, 0), (N_COL - 1, N_ROW - 1), fontsize),
             ('ALIGN', (0, 0), (N_COL - 1, N_ROW - 1), 'CENTRE'),
             ]))

    t.wrap(W, H)
    if faceplate:
        t.drawOn(c, XS[0], YS[-2] - dy/2.5)
        for im in images:
            im.drawOn(c)
        encName = 'winansi'
        decoder = codecs.lookup(encName)[1]
        def decodeFunc(txt):
            if txt is None:
                return None
            else:
                return decoder(txt, errors='replace')[0]        
        c.drawCentredString(XS[-4] - dx/2, YS[-1] + dy/4,
                            decodeFunc(chr(186) + 'C'))
        c.drawCentredString(XS[-3] - dx/2, YS[-1] + dy/4,
                            decodeFunc(chr(186) + 'F'))
        c.setLineWidth(1 * mm)
        c.setLineJoin(1)
        c.line(XS[-2] + dx/10., YS[-1] + dx/10.,
               XS[-1] - dx/10., YS[-2] - dy/10.)

    c.showPage()
    c.save()
    print "Wrote %s." % filename
'''ITSXATENRQUARTER"
  "TWENTYFIVEDPASTO"
  "TWELVETWONESEVEN"
  "FOURFIVESIXTHREE"
  "EIGHTENINELEVEN-"
  "BEERCHAIOCLOCKM-"
  "THIRTYUINITHEAT-"
  "MIDNIGHTEVENING-"
  "IXICLOCKTHREE78-"
  "MORNINGAFTERNOON"
  "THANKVIWEMNEED17"
  "YMDYMSALARMT  AN"'''
data = [
        ('I',"T'",'S','X','A','T','E','N','R','Q','U','A','R','T','E','R'),
        ('T','W','E','N','T','Y','F','I','V','E','D','P','A','S','T','O'),
        ('T','W','E','L','V','E','T','W','O','N','E','S','E','V','E','N'),
        ('F','O','U','R','F','I','V','E','S','I','X','T','H','R','E','E'),
        ('E','I','G','H','T','E','N','I','N','E','L','E','V','E','N',' '),
        ('B','E','E','R','C','H','A','I',"O'",'C','L','O','C','K','M',' '),
        ('T','H','I','R','T','Y','U','I','N','I','T','H','E','A','T',' '),
        ('M','I','D','N','I','G','H','T','E','V','E','N','I','N','G',' '),
        ('T','J','S','C','L','O','C','K','T','H','R','E','E','A','M',' '),
        ('M','O','R','N','I','N','G','A','F','T','E','R','N','O','O','N'),
        ('E','G','S','W','Y','O','L','U','M','A','C','S','E','C','S','H'),
        (' ','Y','M','D','H','M','S','A','L','A','R','M',' ',' ',' ',' ')]

bangla = [chr(c % 128) for c in range(16*12)]
bangla = reshape(bangla, (12, 16))
bangla = [tuple(l) for l in bangla]

images = [Image('Images/NounProject/noun_project_198.png',                       # BUG
                2.826 * inch, .05 * inch, .3*inch, .4*inch),                
          Image('Images/NounProject/noun_project_317.png',                       # DEG  
                XS[-3] + dx * .17, YS[-1] + dy * .07, .4*inch, .5*inch),
          Image('Images/NounProject/noun_project_317.png',                       # DEG
                XS[-2] + dx * .17, YS[-1] + dy * .07, .4*inch, .5*inch),
          Image('Images/NounProject/noun_project_140.png',                       # USB
                XS[0] + dx * .37, YS[-1] + dy * .25, .17*inch, .34*inch),
          Image('Images/ClockTHREE_soft.gif',                                    # ClockTHREE
                W - .75*inch, H - (3.3875 + .5)*inch, .5*inch, .5*inch),

]

for i in range(5):
    images.append(Image('Images/hourglass%d.png' % i,
          XS[-2] + dx * .35, YS[5 + i] + dy * .25,
          dx * .3, dy * .56 ))

def test():    
    draw("baffle.pdf", data, images, faceplate=False, baffle=True)
    draw("both.pdf", data, images, fontname='Philosopher', faceplate=True, baffle=True)
    # draw("bangla.pdf", bangla, images, fontname='ShadheenLipi', faceplate=True, baffle=False)

def main(fontnames):
    for fontname in fontnames:
        if fontname not in ignore_fonts:
            try:
                add_font(fontname)
                draw("faceplate_%s.pdf" % fontname, data, images, fontname=fontname, faceplate=True, baffle=False)
            except:
                print 'problem.  skipping %s' % fontname
    

def add_font(fontname):
    pdfmetrics.registerFont(TTFont(fontname, 'fonts/%s.ttf' % fontname))

ignore_fonts = ['ZapfDingbats', 'Symbol']
def add_all_fonts():
    global fontnames

    fontnames = pdfmetrics.getRegisteredFontNames()
    fontpaths = glob.glob('fonts/*.ttf')
    for fp in fontpaths:
        d, fn = os.path.split(fp)
        fontnames.append(fn[:-4])

        pdfmetrics.registerFont(TTFont(fn, fp))
        print 'added', fn
# pdfmetrics.registerFont(TTFont('ShadheenLipi', 'fonts/ShadheenLipi.ttf'))

if __name__ == '__main__':
    import sys
    if len(sys.argv) == 1: # print all
        add_all_fonts()
        main(fontnames)
        test()
        # main(['Vollkorn-Regular'])
    else:
        # main(sys.argv[1:])
        test()
    
