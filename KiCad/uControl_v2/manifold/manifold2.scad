include <manifold_parts.scad>

scale = .1;
inch = 1000 * scale;
mm = 39.37 * scale;
wall = .05 * inch;
radius = .5*inch;
or = wall + radius;
gap = .25*inch;
gap = 0.02 * inch;
/*tee(radius * .5, radius, wall);*/

w=1.4*mm;
difference(){
  union(){
    translate([0, 0, -.05*inch])
      barb(4*mm/2 - w, 6*mm/2-w, 10*mm, 3*mm, 2*mm, w);
    translate([0, 5.1*mm / 2 + wall, -28*mm / 2])
      rotate(90, [-1, 0, 0])
      difference(){
      union(){
	taper(5.1*mm/2 - w, 4.8*mm/2 - w, 15*mm, w);
	difference(){
	  translate([0, 0, -.3*inch])
	    difference(){
	    cylinder(r=28*mm/2, h=.3*inch);
	    translate([0, 0, wall])
	      cylinder(r=28*mm/2 - wall, h=.3 * inch - 2 * wall);
	  }
	  translate([0, 0, -wall])
	    cylinder(r=5.1*mm / 2 - w, h=wall);
	}
      }
      /*translate([0, 0, -1*inch])cube(1 * inch);*/
    }
  }
  translate([0, 0, -w])
  cylinder(r=4*mm/2 - w, h=10*mm + w);
}

translate([0, 0, -10 * inch])
union(){
  translate([radius/2 + wall, 0, 0])
    rotate(180, [0, 1, 0])
    translate([0, 0, -(radius/2 + wall)])
    elbow(radius/2, wall);

  translate([-(radius + wall + gap), 0,-(radius / 2 + wall)])
    eks(radius, radius*.5, wall);
  translate([-(radius + wall), 0, 0])
    union(){
    translate([-(radius + wall + gap), 0, 0])
      translate([-( 1 * inch + gap), 0, 0])
      union(){
      rotate(90, [0, 1, 0])
	taper(radius, radius / 2, 1 * inch, wall);
      translate([-(radius + wall + gap), 0, -(radius + wall)]){
	tee(radius, radius, , wall);
	translate([or, 0, -(or + gap)])
	  rotate(90, [0, -1, 0])
	  union(){
	  elbow(radius, wall);
	  translate([0, 0, -(2 * inch + gap)])
	    tube(2*inch, radius, wall);
	}
      }
    }
  }
}
