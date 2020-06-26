include <../../globals.scad>;
use <../../dim.scad>;

use <common.scad>;

//D: Diameter of the bore
DIAMETER = 25;

//H: Height of the bushing
HEIGHT = 20;

//R: Distance to rod center
ROD_CENTER = 29.5;

// Radius of the chamfer
CHAMFER = 2;

// Height of the pins (0 to disable)
PIN_HEIGHT = 0;

// The amount of pins
PIN_COUNT = 12;

// Percentage of rod circumference covered by pins
COVERAGE = 0.5; //[0:0.01:1]

module curved_bushing(
    bore_radius,
    height,
    rod_center_delta,
    chamfer=0,
    pin_height=0,
    pin_count=12,
    pin_bore_coverage=0.5
    )
{
    
    assert(WALL + bore_radius + max(chamfer, pin_height) <= rod_center_delta);
    
    width = 4 * (SCREW + WALL) + bore_radius*2 + 2*max(chamfer, pin_height);
    r = bore_radius + max(chamfer, pin_height) + WALL;
    
    screw_pos_x = r + SCREW;
    screw_pos_z = height/2 - WALL - SCREW;
    
    // Determine the amount of screws for the bushing, 4 if it can support it
    screw_pos = height <= 4 * (SCREW + WALL)?
                [[screw_pos_x, 0], [-screw_pos_x, 0]] :
                [[screw_pos_x, 0, screw_pos_z], [-screw_pos_x, 0, screw_pos_z],
                 [screw_pos_x, 0, -screw_pos_z], [-screw_pos_x, 0, -screw_pos_z]];
    
    difference() {
        hull() {
            translate([0,-rod_center_delta/2,0])
            cube([width,
                  rod_center_delta,
                  height], center=true);
            
            cylinder(height, r=r, center=true);
        };
        
        bushing_bore(bore_radius, height + 2*EPS, chamfer, pin_height, pin_count, pin_bore_coverage);
        
        for(p=screw_pos)
            translate(p)
            rotate([-90,0,0])
            screw(rod_center_delta + 2*EPS, rod_center_delta);
    }
    
    // Documentation
    translate([0,0,height/2])
    dim_xy_diameter(bore_radius * 2, "D");
    
    translate([-width/2,-rod_center_delta,0])
    dim_z(height, "H");
    
    translate([0,-rod_center_delta/2,height/2])
    dim_y(rod_center_delta, "R");
    
    if(len(screw_pos) <= 2)
        translate([0,-rod_center_delta,0])
        dim_x(screw_pos_x * 2);
    else {
        translate([0,-rod_center_delta, screw_pos_z])
        dim_x(screw_pos_x * 2);

        translate([-screw_pos_x,-rod_center_delta, 0])
        dim_z(screw_pos_z * 2);      
    }
}

curved_bushing(DIAMETER/2, HEIGHT, ROD_CENTER, CHAMFER, PIN_HEIGHT, PIN_COUNT, COVERAGE);