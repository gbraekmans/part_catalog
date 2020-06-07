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


module cylindrical_bushing(
            bore_radius,
            height,
            radius,
            chamfer=0,
            pin_height=0,
            pin_count=12,
            pin_bore_coverage=0.5
           )
{    
    radius = default(radius, bore_radius + max(chamfer, pin_height) + WALL); 
    assert(radius >= bore_radius + max(chamfer, pin_height) + WALL_XS);
        
    difference() {
        cylinder(height, r=radius, center=true);
        bushing_bore(bore_radius, height + 2*EPS, chamfer, pin_height, pin_count, pin_bore_coverage);
    }
}

cylindrical_bushing(D/2,H, O/2, C, P, N, I);