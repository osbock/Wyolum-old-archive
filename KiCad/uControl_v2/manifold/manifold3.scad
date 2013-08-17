include <manifold_parts.scad>

scale = .1;
inch = 1000 * scale;
mm = 39.37 * scale;
wall = .05 * inch;
radius = .5*inch;
or = wall + radius;
gap = .25*inch;
gap = 0.02 * inch;

w = 2.25 * mm;
r = 8.5 * mm / 2 - w;

tube(12.4 * mm, r, w);
translate([0, (r + w), -(r + w)])
rotate(90, [1, 0, 0])
union(){
  rotate(90, [0, 0, 1])
    elbow(r, w);
  translate([0, 0, -6*mm])
    union(){
    tube(6*mm, r, w);
    translate([0, 0, -(r + w)])
      rotate(90, [0, 1, 0])
      translate([0, 0, 3 * (r + w) + 10.25 * mm])
      union(){
      tube(4 * mm, r, w);
      translate([0, 0,-2 * (r + w)])
	union(){
	rotate(90, [0, 0, -1])
	  translate([(r + w), 0, 0])
	  rotate(90, [0, -1, 0])
	  translate([(r + w), 0, 0])
	  tee(r, r, w);
	translate([0, 0, -10.25*mm])
	  union(){
	  tube(10.25 * mm, r, w);
	  translate([r + w, 0, -(r + w)])
	    union(){
	    rotate(90, [0, -1, 0])
	      union(){
	      translate([(r + w), 0, (r + w)])
		rotate(90, [0, -1, 0])
		tee(r, r, w);
	      translate([0, 0, -18.5 * mm])
		tube(18.5 * mm, r, w);
	    }
	  }
	}
      }
    }
  }
}
