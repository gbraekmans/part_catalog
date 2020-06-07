include <common.scad>;

module gkf600_base(chamfer=0){
    
    difference() {
        gkf600_generic_base(chamfer);
        
        translate([0, GKF600_BASE_DIMENSIONS[Y]/2 - 2])
        cube([31, 4 + EPS, GKF600_BASE_DIMENSIONS[Z]+2*EPS], center=true);
    }
}

gkf600_base(2);