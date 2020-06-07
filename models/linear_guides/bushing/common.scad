include <../../globals.scad>

// The drawing of bushing bore
module bushing_bore_sketch(
    inner_radius,
    pin_height=0,
    pin_count=12,
    pin_bore_coverage=0.5
) {    
    assert(pin_bore_coverage >= 0);
    assert(pin_bore_coverage <= 1);
    assert(pin_height >= 0);
    assert(pin_count >= 3);
    assert(pin_bore_coverage * 2 * PI * inner_radius / pin_count >= EXTRUSION_WIDTH, "Pins too small to print");

    
    pin_width =  (1 - pin_bore_coverage) * 2 * PI * inner_radius / pin_count;
    pin_length = inner_radius + pin_height;
       
    // create the rod
    circle(r=inner_radius);
    
    if(pin_height > 0) {
        // create the pins
        intersection() {
            // pins
            for(a=[0:360/pin_count:360])
                rotate(a)
                    translate([0,-pin_width/2])
                        square([pin_length, pin_width]);
            // round over pin ends
            circle(pin_length);
        }
    }
}

// The bore as a volume
module bushing_bore(
    inner_radius,
    height,
    chamfer,
    pin_height=0,
    pin_count=12,
    pin_bore_coverage=0.5,
) {
    chamfer = default(chamfer, default(pin_height, 0));

    // Bore body
    linear_extrude(height, center=true)
        bushing_bore_sketch(
            inner_radius=inner_radius,
            pin_height=pin_height,
            pin_count=pin_count,
            pin_bore_coverage=pin_bore_coverage
        );
    
    if(chamfer > 0) {
        // Lower chamfer
        translate([0,0, - height / 2])
        cylinder(chamfer, r1=inner_radius + chamfer, r2=inner_radius);
        
        // Upper chamfer
        rotate([180,0,0])
        translate([0,0, - height / 2])
        cylinder(chamfer, r1=inner_radius + chamfer, r2=inner_radius);
    }
}

// The body of flanged bushing
module bushing_flanged_body(
    radius,
    height,
    flange_radius,
    flange_height,
    flange_chamfer)
{
        translate([0,0,-height/2])
        rotate_extrude()
        offset(delta=-flange_chamfer, chamfer=true)
        offset(delta=flange_chamfer) {
            square([radius, height]);
            square([flange_radius, flange_height]);
        }  
}