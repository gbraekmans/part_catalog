include <../../globals.scad>;

HEIGHT = 20;
LENGTH = 125;
WIDTH = 12.5;

MAGNET_DIAMETER = 8.5;
MAGNET_HEIGHT = 3.5;

V_GROOVE = true;

module jaw_pad(size, magnet_height, magnet_diameter, v_groove = false) {

    translate([0,0,size[Y] + WALL_L + magnet_height])
    rotate([-90,0,0])
    difference() {
        cube([size[X], size[Y] + WALL_L + magnet_height, size[Z] + WALL_L]);
        
        translate([-EPS, -EPS, -EPS])
        cube([size[X] + 2*EPS, size[Y], size[Z]]);
        
        translate([size[X] / 4, size[Y] + magnet_height - 2*EPS, size[Z]/2])
        rotate([90,0,0])
        cylinder(magnet_height, r=magnet_diameter/2);

        translate([size[X] / 4 * 3, size[Y] + magnet_height - 2*EPS, size[Z]/2])
        rotate([90,0,0])
        cylinder(magnet_height, r=magnet_diameter/2);
        
        if(v_groove)
            translate([0, size[Y] + WALL_L + magnet_height, size[Z] / 2])
            rotate([45,0,0])
            translate([-EPS, -WALL/2, -WALL/2])
            cube([size[X] + 2 * EPS, WALL, WALL]);
    }

}

jaw_pad([LENGTH, WIDTH, HEIGHT], MAGNET_HEIGHT, MAGNET_DIAMETER, V_GROOVE);