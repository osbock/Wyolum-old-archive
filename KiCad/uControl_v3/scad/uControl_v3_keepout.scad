mm = 1.;
inch = 25.4 * mm;
include <BBB.scad>;

translate([.8730*inch - hole1Pos[0], .3340*inch - hole1Pos[1], 0]){
  translate([0, boardWidth / 2,12*mm ])
    rotate(180, [1, 0, 0])
    translate([0, -boardWidth/2,0 ])
    LVDS();

  translate([0, boardWidth / 2,24*mm ])
    rotate(180, [1, 0, 0])
    translate([0, -boardWidth/2,0 ])
    beagleboneblack();
}

$fs=25;

// mouting holes:

uC_HOLES = [[4 * mm, 4 * mm],
	    [4 * mm, 76 * mm],
	    [4 * mm, 118 * mm],
	    [4 * mm, 148 * mm],
	    [95 * mm, 4 * mm],
	    [95 * mm, 76 * mm],
	    [186 * mm ,148 * mm],
	    [186 * mm ,118 * mm],
	    [186 * mm, 76 * mm],
	    [186 * mm, 4 * mm],
	    ];

uC_LENGTH = 190 * mm;
uC_WIDTH = 152 * mm;
uC_HEIGHT = .06 * inch;
HOLE_D = 3 * mm;
HOLE_R = HOLE_D / 2;
small = .1;
module uC_mountingHole(centre){
  echo("HOLE", centre);
  translate([centre[0], centre[1], uC_HEIGHT / 2 ]) {
    cylinder(r=HOLE_R,h=20 * (2 * uC_HEIGHT + small),center=true);
  }
}

module uC_board(){
  cube([uC_LENGTH, uC_WIDTH, uC_HEIGHT]);
}

module uC_board_neg(){
  for(i=[0:len(uC_HOLES) - 1]){
    uC_mountingHole(uC_HOLES[i]);
  }
}

module uControl(){
  difference(){
    uC_board();
    uC_board_neg();
  }
}

module usbhub(){
  color(boardColor){
    cube([90 * mm, 30 * mm, 8 * mm]);
    translate([67 * mm, 6*mm, 8*mm])
      cube([7 * mm, 15 * mm, 15 * mm]);
    translate([80 * mm, 6*mm, 8*mm])
      cube([7 * mm, 15 * mm, 15 * mm]);
  }
}

flow_r = 22.3 * mm / 2;
flow_l = 81.6 * mm;translate([-flow_ctrl_box_l/2, flow_ctrl_box_w / 2, 0])
cube([flow_l, flow_height - 2 * flow_r]);

flow_height = 34.2 * mm; 
flow_ctrl_box_l = 27*mm;
flow_ctrl_box_w = 30*mm;
flow_smooth_l = 100*mm;

module Flow(){
  translate([45 * mm, 133 * mm, 2  * flow_r]){
    translate([-flow_ctrl_box_l/2, -flow_ctrl_box_w / 2, ])
      color("red")cube([flow_ctrl_box_l, flow_ctrl_box_w, flow_height - 2 * flow_r]);
    translate([0, 0, -flow_r])
      rotate(90, [0, 1, 0])
      translate([0, 0, -flow_l/2])
      cylinder(flow_l + flow_smooth_l, flow_r, flow_r);
  }
}

pump_r = 27*mm / 2;
pump_h = 63*mm;
module Pump(){
  translate([4.0 * inch + pump_h, 4.0 * inch,  pump_r])
    rotate(-90, [0, 1, 0]){
    translate([0, 0, pump_h])cylinder(r=1.5*mm, h=10*mm);
    cylinder(r=pump_r, h=pump_h);
  }
}

interior_w = 8*inch;
module Interior(){
  color([0, 1, 0, .3])
  translate([-interior_w/2, 0, 0])
  rotate(90, [0, 0, 1])
    rotate(90, [1, 0, 0]){
    linear_extrude(height=interior_w)
      polygon(points=[
		      [-uC_LENGTH/2, -2*flow_r - uC_HEIGHT - 10*mm],
		      [uC_LENGTH/2, -2*flow_r - uC_HEIGHT - 10*mm],
		      [uC_LENGTH/2, 60*mm],
		      [-uC_LENGTH/2, 0*mm]
		      ], paths=[[0, 1, 2, 3]]);
  }
}


translate([0, 0, -uC_HEIGHT]) uControl();
translate([8*mm, 30*mm, 24*mm])usbhub();
Flow();
Pump();
translate([uC_LENGTH/2, uC_WIDTH/2, 30*mm])
rotate(180, [0, 0, 1])
Interior();
translate([0, uC_WIDTH + 10, -3])
cylinder(r=10, h=flow_r * 2 + 10 *mm);
