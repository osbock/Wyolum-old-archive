include <manifold_parts.scad>

$fn = 50;

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

// female
/*
translate([0, 0*.5*inch, .8*inch-3*mm])
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
	  //tube(1*mm, 6.33*mm/2, 5.82*mm); // o-ring holder
	
    }
  }
}
*/
x = 2*(8.33*mm/2 + 4.82*mm);

module flange_mount(){
  difference(){
    color([0, 1, 0, 1])
      tube(1*mm, 6*mm, 8*mm);
    translate([-6*mm, 0, -.1])
      cube([12*mm, 20*mm, 3.1*mm]);
  }
  translate([0, 0, -3*mm]){
    difference(){
      color("blue")
	tube(3.05*mm, 8.33*mm/2 + 4.82*mm, 5*mm); // panel mount
      translate([-x/2, 0, 0])
	cube([x, 20*mm, 3.1*mm]);
    }
  
    translate([0, 0, -1*mm])
      color("green")
      tube(1*mm, 6.33*mm/2, 15*mm); // panel mount
    translate([0, 0, -5*mm])
      difference(){
      cylinder(h=5*mm, r1=0*mm, r2=12*mm);
      cube([15*mm, 15*mm, 6*mm], center=true);
      cylinder(h=6*mm, r=6.33*mm/2);
    }
  }
}

flange_mount();
