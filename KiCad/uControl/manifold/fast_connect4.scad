include <manifold_parts.scad>
// include <fast_connect.scad>

$fn = 150;

scale = 1.;
inch = 25.4 * scale;
mm = 1. * scale;
wall = .05 * inch;
radius = .5*inch;
or = wall + radius;
gap = .25*inch;
gap = 0.02 * inch;

tol = 0.1*mm;
/*tee(radius * .5, radius, wall);*/

w=1.4*mm;
chuck_thickness = 0.6*inch;
cuff_clearance = 5*mm;

flange_h = 3*mm;
// flange_or = 8.985*mm;
flange_or = 10*mm;
flange_ir = 4.16*mm;
module female(flange_h=flange_h,
	      flange_or=flange_or, 
	      flange_ir=flange_ir){
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
	translate([0, 0, -flange_h]) washer(flange_ir+1*mm, flange_ir, 4*mm); // flange support
	translate([0, 0, -flange_h]) washer(flange_or, flange_ir, flange_h); // flange
      }
    }
  }
}

chuck_h = 17*mm;
chuck_radius = 8*mm;
cuff_clearance = 8*mm;
barb_length = 10*mm;
module chuck(w=w, chuck_radius=chuck_radius, cuff_clearance=cuff_clearance, barb_length=barb_length){
  difference(){
    scale(1/scale){
      taper(5.1*mm/2 - w, 4.8*mm/2 - w, chuck_h, w); // male connect
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

module enclosure_mockup(wall_thickness=1*mm){
  square_side=40*mm;

  color("blue")
    difference(){
    cylinder(h=flange_h + 2 *mm, r=flange_or + 2*mm);
    translate([0, 0, -tol])
      cylinder(h=flange_h+2*tol, r=flange_or+tol);
    cylinder(h=10*mm, r=flange_ir+1*mm+tol);
    translate([-flange_or - tol, 0, 0])
      cube([2 * flange_or + tol, 20*mm, flange_h + tol]);
    translate([-flange_ir - 1*mm - tol, 0, flange_h-tol])
      cube([2 * (flange_ir+ 1*mm + tol), 20*mm, flange_h + 2*tol]);
  }
  difference(){
    union(){
      translate([-square_side/2, -square_side/2, -wall_thickness])
	cube([square_side, square_side, wall_thickness]);
      translate([0,0, -2*mm])
	cylinder(h=1*mm, r2=flange_or + 2*mm, r1=chuck_radius);
    }
    translate([0, 0, -20*mm])
      cylinder(h=40*mm, r=5.48/2);
  }

}

wall_thickness = 1*mm;
difference(){
  union(){
    //translate([0, 0*mm, 0*mm])female();
    // color("white") enclosure_mockup();
    color("blue")translate([0, 0*mm, -12*mm-tol]) chuck();
  }
  //translate([-50*mm, 0, -50*mm])cube([100*mm, 100*mm, 100*mm]);
}

