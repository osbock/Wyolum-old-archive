inch = 1000;
mm = 39.37;
L = 4 * inch;
W = .75 * inch;
H = .75 * inch;
R = (3./16)*inch;
start = -L/3.;
stop = L/3.;
step = (stop - start) / 3;

module manifold(){
  difference(){
    union(){
      translate([-L/2, -W/2, -H/2])
	cube([L, W, H]);
    }
    translate([-L/2 + .25*inch, 0, 0])
      rotate(90, [0, 1, 0])
      cylinder(h=L, r=R);
    for(x=[start:step:stop]){
      translate([x, 0, 0])
	cylinder(h=.5*inch, r=R);
    }
  }
}

module tab2(){
  difference(){
    cube([1/4 * inch, 1.25 * inch, 1/16 * inch]);
    translate([1/8 * inch, .125*inch, 0])
    cylinder(h=.333*inch, r = 1.5*mm);
    translate([1/8 * inch, 1.125*inch, 0])
    cylinder(h=.333*inch, r = 1.5*mm);
  }
}

module tab1(){
  difference(){
    cube([1/4 * inch, 1.25/2 * inch, 1/16 * inch]);
    translate([1/8 * inch, .125*inch, 0])
    cylinder(h=.333*inch, r = 1.5*mm);
  }
}

rotate(90, [1, 0, 0])
union(){
  manifold();
  rotate(-90, [1, 0, 0])
  translate([L/2.5, -1.25/2*inch, -.75/2*inch])
    tab1();

  rotate(-90, [1, 0, 0])
  translate([-L/2.5 - .25*inch, -1.25/2*inch, -.75/2*inch])
    tab1();

}
