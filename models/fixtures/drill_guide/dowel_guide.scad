include <../../globals.scad>;
use <../../dim.scad>;
use <common.scad>;

//L: Length
LENGTH = 45;

//W: Width
WIDTH = 45;

//Amount of dowels along length
DOWEL_COUNT_X = 2;

//Amount of dowels along width
DOWEL_COUNT_Y = 1;

//D: Dowel size
DOWEL_SIZE = 8;

LEFT_FENCE = false;

TOP_FENCE = true;

RIGHT_FENCE = false;

BOTTOM_FENCE = false;

module dowel_guide(
    size,
    bore_size,
    dowels,
    left_fence=false,
    top_fence=false,
    right_fence=false,
    bottom_fence=false,
    height=10,
    fence_height=5
) {
    dowel_x_step = size.x / dowels.x;
    dowel_x_delta = -size.x / 2 + dowel_x_step / 2;


    dowel_y_step = size.y / dowels.y;
    dowel_y_delta = -size.y / 2 + dowel_y_step / 2;

    ann = str(size.x, "×", size.y, " ⌀", bore_size);

    assert(dowel_x_step - bore_size >= WALL);
    assert(dowel_y_step - bore_size >= WALL);

    difference() {
        block([size[X], size[Y]],
              left_fence=left_fence,
              top_fence=top_fence,
              right_fence=right_fence,
              bottom_fence=bottom_fence,
              annotation=ann);
        
        //Cut the holes
        for(xi=[0:dowels[X]-1])
            for(yi=[0:dowels[Y]-1])
                translate([dowel_x_delta + dowel_x_step * xi,
                           dowel_y_delta + dowel_y_step * yi,
                           0])
                cylinder(height + 2*EPS, r=bore_size/2, center=true);
    }
    
    // Documentation
    translate([dowel_x_delta, dowel_y_delta,height/2]) {
        dim_xy_diameter(bore_size, "D", theta=45);
        
        if(dowels[X] > 1)
            translate([dowel_x_step/2,0]) dim_x(dowel_x_step, leader=bore_size/2);
        
        if(dowels[Y] > 1)
            translate([0,dowel_y_step/2,0]) dim_y(dowel_y_step, leader=-dim_text_line(2)-bore_size/2);
    }
    
    translate([0,-size[Y]/2,-height/2])
    dim_x(size[X], "L", bottom_fence? WALL: 0);

    translate([size[X]/2, 0,-height/2])
    dim_y(size[Y], "W", right_fence? WALL: 0);
}

dowel_guide([LENGTH,WIDTH], DOWEL_SIZE, [DOWEL_COUNT_X,DOWEL_COUNT_Y],
             LEFT_FENCE, TOP_FENCE, RIGHT_FENCE, BOTTOM_FENCE);