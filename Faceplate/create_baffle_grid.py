from create_faceplate import *

gh = 8 * mm
gw = .1 * inch

def create_baffle(gh, gw, n_notch, delta):
    p = MyPath()
    p.moveTo(gw / 4., 0)
    p.lineTo(gw / 4, gh)
    for i in range(1, n_notch + 1):
        x = delta * i
        p.lineTo(x - gw / 2, gh)
        p.lineTo(x - gw / 2, gh / 2 - gw / 2)
        p.lineTo(x + gw / 2, gh / 2 - gw / 2)
        p.lineTo(x + gw / 2, gh)

    p.lineTo(delta * (n_notch + 1) - gw / 4., gh)
    p.lineTo(delta * (n_notch + 1) - gw / 4., 0)
    return p
    
def create_verts():

    W = 12 * dy
    H = 15 * (gh + gw) - gw

    filename = 'baffle_grid_vert.pdf'

    c = canvas.Canvas(filename,
                      pagesize=(W, H)
                      )
    c.setTitle("Vertical Baffles")


    xbase = 0
    for j in range(15):
        ybase = j * (gh + gw)
        p = create_baffle(gh, gw, 11, dy)
        p.translate(xbase, ybase)
        p.drawOn(c)
    # p.toOpenScad()
    c.showPage()
    c.save()
    print 'created', filename

def create_horiz():

    W = 16 * dx
    H = 11 * (gh + gw) - gw

    filename = 'baffle_grid_horiz.pdf'
    c = canvas.Canvas(filename,
                      pagesize=(W, H)
                      )
    c.setTitle("Horizontal Baffles")
    xbase = 0
    for j in range(11):
        ybase = j * (gh + gw)
        p = create_baffle(gh, gw, 15, dx)
        p.translate(xbase, ybase)
        p.drawOn(c)
    c.showPage()
    c.save()
    print 'created', filename

if __name__ == '__main__':
    create_verts()
    create_horiz()

    filename = 'baffle_cut_test.pdf'

    c = canvas.Canvas(filename,
                      pagesize=(W, H)
                      )
    c.setTitle("Baffle Cut Test")

    p = create_baffle(gh, gw, 15, dx)
    p.translate(0, 4 * gh)
    p.drawOn(c)
    
    p = create_baffle(gh, gw, 11, dy)
    p.rotate(180)
    p.translate(W, 5 * gh)
    p.drawOn(c)
    c.drawCentredString(W/2, H/2, "Check if nocth overlaps are squares.")
    c.showPage()
    c.save()
    print 'Created %s' % filename
    
