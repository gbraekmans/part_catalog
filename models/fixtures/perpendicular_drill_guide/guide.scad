include <../../globals.scad>;

WALL = 2;

BORE = 8;

WASHER = 12;
WASHER_HEIGHT = 2;

HEIGHT = 20;

ARC_THICKNESS = 10;

SCREW = 4;

top_r = WASHER/2 + WALL;

bottom_r = HEIGHT + top_r;

difference() {
    // outside body
    union() {
        translate([0,0,-WALL])
        cylinder(WALL, r=bottom_r);
        
        cylinder(HEIGHT - WALL, r1=bottom_r, r2=top_r );
    }
    
    // Arc bottom cutout
    intersection() {
        translate([0,0,-ARC_THICKNESS])
        cylinder(HEIGHT, r1=bottom_r, r2=top_r );
        
        linear_extrude(HEIGHT)
        square(2*bottom_r, center=true);
    }
    
    // cut out right arc
    translate([(bottom_r + top_r) / 2,0,HEIGHT/2])
    cube([bottom_r - top_r, 2 * bottom_r, HEIGHT], center=true);

    // cut out left arc
    translate([-(bottom_r + top_r) / 2,0,HEIGHT/2])
    cube([bottom_r - top_r, 2 * bottom_r, HEIGHT], center=true);
    
    // flange cutout
    translate([0,0, -WALL/2])
    cylinder(WALL + 2*EPS, r=bottom_r - ARC_THICKNESS, center=true);
    
    // central bore
    cylinder(HEIGHT + EPS, r=BORE/2);
    
    // top washer
    translate([0,0,HEIGHT - WALL - WASHER_HEIGHT + EPS])
    cylinder(WASHER_HEIGHT, r=WASHER/2);


    // bottom washer
    translate([0,0,HEIGHT - WALL - ARC_THICKNESS + WASHER_HEIGHT - EPS])
    cylinder(WASHER_HEIGHT, r=WASHER/2);
    
    // outside notches
    for(a=[90:360/4:360])
        rotate(a)
        translate([bottom_r,0])
        rotate(45)
        linear_extrude(2*HEIGHT, center=true)
        square(ARC_THICKNESS/5, center=true);

    // inside notches
    for(a=[0:360/2:360])
        rotate(a)
        translate([bottom_r - ARC_THICKNESS,0])
        rotate(45)
        linear_extrude(2*HEIGHT, center=true)
        square(ARC_THICKNESS/5, center=true);
    
    // screw holes
    for(a=[45:360/4:360])
        rotate(a)
        translate([bottom_r - ARC_THICKNESS / 2,0, -WALL/2])
        cylinder(WALL + 2 * EPS, r1=SCREW/2, r2=SCREW, center=true);
}