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

DX = (W - 2 * LEFT) / float(N_COL)
print DX, dx
dx = DX

def draw(filename, faceplate=True, baffle=True):
    c = canvas.Canvas(filename,
                      pagesize=(W, H)
                      )

    xs = arange(LEFT, LEFT + dx * (N_COL + .01), dx)
    print xs[0] / inch
    print (W - xs[-1]) / inch
    ys = arange(TOP, TOP + dy * (N_ROW + .01), dy) # from top
    assert len(xs) == N_COL + 1, '%s != %s ' % (len(xs), N_COL + 1)
    assert len(ys) == N_ROW + 1, '%s != %s ' % (len(ys), N_ROW + 1)
    ys = H - ys # from bottom

    c.setLineWidth(1/16. * inch)
    if baffle:
        c.grid(xs, ys)
        c.rect(xs[0], ys[-1], xs[-1] - xs[0], ys[0] - ys[-1])
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
    data = [
        ('I',"T'",'S','X','A','T','E','N','R','Q','U','A','R','T','E','R'),
        ('T','W','E','N','T','Y','F','I','V','E','D','P','A','S','T','O'),
        ('T','W','E','L','V','E','T','W','O','N','E','S','E','V','E','N'),
        ('F','O','U','R','F','I','V','E','S','I','X','T','H','R','E','E'),
        ('E','I','G','H','T','E','N','I','N','E','L','E','V','E','N',' '),
        ('B','E','E','R','C','H','A','I',"O'",'C','L','O','C','K','M',' '),
        ('T','H','I','R','T','Y','U','I','N','I','T','H','E','A','T',' '),
        ('M','I','D','N','I','G','H','T','E','V','E','N','I','N','G',' '),
        ('M','O','R','N','I','N','G','A','F','T','E','R','N','O','O','N'),
        ('I','X','I','C','L','O','C','K','T','H','R','E','E','7','8','9'),
        ('T','H','A','N','K','V','I','W','E','M','N','E','E','D','1','7'),
        ('Y','O','U','R','!','S','U','P','P','O','R','T','!','!','8','9')]

    t=Table(data, N_COL*[dx], N_ROW*[dy])
    t.setStyle(TableStyle(
            [('FONTNAME', (0, 0), (N_COL - 1, N_ROW - 1), 'Asana-Math'),
             ('FONTSIZE', (0, 0), (N_COL - 1, N_ROW - 1), 30),
             ('ALIGN', (0, 0), (N_COL - 1, N_ROW - 1), 'CENTRE'),
             ]))
    # elements = []
    # elements.append(t)
    # doc = SimpleDocTemplate("simple_table.pdf")
    # doc.build(elements)
    c.setFont("Times-Roman", 30)
    print t.wrap(W, H)
    if faceplate:
        t.drawOn(c, xs[0], ys[-2] - dy/2.5)
        bug_i = PIL.Image.open('Images/noun_project_198.png')
        # bug_i = PIL.Image.open('minute1.png')
        c.drawInlineImage(bug_i, 
                          2.826 * inch, .05 * inch, .3*inch, .4*inch)
        image1 = PIL.Image.open('Images/minute1.png')
        c.drawInlineImage(image1, 
                          xs[-2] + dx * .315,
                          ys[5] + dy * .2,
                          dx * .4, 
                          dy * .56
                          )
        image2 = PIL.Image.open('Images/minute2.png')
        c.drawInlineImage(image2, 
                          xs[-2] + dx * .315,
                          ys[6] + dy * .2,
                          dx * .4, 
                          dy * .56)
        image3 = PIL.Image.open('Images/minute3.png')
        c.drawInlineImage(image3, 
                          xs[-2] + dx * .315,
                          ys[7] + dy * .2,
                          dx * .4, 
                          dy * .56)
        image4 = PIL.Image.open('Images/minute4.png')
        c.drawInlineImage(image4, 
                          xs[-2] + dx * .315,
                          ys[8] + dy * .2,
                          dx * .4, 
                          dy * .56)

    c.showPage()
    c.save()

draw("faceplate.pdf", faceplate=True, baffle=False)
draw("baffle.pdf", faceplate=False, baffle=True)
draw("both.pdf", faceplate=True, baffle=True)
