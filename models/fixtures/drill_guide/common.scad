include <../../globals.scad>;

module block(
    size,
    left_fence=false,
    top_fence=false,
    right_fence=false,
    bottom_fence=false,
    annotation,
    fence_height=5,
    height=10
    )
{
    assert(len(size) == 2);

    module engrave() {
        text_width = min(min(size[X],size[Y]) - 2*WALL_XS, 0.5 * height * len(annotation));

        resize([text_width,0,0], auto=[true,false,true])
        v_engrave(annotation, size=0.7*height);  
    }
    
    fx = size[X] + (left_fence? WALL : 0) + (right_fence? WALL : 0);
    fy = size[Y] + (top_fence? WALL : 0) + (bottom_fence? WALL : 0);
    fz = height + fence_height;

    difference() {
        union() {
            cube([size[X], size[Y], height], center=true);

            if(top_fence) {
                translate([-size[X]/2 - (left_fence? WALL : 0), size[Y]/2, -height/2])
                cube([fx, WALL, fz]);
            }

            if(bottom_fence) {
                rotate(180)
                translate([-size[X]/2 - (right_fence? WALL : 0), size[Y]/2, -height/2])
                cube([fx, WALL, fz]);
            }

            if(right_fence) {
                translate([size[X]/2, -size[Y]/2, -height/2])
                cube([WALL, size[Y], fz]);
            }

            if(left_fence) {
                rotate(180)
                translate([size[X]/2, -size[Y]/2, -height/2])
                cube([WALL, size[Y], fz]);
            }
        }
        
        //center alignment notches in fence
        translate([0,0, height/2 + fence_height]) {
            rotate([0,45])
            cube([sqrt(2) * fence_height, size[Y] + 2*(WALL + EPS) ,sqrt(2) * fence_height], center=true);

            rotate([45,0])
            cube([size[X] + 2*(WALL + EPS), sqrt(2) * fence_height,sqrt(2) * fence_height], center=true);
        }
        
        if(annotation) {
            translate([0, -size[Y]/2 - (bottom_fence? WALL : 0), 0])
            engrave();
            
            rotate(180)
            translate([0, -size[Y]/2 - (top_fence? WALL : 0), 0])
            engrave();

            rotate(90)
            translate([0, -size[X]/2 - (right_fence? WALL : 0), 0])
            engrave();

            rotate(-90)
            translate([0, -size[X]/2 - (left_fence? WALL : 0), 0])
            engrave();
        }   
    }
}

block([45,45]);