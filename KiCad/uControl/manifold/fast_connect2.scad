include <manifold_parts.scad>

$fn = 150;

scale = 1.;
inch = 25.4 * scale;
mm = 1. * scale;
wall = .05 * inch;
radius = .5*inch;
or = wall + radius;
gap = .25*inch;
gap = 0.02 * inch;
/*tee(radius * .5, radius, wall);*/

w=1.4*mm;
chuck_radius = 8*mm;
cuff_clearance = 8*mm;
barb_length = 10*mm;

module chuck(w=w, chuck_radius=chuck_radius, cuff_clearance=cuff_clearance, barb_length=barb_length){
  difference(){
    scale(1/scale){
      taper(5.1*mm/2 - w, 4.8*mm/2 - w, 15*mm, w); // male connect
      translate([0,0,-w]){
	tube(w, w, chuck_radius - w);
	translate([0, 0, -cuff_clearance]){
	  tube(cuff_clearance, chuck_radius - w, w);
	  // translate([5.1*mm/2, 0, -4*mm/2])
	  translate([0*mm/2, 0, -4*mm/2])
	    rotate(-90, [0, 1, 0]){
	    //elbow(5.1*mm/2 - w, w);
	    rotate(180, [1, 0, 0]){
	      translate([0, 0, chuck_radius*mm])
		barb(4*mm/2 - w, 6*mm/2-w, barb_length, 3*mm, 2*mm, w);
	      taper(4.*mm/2 - w, 4.*mm/2 - w, chuck_radius, w); // male connect
	    }
	  }
	}
      }
      translate([0, 0, -cuff_clearance-w])
	scale([1, 1,.5])
	difference(){
	sphere(chuck_radius);
	translate([0, 0, chuck_radius])
	  cube(2*chuck_radius, 2*chuck_radius, 2*chuck_radius, center=true);
      }
    }
    translate([0,0, -cuff_clearance-w-4*mm/2-1*mm])
      cylinder(h=30, r=1*mm);
    translate([0,0, -4.2*mm-cuff_clearance+w/2])
      rotate(90, [0, 1, 0])
      cylinder(h=30, r=1*mm);
    // Slice
    /*
      rotate(90, [0,0, 1])
      translate([50, 0, 0])
      cube(100, 100, 100, center=true);
    */
  }
}
// chuck();
