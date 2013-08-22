include <manifold_parts.scad>
include <fast_connect4.scad>
include <dimlines.scad>

$fn=150;
mm = 1.;
inch = 24.5;

boolx_l = 23.27;
boolx_w = 8.87;
boolx_h = 9.35;
boolx_port1 = 4.57;
boolx_port2 = 18.14;
boolx_port3 = 21.69;
boolx_port_h = 12.19;
boolx_screw2_l = 19.915;
boolx_screw1_l = 19.915 - 16.26;
boolx_screw_r = 1.5*mm;
boolx_port_r = 1.25*mm;

module boolx_valve(){
  difference(){
    union(){
      cube([boolx_l, boolx_w, boolx_h]);
      translate([boolx_port1, boolx_w/2, 0])cylinder(r=boolx_port_r, h=boolx_port_h);
      translate([boolx_port2, boolx_w/2, 0])cylinder(r=boolx_port_r, h=boolx_port_h);
      translate([boolx_port3, boolx_w/2, 0])cylinder(r=boolx_port_r, h=boolx_port_h);
    }
    union(){
      translate([boolx_screw1_l, 0, -1])cylinder(r=boolx_screw_r, h=boolx_h + 2);
      translate([boolx_screw1_l, boolx_w, -1])cylinder(r=boolx_screw_r, h=boolx_h + 2);
      translate([boolx_screw2_l, 0, -1])cylinder(r=boolx_screw_r, h=boolx_h + 2);
      translate([boolx_screw2_l, boolx_w, -1])cylinder(r=boolx_screw_r, h=boolx_h + 2);
    }
  }
}
//boolx_valve();

sfm3000_or = 11.5;
sfm3000_ir = 10;
sfm3000_taper_r = 11;
sfm3000_l = 82;
sfm3000_end_l = 19.70;
sfm3000_inter_r = 20.71 / 2.;
sfm3000_h = 34;
sfm3000_box_l = 27.0;
sfm3000_box_w = 22.9;
sfm3000_box_h = 15.0;
module sfm3000(){
  translate([0, 0, sfm3000_or])rotate(90, [0, 1, 0])
  difference(){
    union(){
      translate([-sfm3000_h + sfm3000_or, sfm3000_box_w/2 + 2, 52.5])rotate(90, [0, 1, ])cylinder(r=2, h=sfm3000_box_h);
      translate([-sfm3000_h + sfm3000_or, -sfm3000_box_w/2 - 2, 29.2])rotate(90, [0, 1, ])cylinder(r=2, h=sfm3000_box_h);
      translate([-sfm3000_h + sfm3000_or, -sfm3000_box_w/2, (sfm3000_l - sfm3000_box_l)/2])cube([sfm3000_box_h, sfm3000_box_w, sfm3000_box_l]);
      translate([0, 0, sfm3000_l - sfm3000_end_l])cylinder(r1=sfm3000_or, r2=sfm3000_taper_r, h=sfm3000_end_l);
      translate([0, 0, sfm3000_end_l])cylinder(r=sfm3000_inter_r, h=sfm3000_l - 2 * sfm3000_end_l);
      cylinder(r2=sfm3000_or, r1=sfm3000_taper_r, h=sfm3000_end_l);
    }
    union(){
      translate([0, 0, -1])cylinder(r=sfm3000_ir, h=sfm3000_l + 2);
    }
  }
}
//sfm3000();

inlet_overlap = 5;
inlet_l = 100 + inlet_overlap;
inlet_ir = sfm3000_or;
inlet_or = inlet_ir + 1;
module inlet_tube(){
  translate([0, 0, inlet_or])rotate(90, [0, 1, 0])
  difference(){
    union(){
      cylinder(r=inlet_or, h=inlet_l);
    }
    union(){
      translate([0, 0, -1])cylinder(r=inlet_ir, h=inlet_l + 2);
    }
  }
}

gage_l = 12.7;
gage_w = 16.0;
gage_h = 11.64;
gage_box_l=10.7;
gage_box_w=16-5.13;
gage_box_h=3.65;
gage_pcb_h=7.29;
gage_pcb_thickness = .7;
gage_port_h = 10.14;
gage_port_l = 3.5;
gage_port_barb_l = 2.5;
gage_port_r1 = 1.5;
gage_port_r2 = 1.1;

module hce_gage(){
  offset = .1*inch;
  sep = .1*inch;
  difference(){
    union(){
      for(i=[0:3]){
	translate([offset + i * sep-.5, gage_w - .025*inch, 0])cube([.05*inch, .025*inch, gage_pcb_h]);
	translate([offset + i * sep-.5, 0, 0])cube([.05*inch, .025*inch, gage_pcb_h]);
      }
      translate([1, 2.65, gage_pcb_h + gage_pcb_thickness])cube([gage_box_l, gage_box_w, gage_box_h]);
      translate([0, 0, gage_pcb_h])cube([gage_l, gage_w, gage_pcb_thickness]);
      translate([11.7, 11.5, 10.14])rotate(90, [0, 1, 0]){
	cylinder(r=2.2/2, h=3.5);
	translate([0, 0, gage_port_l])cylinder(r2=gage_port_r2, r1=gage_port_r1, h=gage_port_barb_l);
      }
    }
    union(){
    }
  }
}

module blank(){
  difference(){
    union(){
    }
    union(){
    }
  }
}

//translate([sfm3000_l + inlet_overlap, 0, 0])inlet_tube();
//sfm3000();
//translate([0, -25, 0])color("black"){
//  dimensions(length=sfm3000_l, line_width=1, loc=1);
//}

//translate([0, 2*inch, 0])
//boolx_valve();

//inlet_tube();

//translate([2*inch, 2*inch, 0])
//hce_gage();


