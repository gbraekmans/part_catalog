include <../../globals.scad>;

module line(l) {
    assert(l >= EXTRUSION_WIDTH);
    
    distance = l - EXTRUSION_WIDTH;
    r = EXTRUSION_WIDTH / 2;
    hull() {
        translate([-distance/2, 0]) circle(r=r);
        translate([distance/2, 0]) circle(r=r);
    }
}

module make_face_plate(height, chamfer_pct=0.5) {
    
    assert(! is_undef(height));
    
    unchamfered_height = height * (1 - chamfer_pct);
    chamfered_height = height * chamfer_pct;
    
    minkowski() {
        linear_extrude(unchamfered_height)
        offset(delta=-chamfered_height) children(0);
        
        cylinder(chamfered_height, r2=chamfered_height, r1=0);
    }
}

// Requires a 2d sketch of the shape outline
// A second shape with supports may be given
module make_anchors(height, n) {
    
    anchor_height = nearest_layer_height(1.5);
    
    module anchor() {
        hull() {
            linear_extrude(LAYER_HEIGHT)
            children(0);
            
            linear_extrude(anchor_height)
            offset(delta=-anchor_height)
            children(0);
        }
    }
    
    assert(! is_undef(height));
    assert($children <= 2);
    assert($children >= 1);
    
    n = default(n, round(height/5));

    difference() {
        union() {
            // the anchors
            step = height / n;
            for(i=[1:n]) {
                translate([0,0,i * step - anchor_height])
                anchor() children(0);
            }
            
            // the base
            linear_extrude(height)
            offset(delta=-anchor_height)
            children(0);
            
            // anchor supports
            if($children == 2) {
                // the base
                linear_extrude(height - anchor_height)
                children(1);
            }
        }
        // the base cutout
        translate([0,0,-EPS])
        linear_extrude(height + 2 * EPS)
        offset(delta=-anchor_height-WALL_XS)
        children(0);
    }
}