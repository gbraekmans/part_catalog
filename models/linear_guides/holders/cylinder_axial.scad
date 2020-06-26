include <../../globals.scad>;
use <../../dim.scad>;

DIAMETER = 25;

HEIGHT = 25;

module cylinder_axial_holder(diameter, height) {
    
    assert(height > WALL);
    
    outer_r = diameter/2 + 2 * WALL + SCREW * 2 + WALL;
    rib_size = outer_r/4;
    

    module body() {
        cylinder(height, r=diameter/2 + WALL);
        cylinder(WALL, r=outer_r);
    }


    difference(){
        union() {
            body();
            
            for(a=[60:360/3:360])
            rotate(a)
            hull() {
                intersection() {
                    translate([outer_r-rib_size, -rib_size/2,0])
                    cube([rib_size,rib_size, WALL]);
                    
                    body();
                    }

                intersection() {
                    translate([diameter/2+WALL-rib_size, -rib_size/2,0])
                    cube([rib_size,rib_size, height/1.5]);
                    
                    body();
                }
            }
        }

        translate([0,0,WALL])
        cylinder(height, r=diameter/2);

        for(a=[0:360/3:360])
        rotate(a)
        translate([diameter/2 + 2*WALL + SCREW, 0 , WALL/2-EPS])
        screw(WALL);
    }
    
    dim_xy_diameter(2*outer_r);
    
    translate([0,0,height])
    dim_xy_diameter(diameter);
}


cylinder_axial_holder(DIAMETER, HEIGHT);