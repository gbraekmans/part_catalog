// Diameter of the tube
D = 25;

// Thickness of the walls of the tube
T = 1.5;

// Thickness of the face plate
P = 2;

// Height of the snap-in anchors
A = 15;

include <../../globals.scad>
use <../../dim.scad>

use <common.scad>

module plug_circle(diameter, tube_thickness, face_plate_thickness=2, anchors_height=15) {    
    r = diameter/2;

    make_anchors(anchors_height) {
        offset(delta=-tube_thickness)
        circle(r=r);

        // use bridges instead of support
        // so reinforce the corners
        union()
            for(a=[0:180/4:180])
                rotate(a)
                line(2*(r-tube_thickness));
    }

    translate([0,0,-face_plate_thickness])
    make_face_plate(face_plate_thickness) circle(r=diameter/2);
}

// Actual object
plug_circle(D, T, P, A);

// Documentation
dim_xy_diameter(D, "D");

translate([-(D-T)/2,0])
dim_x(T, "T",D/2);

translate([-D/2,0, (A + P)/2 - P])
dim_z(A + P, leader=T);

