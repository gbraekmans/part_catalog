/*
 *  A set of functions to add dimensions to
 *  the preview of renders
 */

include <globals.scad>;

// Assume you want dimensions if you've included
// this file
$dim = true;

LINE_WIDTH = 0.3;
LINE_HEIGHT = EPS;
FONT_SIZE = 2.5;
FONT_LETTER_WIDTH = 2;
COLOR = "black";

DOC = $dim && $preview;

//! Returns the absolute point of a line in text
//! n: the amount of lines
function dim_text_line(n=1) = n * 2 * FONT_SIZE;

//! Returns the distance between two points on a plane
//! p1: vec2, first point
//! p2: vec2, second point
function dim_distance(p1, p2) = sqrt(
                                     pow(p2[0] - p1[0], 2) +
                                     pow(p2[1] - p1[1], 2)
                                    );

//! Draws a line between two points on the XY-plane
//! begin: vec2, first endpoint of the line
//! end: vec2, second endpoint of the line
module dim_line(begin, end) {
    if(DOC) {
        color(COLOR)
        linear_extrude(LINE_HEIGHT)
        hull() {
            translate(begin) circle(r=LINE_WIDTH/2);
            translate(end) circle(r=LINE_WIDTH/2);
        }
    }   
}

//! Draws an arrow
//! begin: vec2, marks the start of the line
//! end: vec2, marks the point with the arrow
module dim_arrow(begin, end) {
    
    assert(dim_distance(begin,end) > 6 * LINE_WIDTH);
    
    theta = atan2(end[1]-begin[1], end[0]-begin[0]);
    
    if(DOC) color(COLOR) {
        // the arrow body
        dim_line(begin,end);
        
        // the arrow head
        linear_extrude(LINE_HEIGHT)
        translate(end)
        rotate(theta - 90)
        hull() {
            circle(r=LINE_WIDTH/2);
            translate([-2 * LINE_WIDTH, -6 * LINE_WIDTH]) circle(r=LINE_WIDTH/2);
            translate([2 * LINE_WIDTH, -6 * LINE_WIDTH]) circle(r=LINE_WIDTH/2);
        }
    }
}

//! Draws text on the XY plane
//! begin: vec2, marks the start of the line
//! end: vec2, marks the point with the arrow
module dim_annotate(txt) {
    if(DOC) color(COLOR) {
        linear_extrude(LINE_HEIGHT)
        text(txt, size=FONT_SIZE, font="DejaVu Sans Mono:style=Book", valign="center", halign="center");
    }
}

//! Draws a dimension on the XY plane along the x-axis
//! the origin is in the center of the dimension
//! length: num, length of the dimension
//! desc: str, optional identifier for the dimension
//! leader: num, distance leaders pass over the axis
module dim_x(length ,desc, leader=0) {    
    assert(length > 0);
    
    height = 2 * FONT_SIZE + leader;
    
    // center everything
    translate([-length/2, 0]) {
    
        // Extension lines from the model
        dim_line([0,0], [0,-height]);
        dim_line([length,0], [length, -height]);
        
        // The string to annotate
        ann = is_undef(desc)? str(length) : str(desc, ": ", length);
        // Width of the string
        ann_width = len(ann) * FONT_LETTER_WIDTH + 1;
        // Width of the smallest arrow
        min_arrow = 8 * LINE_WIDTH;
        
        if(ann_width < length) { // if annotation fits within dimension
            translate([length/2, -height]) dim_annotate(ann); // place annotation in center
            
            if(length - ann_width > 2 * min_arrow) { // if arrows fit inside place them
                dim_arrow([(length + ann_width)/2 , -height], [length, -height]);
                dim_arrow([(length - ann_width)/2 , -height], [0, -height]);
            } else { // if arrows don't fit inside place them outside
                dim_arrow([length + min_arrow , -height], [length, -height]);
                dim_arrow([- min_arrow , -height], [0, -height]);    
            }
        } else { // if the annotation doesn't fit lower it under the dimension
            
            //Place annotation under the dimension
            delta = height > 0? FONT_SIZE : - FONT_SIZE;
            translate([length/2, -height - delta]) dim_annotate(ann);
            
            if(length < 2 * min_arrow) { // if arrows too small place them outside
                dim_arrow([length + min_arrow , -height], [length, -height]);
                dim_arrow([- min_arrow , -height], [0, -height]);  
            } else { // otherwise place them inside
                dim_arrow([0 , -height], [length, -height]);
                dim_arrow([length, -height], [0, -height]);
            }
        }
    }
}

//! Draws a dimension on the XY plane along the y-axis
//! the origin is in the center of the dimension
//! length: num, length of the dimension
//! desc: str, optional identifier for the dimension
//! leader: num, distance leaders pass over the axis
module dim_y(length ,desc, leader=0) {
    rotate(90)
    dim_x(length, desc, leader);
}

