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
chuck_thickness = 0.6*inch;
cuff_clearance = 5*mm;

module female(){
  // female
  translate([0, 0, 20.34*mm])
  scale(1/scale){
    difference(){
      tube(7*mm, 1*mm, w); // manifold-connect
      translate([0, 0, 6.25*mm])
	difference(){
	cylinder(h=1*mm + w, r1=1.1*mm + w, r2=1.1*mm+w);
	translate([0,0,-1*mm])
	  cylinder(h=2*mm + w, r1=2*mm + w, r2=0.0*mm);
      }
    }
    translate([0, 0, -5 * mm])
      union(){
      taper(5.75*mm/2, 2*mm, 5*mm, w);
      tube(3*mm, 2*mm, w);
      translate([0, 0, -12.34 * mm])
	union(){
	tube(12.34 * mm, 5.75*mm/2, w);
	translate([0, 0, -3*mm])
	  tube(3*mm, 8.33*mm/2, 4.82*mm); // panel mount
	//translate([0, 0, -4.0*mm])
	  //color("blue")
	  // tube(1*mm, 6.33*mm/2, 5.82*mm); // o-ring holder
      }
    }
  }
}

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
chuck();

