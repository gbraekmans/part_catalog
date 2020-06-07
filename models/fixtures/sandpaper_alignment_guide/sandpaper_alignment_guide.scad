include <../../globals.scad>;

use <../../dim.scad>;

D = 125;

H = 9.5;

// The maximum distance between the center points of two holes
T = 65;

SCREW = 4;

module dummy() {};
BASE_HEIGHT = 2;
PIN_HEIGHT = 10;

module sandpaper_alignment_guide(
            diameter,
            hole_diameter,
            hole_distance
        )
{

    module base() {
        chamfer = min(PIN_HEIGHT, hole_diameter/2) / 2;
        translate([0,0, - BASE_HEIGHT])
        cylinder(BASE_HEIGHT, r=diameter/2);
      
        
        for(a=[0:360/8:360])
            rotate(a)
            translate([hole_distance/2,0, 0]) {
                cylinder(PIN_HEIGHT - chamfer, r=hole_diameter/2);
                
                translate([0,0,PIN_HEIGHT - chamfer])
                cylinder(chamfer, r1=hole_diameter/2, r2=hole_diameter/2-chamfer);
            }
    }
    
    difference() {
        base();
        
        for(a=[0:360/4:360])
            rotate(a)
            translate([(diameter-hole_distance/2 + hole_diameter/2)/2, 0, - BASE_HEIGHT - EPS])
            cylinder(BASE_HEIGHT + 2 * EPS, r1=SCREW/2, r2=SCREW);
    }

}

sandpaper_alignment_guide(D, H, T);

// documentation

dim_xy_diameter(D, "D", center_mark=false, outline=false);

translate([T/2,0,0])
dim_xy_diameter(H, "H", center_mark=false, outline=false);

translate([0,-H/2])
dim_x(T,"T",H/2);