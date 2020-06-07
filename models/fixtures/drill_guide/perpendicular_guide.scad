include <../../globals.scad>;
use <../../dim.scad>;

SIDE_LENGTH = 25;

BORE_DIAMETER = 3;

HEX_WRENCH_SIZE = 5.5;

HEX_HEIGHT = 2.4;

module drill_guide(
    side_length,
    bore_diameter,
    hex_wrench_size,
    hex_height,
    height=25
)
{
    hex_diameter = hex_wrench_size / cos(180/6);
    
    difference() {
        linear_extrude(height, center=true)
        offset(r=0.1 * side_length)
        offset(delta=-0.1 * side_length)
        square([side_length, side_length], center=true);
        
        cylinder(height + 2*EPS, r=bore_diameter/2, center=true);
        
        if(hex_wrench_size) {
            translate([0,0,height/2 - hex_height + EPS])
            cylinder(hex_height, r=hex_diameter/2, $fn=6);

            rotate([180,0,0])
            translate([0,0,height/2 - hex_height + EPS])
            cylinder(hex_height, r=hex_diameter/2, $fn=6);
        }
    }
    
    // Documentation
    translate([0,0, height/2]) {
        dim_xy_diameter(hex_wrench_size);
        dim_xy_diameter(bore_diameter, theta=45);
    }

    translate([0,0, -height/2]) {
        translate([0,-side_length/2]) dim_x(side_length);
        translate([side_length/2,0]) dim_y(side_length);
    }
    translate([-side_length/2,-side_length/2]) dim_z(height);

}

drill_guide(SIDE_LENGTH, BORE_DIAMETER, HEX_WRENCH_SIZE, HEX_HEIGHT);