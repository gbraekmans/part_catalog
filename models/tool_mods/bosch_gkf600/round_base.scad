include <common.scad>;

module round_base(chamfer=0) {
    
    r = 130/2;
    
    difference() {
        translate([0,0, -GKF600_BASE_DIMENSIONS[Z]/2]) gkf600_at_spindle() {
            translate([0,0,chamfer])
            cylinder(GKF600_BASE_DIMENSIONS[Z] - chamfer, r=r);
            
            cylinder(chamfer, r1=r-chamfer, r2=r);
        }
        
        gkf600_cutouts();
    }
}

round_base(2);