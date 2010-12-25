import PIL.Image
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch, mm
from reportlab.lib.colors import pink, black, red, blue, green, white
from reportlab.platypus import Paragraph, SimpleDocTemplate, Table, TableStyle
from numpy import arange

# we know some glyphs are missing, suppress warnings
# fonts available from http://openfontlibrary.org
# create your own fonts with fontforge! http://fontforge.sourceforge.net
# origianl hourglass by Clker.com
# http://commons.wikimedia.org/wiki/File:GreenHourglass.svg

import reportlab.rl_config
reportlab.rl_config.warnOnMissingFontGlyphs = 0
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
pdfmetrics.registerFont(TTFont('Asana-Math', 'fonts/Asana-Math.ttf'))
pdfmetrics.registerFont(TTFont('ShadheenLipi', 'fonts/ShadheenLipi.ttf'))

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
    if baffle:
        c.grid(XS, YS)
        c.rect(XS[0], YS[-1], XS[-1] - XS[0], YS[0] - YS[-1])
    hole_sepx = 2.920
    hole_sepy = 2.887
    startx = .172
    starty = .172
    r = .172 / 4
    mounts = [(startx, starty)]
    for i in range(5):
        if i != 1:
            mounts.append((startx + i * hole_sepx, starty))
        mounts.append((startx + i * hole_sepx, starty + hole_sepy * 3))
    for i in range(1, 3):
        mounts.append((startx + 4 * hole_sepx, starty + i * hole_sepy))
        mounts.append((startx, starty + i * hole_sepy))
        
    c.setLineWidth(1/64. * inch)
    for x, y in mounts:
        c.circle(x*inch, y*inch, r*inch, fill=True)

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

    c.showPage()
    c.save()
    print "Wrote %s." % filename
data = [
        ('I',"T'",'S','X','A','T','E','N','R','Q','U','A','R','T','E','R'),
        ('T','W','E','N','T','Y','F','I','V','E','D','P','A','S','T','O'),
        ('T','W','E','L','V','E','T','W','O','N','E','S','E','V','E','N'),
        ('F','O','U','R','F','I','V','E','S','I','X','T','H','R','E','E'),
        ('E','I','G','H','T','E','N','I','N','E','L','E','V','E','N',' '),
        ('B','E','E','R','C','H','A','I',"O'",'C','L','O','C','K','M',' '),
        ('T','H','I','R','T','Y','U','I','N','I','T','H','E','A','T',' '),
        ('M','I','D','N','I','G','H','T','E','V','E','N','I','N','G',' '),
        ('I','X','I','C','L','O','C','K','T','H','R','E','E','7','8',' '),
        ('M','O','R','N','I','N','G','A','F','T','E','R','N','O','O','N'),
        ('T','H','A','N','K','V','I','W','E','M','N','E','E','D','1','7'),
        ('Y','O','U','R','!','S','U','P','P','O','R','T','!','!','8','9')]

images = [Image('Images/noun_project_198.png',
          2.826 * inch, .05 * inch, .3*inch, .4*inch)]

for i in range(5):
    images.append(Image('Images/hourglass%d.png' % i,
          XS[-2] + dx * .35, YS[5 + i] + dy * .25,
          dx * .3, dy * .56))

for fontname in pdfmetrics.getRegisteredFontNames():
    draw("faceplate_%s.pdf" % fontname, data, images, fontname=fontname, faceplate=True, baffle=False)

draw("baffle.pdf", data, images, faceplate=False, baffle=True)
draw("both.pdf", data, images, faceplate=True, baffle=True)
