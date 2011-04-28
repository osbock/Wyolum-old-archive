test = 1
import string
from numpy import *
import PIL.Image
from reportlab.pdfgen import canvas
from reportlab.graphics import renderPDF
from reportlab.graphics.shapes import Drawing, Group, String, Circle, Rect
from reportlab.lib.units import inch, mm, cm
from reportlab.lib.colors import pink, black, red, blue, green, white
from reportlab.platypus import Paragraph, SimpleDocTemplate, Table, TableStyle
from numpy import arange
import create_baffle_grid
from copy import deepcopy

LASER_THICKNESS = 1
DEG = pi/180.

class Line:
    def __init__(self, p1, p2=None, angle=None):
        self.p1 = array(p1, copy=True)
        if angle is not None:
            p2 = p1 + array([cos(angle), sin(angle)])
        else:
            assert p2 is not None
        self.p2 = array(p2, copy=True)
        if angle is not None:
            assert abs(self.getAngle() - angle) < 1e-8
            
    def getAngle(self):
        d = self.p2 - self.p1
        return arctan2(d[1], d[0])
    
    def __call__(self, s):
        return self.p1 + s * (self.p2 - self.p1)

    def intersect(self, other):
        M = transpose([self.p1 - self.p2, other.p2 - other.p1])
        x = dot(linalg.inv(M), self.p1 - other.p1)
        return self(x[0])
    
    def parallel(self, through):
        return Line(through, self.p2 + through - self.p1)

    def perp(self, through):
        d = self.p2 - self.p1
        d /= linalg.norm(d)
        line = Line(through, d)
        return line
    
    def __add__(self, v):
        return Line(self.p1 + v, self.p2 + v)
    
    def __sub__(self, v):
        return self + (-v)
    
    def drawOn(self, canvas):
        canvas.line(self.p1[0], self.p1[1], self.p2[0], self.p2[1])

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
        self.last = array([x, y])
        
    def lineTo(self, x, y):
        self.points.append([x, y])
        self.paths[-1].append(len(self.points) - 1)
        self.last = array([x, y])

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

def draw():
    path = MyPath()
    l1 = Line((4.5 * inch, 3 * inch), (5 * inch, 0 * inch))
    l2 = Line((0, .5 * inch), (10*inch, .5*inch))
    p = l1.perp(l1.intersect(l2))
    d = p.p1 - p.p2
    d /= linalg.norm(d)
    intersect = l1.intersect(l2)
    
    path.moveTo(4.5 * inch, 3 * inch)
    path.lineTo(*intersect)

    # 1/4" hook (for back)
    base = Line(intersect, intersect + d)
    path.lineTo(*intersect + d * .28 * inch)
    e = l1.p1 - l1.p2
    e /= linalg.norm(e)
    path.lineTo(*(path.last + e * .25 * inch))
    
    # front layer holder
    W =  1.3 * inch
    next = intersect + d * 1 * inch
    l1 = Line(path.last, next)
    path.lineTo(*l1.intersect(base))
    path.lineTo(*(path.last + d * .3 * inch))

    l1 = Line(path.last, path.last + e)
    l2 = Line((0, 0), (1, 0))
    path.lineTo(*(l1.intersect(l2)))

    
    path.lineTo(6 * inch, 0 * inch)
    path.lineTo(2 * inch, 0 * inch)
    
    path.lineTo(4.5 * inch, 3 * inch)
    
    filename = "stand.pdf"
    path.drill(2.55*inch, .25*inch, .125*inch)
    path.drill(4.325*inch, 2.4*inch, .125*inch)

    c = path.toPDF(filename)
    c.showPage()
    c.save()
    print "wrote", filename
draw()
