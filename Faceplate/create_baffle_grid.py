from create_faceplate import *

gh = 8 * mm
gw = .07 * inch
    
def create_verts():

    W = 12 * dy
    H = 15 * (gh + gw) - gw

    filename = 'baffle_grid_vert.pdf'

    c = canvas.Canvas(filename,
                      pagesize=(W, H)
                      )
    c.setTitle("Vertical Baffles")
    c.drawCentredString(W/2, H/2, "15 units per clock")
    c.drawCentredString(W/2, H/2 - .5*inch, '0.07" notches')


    xbase = 0
    for j in range(1, 2):
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
    c.drawCentredString(W/2, H/2, "11 units per clock")
    c.drawCentredString(W/2, H/2 - .5*inch, '%0.2f" notches' % (gw / inch))

    xbase = 0
    for j in range(1, 2):
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
    
