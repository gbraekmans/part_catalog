include <../../globals.scad>;
use <../../dim.scad>;
    use <common.scad>;

//L: Length
LENGTH = 45;

//W: Width
WIDTH = 45;

//B: Bore size
BORE_SIZE = 8;

LEFT_FENCE = false;

TOP_FENCE = false;

RIGHT_FENCE = false;

BOTTOM_FENCE = false;

module center_guide(
    size,
    bore_size,
    left_fence=false,
    top_fence=false,
    right_fence=false,
    bottom_fence=false,
    height=10,
    fence_height=5
)
{
    alignment_space = (min(size) - bore_size) / 2;
    alignment_size = 0.9 * (alignment_space - 2*WALL) / sqrt(2);
    
    ann = str(size.x, "×", size.y, " ⌀", bore_size);
    
    difference() {
        block(size,
              left_fence=left_fence,
              top_fence=top_fence,
              right_fence=right_fence,
              bottom_fence=bottom_fence,
              annotation=ann);
        
        // bore
        cylinder(height + 2*EPS, r=bore_size/2, center=true);

        // alignment holes    
        if(alignment_size > 0) {
            translate([(bore_size + alignment_space) / 2, 0, 0])
            rotate([0,0,45])
            cube([alignment_size, alignment_size, height+2*EPS], center=true);
            
            translate([-(bore_size + alignment_space) / 2, 0, 0])
            rotate([0,0,45])
            cube([alignment_size, alignment_size, height+2*EPS], center=true);
            
            translate([0, (bore_size + alignment_space) / 2, 0])
            rotate([0,0,45])
            cube([alignment_size, alignment_size, height+2*EPS], center=true);
            
            translate([0, -(bore_size + alignment_space) / 2, 0])
            rotate([0,0,45])
            cube([alignment_size, alignment_size, height+2*EPS], center=true);
        }

    }

    // Documentation
    translate([0, 0,height/2])
    dim_xy_diameter(bore_size, "B");
    
    translate([0,-size[Y]/2,-height/2])
    dim_x(size[X], "L", bottom_fence? WALL: 0);

    translate([size[X]/2, 0,-height/2])
    dim_y(size[Y], "W", right_fence? WALL: 0);

}

center_guide([LENGTH, WIDTH], BORE_SIZE, LEFT_FENCE, TOP_FENCE, RIGHT_FENCE, BOTTOM_FENCE);