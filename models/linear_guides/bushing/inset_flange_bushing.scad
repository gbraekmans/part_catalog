include <../../globals.scad>;
use <common.scad>;


// The height of the bushing
H = 40;

// Diameter of the bore
D = 25;

// Outer diameter of the bushing
O = 35;

// Pin height (0 to disable)
P = 2;

// The amount of pins
N = 12;

// Percentage of rod circumference covered by pins
I = 0.5; //[0:0.01:1]

// The distance which should be chamfered
C = 2;

// radius of the flange
F = 50;

module inset_flange_bushing(
    bore_radius,
    height,
    radius,
    flange_radius,
    flange_height,
    chamfer=0,
    pin_height=0,
    pin_count=12,
    pin_bore_coverage=0.5
)
{
    bushing_flanged_body(
        radius,
        height,
        flange_radius,
        flange_height);
    
    for(a=[0:360/3:360])
        rotate(a)
        translate([radius + WALL + SCREW,0,-height/2 + flange_height /2])
        rotate([180, 0, 0])
        screw(flange_height + 2 * EPS);
}

inset_flange_bushing(D/2, H, O/2, 