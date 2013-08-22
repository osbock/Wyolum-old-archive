include <manifold_parts.scad>
include <fast_connect4.scad>
include <dimlines.scad>
$fn=150;
mm = 1.;
inch = 24.5;

flow_r = 22.3 * mm / 2;
flow_l = 81.6 * mm;translate([-flow_ctrl_box_l/2, flow_ctrl_box_w / 2, 0])
cube([flow_, flow_height - 2 * flow_r]);

flow_height = 34.2 * mm; 
flow_ctrl_box_l = 27*mm;
flow_ctrl_box_w = 30*mm;
flow_smooth_l = 100*mm;
pcb_l = 6*inch;
pcb_w = 7.5*inch;
interior_w = 8*inch;
pcb_t = 1.7*mm;
pcb_mount_offset = .135*inch;
bit_l = 2 * inch;
bit_r = 0.060 * inch;

pump_r = 27*mm / 2;
pump_h = 63*mm;

power_h = 10.5 * mm;
power_d = 8.7 * mm;
power_flange_h = 1.5*mm;

module usb(){
  translate([-interior_w/2 - 1*mm, pcb_l/2 - 1.5*inch, 20*mm])
    cube([2.4*inch, 1.4*inch, 0.7*inch]);
}
module power_jack(){
  translate([-interior_w/2, pcb_l/2 - 10*mm, 10*mm])
    rotate(90, [0, 1, 0])
    difference(){
    union(){
      cube([9*mm, 10.5*mm, 3*mm], center=true);
      translate([0, 0, 1*mm])
	rotate(0, [0, 1*mm, 0])
	cylinder(r=power_d/2, h=power_h);
    }
  }
}
module PCB(){
  rotate(90, [0, 0, 1])
    translate([-pcb_l/2, -pcb_w/2, -pcb_t])
    difference(){
    cube([pcb_l, pcb_w, pcb_t]);
    translate([pcb_mount_offset, pcb_mount_offset, -bit_l/2.]) cylinder(r=bit_r, h=bit_l);
    translate([pcb_l - pcb_mount_offset, pcb_mount_offset, -bit_l/2.]) cylinder(r=bit_r, h=bit_l);
    translate([pcb_mount_offset, pcb_w - pcb_mount_offset, -bit_l/2.]) cylinder(r=bit_r, h=bit_l);
    translate([pcb_l - pcb_mount_offset, pcb_w - pcb_mount_offset, -bit_l/2.]) cylinder(r=bit_r, h=bit_l);
  }
}

module Valve(){
  translate([45*mm, 10*mm, -2*flow_r])
  translate([0, 0, 6*mm])
  cube([25*mm, 10*mm, 12*mm], center=true);
}

module Gage(){
  translate([pcb_l/2, 1.5*inch, -2*flow_r])
  rotate(180, [0, 0, 1]){
    translate([0, 0, 5*mm])cube([11*mm, 16*mm, 10*mm], center=true);
    translate([5*mm, 4*mm, 9])rotate(90, [0, 1, 0])cylinder(r=1.5*mm, h=10*mm);
  }
}

module Pump(){
  translate([-pump_h/2, 1.25*inch, -2 * flow_r + pump_r])
    rotate(90, [0, 1, 0]){
    translate([0, 0, pump_h])cylinder(r=1.5*mm, h=10*mm);
    cylinder(r=pump_r, h=pump_h);
  }
}
module Flow(){
  translate([-flow_ctrl_box_l/2, -flow_ctrl_box_w / 2, 0])
    color("red")cube([flow_ctrl_box_l, flow_ctrl_box_w, flow_height - 2 * flow_r]);
  translate([0, 0, -flow_r])
    rotate(90, [0, 1, 0])
    translate([0, 0, -flow_l/2])
    tube(flow_l + flow_smooth_l, flow_r, 1*mm);
}
module Interior(){
  color([0, 1, 0, .3])
  translate([-interior_w/2, 0, 0])
  rotate(90, [0, 0, 1])
    rotate(90, [1, 0, 0]){
    linear_extrude(height=interior_w)
      polygon(points=[
		      [-pcb_l/2, -2*flow_r - pcb_t - 10*mm],
		      [pcb_l/2, -2*flow_r - pcb_t - 10*mm],
		      [pcb_l/2, 60*mm],
		      [-pcb_l/2,0*mm]
		      ], paths=[[0, 1, 2, 3]]);
  }
}

module Unit(){
  translate([0, 0, -2 * flow_r - 1*mm])
    color("blue")PCB();
  translate([-50*mm, pcb_l/2 - flow_ctrl_box_w/2, 0])
    Flow();
  translate([interior_w/2, pcb_l/2-3*flange_or, 10 * mm])
    rotate(-90, [0, 1, 0])
    union(){
    female();
    translate([0, 0, -2*mm])
      rotate(90, [0, 0, -1])
      chuck();
    rotate(90, [0, 0, -1])
      enclosure_mockup();
  }
  color("red")power_jack();
  color("red")usb();
  Pump();
  Gage();
  Valve();
  translate([20*mm, -20*mm, 0])Valve();
  Interior();
}

module Holes(){
  difference(){
    Interior();
    translate([1*mm, 0, 0])
    power_jack();
    usb();
    translate([interior_w/2, pcb_l/2-3*flange_or, 10 * mm])
      rotate(-90, [0, 1, 0])
      union(){
      translate([0, 0, -2*mm])
    	rotate(90, [0, 0, -1])
    	chuck();
    }
  }
}
//rotate(180, [0, 0, 1])
//rotate(90, [-1, 0, 0])
// Unit();
Holes();

module dims(){
  translate([-interior_w/2, -100, 0])
    dimensions(length=interior_w, line_width=2, loc=0);
  translate([-120, pcb_l/2, 0])rotate(-90, [0, 0, 1])
    dimensions(length=pcb_l, line_width=2, loc=0);
  translate([-120, pcb_l/2 + 10, -2 * flow_r - pcb_t - 10*mm])rotate(-90, [0,  1, 0])
    dimensions(length=60*mm + 2 * flow_r + pcb_t + 10*mm, line_width=2, loc=0);
  translate([-120, -pcb_l/2 - 10, -2 * flow_r - pcb_t - 10*mm])rotate(-90, [0,  1, 0])
    dimensions(length=35*mm, line_width=2, loc=1);
}
dims();



