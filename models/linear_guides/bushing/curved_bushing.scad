include <../../globals.scad>;
use <../../dim.scad>;

use <common.scad>;

// Diameter of the bore
D = 26;

// Height of the bushing
H = 20;

// Distance to rod center
R = 25;

// Radius of the chamfer
C = 2;

// Height of the pins (0 to disable)
P = 0;

// The amount of pins
N = 12;

// Percentage of rod circumference covered by pins
I = 0.5; //[0:0.01:1]

function bushing_width(bore_radius, chamfer, pin_height) = 4 * (SCREW + WALL) + bore_radius*2 + 2*max(chamfer, pin_height);

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
    
    width = bushing_width(bore_radius, chamfer, pin_height);
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
}

rotate(180)
curved_bushing(D/2, H, R, C, P, N, I);


// Documentation

width = bushing_width(D/2, C, P);
top_length = D/2 + max(C,P) + WALL;

translate([0,0,H/2]) {
    dim_xy_diameter(D, "D", theta=135);
    
    dim_x(width, undef, top_length);
    
    translate([0,R/2])
    dim_y(R, "R", width/2);
    
    translate([0, (R - top_length)/2])
    dim_y(top_length + R, undef, width/2 + dim_text_line(1));
}

translate([-width/2,0])
dim_z(H, "H");