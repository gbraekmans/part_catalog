include <../../globals.scad>;

use <../../dim.scad>;

//W: The width of the foot
WIDTH = 18;

//H: The height of the foot
HEIGHT = 10; //[4:50]

//L: The length of the foot
LENGTH = 50;

//R: The radius of the fillet
FILLET = 5;

module rectangular_foot(size, r = 0) {
    
    chamfer = 1;
    
    module sketch() {
        offset(r=r)
        offset(delta=-r)
        square([size[X], size[Y]], center=true);        
    }
    
    assert(size[Z] >= SCREW);
    
    difference() {
        
        hull() {
            translate([0,0,chamfer/2])
            linear_extrude(size[Z] - chamfer, center=true)
            sketch();

            translate([0,0,-size[Z]/2])
            linear_extrude(chamfer)
            offset(delta=-chamfer)
            sketch();          
        }


        translate([-size[X]/4, 0, SCREW/2])
        screw(size[Z] + EPS, size[Z]);

        translate([size[X]/4, 0, SCREW/2])
        screw(size[Z] + EPS, size[Z]);
    }
    
    translate([size[X]/2 -r, 0])
    dim_y(size[Y], "W", r);

    translate([-size[X]/2, -size[Y]/2])   
    dim_z(size[Z], "H");

    translate([0,-size[Y]/2 + r,0])
    dim_x(size[X], "L", r);
    
    translate([size[X]/2 - r,-size[Y]/2 + r,0])
    dim_xy_radius(r);
    
    translate([0,0,size[Z]/2])
    dim_x(2*size[X]/4);
}

rectangular_foot([LENGTH, WIDTH, HEIGHT], FILLET);