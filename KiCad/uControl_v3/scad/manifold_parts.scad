module tube(height, radius, wall){
  difoference(){
    cylinder(h=height, r=radius + wall);
    translate([0, 0, -1])
    cylinder(h=height+2, r=radius);
  }		
}

module washer(or, ir, h){
  tube(h, ir, or-ir);
}

module elb(radius, wall){
  d = 2 * (radius + wall);
  difference(){
    tube(sqrt(2) * (d), radius, wall);
    translate([radius + wall, -d, 0])rotate(45, [0, -1, 0])cube([d, 2*d, 2*d]);
  }
}

module elbow(radius, wall){
  union(){
    elb(radius, wall);
    translate([radius+wall, 0, radius + wall])
      rotate(90, [0, -1, 0])
      rotate(180, [0, 0, 1])
      elb(radius, wall);
  }
}

module tee(r1, r2, wall){
  difference(){
    union(){
      cylinder(h=(r2 + wall), r=r1+wall);
      translate([(r1 + wall), 0, (r2 + wall)])
	rotate(90, [0, -1, 0])
	cylinder(h=2*(r1 + wall), r=r2+wall);
    }
    translate([0, 0, -1])
    cylinder(h=(r2 + wall)+2, r=r1);
    translate([(r1 + wall), 0, (r2 + wall)])
      rotate(90, [0, -1, 0])
      translate([0, 0, -1])
      cylinder(h=2*(r1 + wall)+1, r=r2);
  }
}

module taper(r1, r2, h, wall){
  difference(){
    cylinder(r1=r1+wall, r2=r2+wall, h=h);
    cylinder(r1=r1, r2=r2, h=h);
  }
}

module eks(r1, r2, wall){
  difference(){
    union(){
      cylinder(h=2*(r2 + wall), r=r1+wall);
      translate([(r1 + wall), 0, (r2 + wall)])

	rotate(90, [0, -1, 0])
	cylinder(h=2*(r1 + wall), r=r2+wall);
    }
    cylinder(h=2*(r2 + wall), r=r1);
    translate([(r1 + wall), 0, (r2 + wall)])
    rotate(90, [0, -1, 0])
      cylinder(h=2*(r1 + wall), r=r2);
  }
}

/*
  r1 -- main tube inside radius 
  r2 -- fattest part barb inside radius
  h1 -- total height
  h2 -- height of barb
  h3 -- offset from top to start of barb
 */
module barb(r1, r2, h1, h2, h3, wall){
  union(){
    tube(h1, r1, wall);
    translate([0, 0, h1 - h2 - h3])
      taper(r2, r1, h2, wall);
  }
}
module board(){
  import("uControl_v2.stl");
}

