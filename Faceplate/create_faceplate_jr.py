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
import create_baffle_grid
from copy import deepcopy

DEFAULT_FONT_SIZE = 30

letters = '''itrisctenhalf-
quartertwenty-
fivecminutesh-
pasttoeonetwo-
threefourfive-
sixseveneight-
nineteneleven-
twelveloclock-'''.splitlines()

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
                        
    
