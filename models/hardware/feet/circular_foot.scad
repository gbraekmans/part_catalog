include <../../globals.scad>;
use <../../dim.scad>;

//D: Diameter
DIAMETER = 25;

//H: Height
HEIGHT = 10; // [4:50]

module circular_foot(height, diameter) {
    chamfer = 1;
    
    difference() {
        union() {
            translate([0,0, -chamfer/2])
            cylinder(height - chamfer, r=diameter/2, center=true);
            
            translate([0,0, height/2 - chamfer])
            cylinder(chamfer, r1=diameter/2, r2=diameter/2 - chamfer);
        }
        
        translate([0,0, SCREW/2])
        screw(height + EPS, height);
    }
    
    translate([-diameter/2,0])
    dim_z(height);
    
    translate([0,0,-height/2])
    dim_xy_diameter(diameter, center_mark=false);
}

circular_foot(HEIGHT, DIAMETER);