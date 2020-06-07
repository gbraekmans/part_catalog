// Height and width of the tube
W = 25;

// Thickness of the walls of the tube
T = 1.5;

// Radius of the fillet
F =2;

// Thickness of the face plate
P = 2;

// Height of the snap-in anchors
A = 15;

include <../../globals.scad>
use <../../dim.scad>

use <common.scad>

module plug_square(tube_size, tube_thickness, fillet_radius, face_plate_thickness=2, anchors_height=15) {
    anchor_radius = max(fillet_radius - tube_thickness,0);
    anchor_supports_length = sqrt(2) * (tube_size - 2 * (tube_thickness + anchor_radius))
                           + 2 * anchor_radius
                           - EXTRUSION_WIDTH; // Inset the support just a little

    module square_profile_sketch() {
        offset(r=fillet_radius)
        offset(delta=-fillet_radius)
        square(tube_size, center=true);
    }

    make_anchors(anchors_height) {
        offset(delta=-tube_thickness)
        square_profile_sketch();

        // use bridges instead of support
        // so reinforce the corners
        union() {
            rotate(45)
            line(anchor_supports_length);

            rotate(-45)
            line(anchor_supports_length);
        }
    }

    translate([0,0,-face_plate_thickness])
    make_face_plate(face_plate_thickness) square_profile_sketch();
}

// Actual object
plug_square(W, T, F, P, A);

// Documentation
translate([0,-W/2])
dim_x(W, "W", F);

translate([W/2,0]) {
    dim_y(W, "W", F);
    
    translate([0, -(W-T)/2])
    dim_y(T, "T", T + dim_text_line(1));
}

translate([-W/2,0, (A+P)/2 -P])
dim_z(A + P, undef, T);

translate([-W/2+F,-W/2+F])
dim_xy_radius(F, "F", theta=-135);