//! Draws a dimension on the XZ plane along the z-axis
//! the origin is in the center of the dimension
//! length: num, length of the dimension
//! desc: str, optional identifier for the dimension
//! leader: num, distance leaders pass over the axis
module dim_z(length ,desc, leader=0) {
    rotate([0,90,-90])
    dim_x(length, desc, leader);
}

//! Draws a leader line with a radius identifier on the XY-plane
//! the origin is in the center of the circle to dimension
//! r: num, radius of the circle
//! desc: str, optional identifier for the dimension
//! length: num, length of the leader line
//! theta: num, the angle of the leader line
module dim_xy_radius(r, desc, length=2 * FONT_SIZE, theta=-45) {
    assert(r > 0);
    
    ann = is_undef(desc)? str("R", r) : str(desc, ": R", r);
    ann_width = len(ann) * FONT_LETTER_WIDTH + 1;
    
    translate([cos(theta) * r, sin(theta) * r]) {
        dim_arrow([cos(theta) * length, sin(theta) * length], [0,0]);
        translate([cos(theta) * (length + ann_width/2), sin(theta) * (length + FONT_SIZE)]) dim_annotate(ann);
    }
}

//! Draws a leader line with a radius identifier on the XZ-plane
//! the origin is in the center of the circle to dimension
//! r: num, radius of the circle
//! desc: str, optional identifier for the dimension
//! length: num, length of the leader line
//! theta: num, the angle of the leader line
module dim_xz_radius(r, desc,  length=2 * FONT_SIZE, theta=-45) {
    rotate([90,0,0])
    dim_xy_radius(r, desc, length, theta);
}

//! Draws a leader line with a radius identifier on the YZ-plane
//! the origin is in the center of the circle to dimension
//! r: num, radius of the circle
//! desc: str, optional identifier for the dimension
//! length: num, length of the leader line
//! theta: num, the angle of the leader line
module dim_yz_radius(r, desc,  length=2 * FONT_SIZE, theta=-45) {
    rotate([90,0,90])
    dim_xy_radius(r, desc, length, theta-90);
}

//! Draws a leader line with a diameter identifier on the XY-plane
//! the origin is in the center of the circle to dimension
//! r: num, radius of the circle
//! desc: str, optional identifier for the dimension
//! length: num, length of the leader line
//! theta: num, the angle of the leader line
//! center_mark: bool, if true a center mark is drawn on the circle
//! outline: bool, if true the circumference drawn on the circle
module dim_xy_diameter(d, desc, length=2 * FONT_SIZE, theta=-45, center_mark=true, outline=true) {    
    assert(d > 0);
    
    ann = is_undef(desc)? str("⌀", d) : str(desc, ": ⌀", d);
    ann_width = len(ann) * FONT_LETTER_WIDTH + 1;

    translate([cos(theta) * d/2, sin(theta) * d/2]) {
        dim_arrow([cos(theta) * length, sin(theta) * length], [0,0]);
        translate([cos(theta) * (length + ann_width/2), sin(theta) * (length + FONT_SIZE)]) dim_annotate(ann);
    }
    
    if(center_mark) {
        dim_line([d/6,0], [-d/6, 0]);
        dim_line([0,d/6], [0, -d/6]);
    }

    if(outline && DOC) {
        color(COLOR)
        linear_extrude(LINE_HEIGHT)
        difference() {
            circle(r=d/2 + LINE_WIDTH / 2);
            circle(r=d/2 - LINE_WIDTH / 2);
        }
    }
}

//! Draws a leader line with a diameter identifier on the XZ-plane
//! the origin is in the center of the circle to dimension
//! r: num, radius of the circle
//! desc: str, optional identifier for the dimension
//! pos: num, how many font heights (ems) the leader line should be
//! theta: num, the angle of the leader line
//! center_mark: bool, if there should be a center mark drawn on the circle
module dim_xz_diameter(d, desc, pos=1, theta=-45, center_mark=true) {
    rotate([90,0,0])
    dim_xy_diameter(d, desc, pos, theta, center_mark);
}

//! Draws a leader line with a diameter identifier on the YZ-plane
//! the origin is in the center of the circle to dimension
//! r: num, radius of the circle
//! desc: str, optional identifier for the dimension
//! pos: num, how many font heights (ems) the leader line should be
//! theta: num, the angle of the leader line
//! center_mark: bool, if there should be a center mark drawn on the circle
module dim_yz_diameter(d, desc, pos=1, theta=-45, center_mark=true) {
    rotate([90,0,90])
    dim_xy_diameter(d, desc, pos, theta-90, center_mark);
}