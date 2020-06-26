include <../../globals.scad>;
include <../../dim.scad>;

//D: Diameter of the guide
DIAMETER = 25;

//L: Length of the holder
LENGTH = 25;

//H: Height of the holder to the center of the guide
HEIGHT_TO_CENTER = 29.5;

module guide_holder(guide_diameter, length, height_to_center) {
    
    r = guide_diameter/2 + WALL;
    
    hc = is_undef(height_to_center)? r + WALL/2 : height_to_center;

    module sketch() {
        hull() {
            circle(r=r);
            
            translate([0, -hc + WALL/2])
            square([r*2, WALL], center=true);
        }
        
        translate([0, -hc + WALL/2])
        square([r*2 + WALL * 4 + SCREW * 4, WALL], center=true);       
    }
    
    rotate([0,0,0])
    difference() {
        linear_extrude(length, center=true)
        offset(r=-WALL)
        offset(delta=WALL)
        sketch();
        
        translate([0,0, WALL])
        cylinder(length, r=guide_diameter/2, center=true);
        
        dx = r + WALL + SCREW;
        dz = length/2 - WALL - SCREW;
        
        for(i=[1,-1])
            for(j=[1,-1])
                translate([i*dx, -hc + WALL/2, j*dz])
                rotate([-90,0,0])
                screw(WALL + 4*EPS);
    }
    
    translate([0,0,length/2]) {
        dim_xy_diameter(guide_diameter, "D");
        
        translate([0,-hc/2])
        dim_y(hc, "H");
        
        translate([0, -hc, -WALL - SCREW])
        dim_x(2*r + 2 * WALL + 2*SCREW);
        
        translate([0, -hc])
        dim_x(2*r + 4 * WALL + 4*SCREW);
    }
    
    translate([-r-WALL-SCREW,-hc])
    dim_z(length - 2 * WALL - 2*SCREW);

    translate([-r-2*(WALL+SCREW),-hc])
    dim_z(length, "L");
    
}

guide_holder(DIAMETER, LENGTH, HEIGHT_TO_CENTER);