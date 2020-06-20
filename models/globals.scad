//$fa = $preview? 12 : 6;
//$fs = $preview? 2 : 0.2;

EPS = 1/64;

// Used for indexing coordinates since the dot syntax is not
// officialy supported
X = 0;
Y = 1;
Z = 2;

// Slicer defaults
LAYER_HEIGHT = 0.2;
EXTRUSION_WIDTH = 0.5;

// Defaults for all parts
WALL_XS = 1;
WALL_S = 2;
WALL = 3;
WALL_L = 5;
WALL_XL = 7.5;

// Seems to be a good middle ground, corresponds to #8 for imperial ones
SCREW = 4;

// Set up OpenSCAD rendering defaults
$fa = 6;
$fs = EXTRUSION_WIDTH / 2;

function default(v, d) = is_undef(v)? d : v;

// For engraving in all planes except those parrallel to XY.
module v_engrave(t, size=10) {
    translate([0, 0.3, 0])
    rotate([90,0,0])
    linear_extrude(0.3 + EPS)
    text(t, size=size, font="DejaVu Sans:style=Book", valign="center", halign="center", $fn=8);
}

// For engraving in all planes parrallel to XY.
module h_engrave(t, size=10) {
    translate([0, 0, -0.7])
    linear_extrude(0.7 + EPS)
    text(t, size=size, font="DejaVu Sans:style=Book", valign="center", halign="center", $fn=8);
}

// Used for creating screw holes
module screw(height, head_extra_height=0) {
    translate([0,0, -(height + head_extra_height) / 2]) {
        cylinder(height + 2*EPS, r=SCREW/2);
        
        // Add some extra radius to account for hole shrinkage
        translate([0,0,height-SCREW/2 + 2*EPS])
        cylinder(SCREW/2, r1=SCREW/2, r2=SCREW + 0.5);
        
        translate([0,0,height])
        cylinder(head_extra_height + EPS, r=SCREW + 0.5);
    }
}