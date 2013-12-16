include <manifold_parts.scad>
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

module Flow(){
  translate([-flow_ctrl_box_l/2, -flow_ctrl_box_w / 2, 0])
    color("red")cube([flow_ctrl_box_l, flow_ctrl_box_w, flow_height - 2 * flow_r]);
  translate([0, 0, -flow_r])
    rotate(90, [0, 1, 0])
    translate([0, 0, -flow_l/2])
    tube(flow_l + flow_smooth_l, flow_r, 1*mm);
}

module Unit(){
  translate([-50*mm, pcb_l/2 - flow_ctrl_box_w/2, 0])
    Flow();
  }

// Unit();



