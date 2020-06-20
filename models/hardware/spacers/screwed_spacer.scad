include <../../globals.scad>;

use <../../dim.scad>;

//W: The width of the spacer
WIDTH = 18;

//H: The height of the spacer
HEIGHT = 10;

module screwed_spacer(width, height, length=50) {
    r = min(width, length) / 4;
    
    difference() {
        linear_extrude(height, center=true)
        offset(r=r)
        offset(delta=-r)
        square([length, width], center=true);

        translate([-length/4, 0])
        screw(height, height / 2);

        translate([length/4, 0])
        #screw(height, height / 2);
    }
    
    translate([length/2 -r, 0])
    dim_y(width, "W", r);

    translate([-length/2, -width/2])   
    dim_z(height, "H");
    
    translate([0,0,height/2])
    dim_x(2*length/4);
}

screwed_spacer(WIDTH, HEIGHT);