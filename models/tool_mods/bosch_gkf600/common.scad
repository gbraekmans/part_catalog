include <../../globals.scad>;

GKF600_BASE_DIMENSIONS = [96, 88, 6.5];

module gkf600_at_spindle() {
        translate([0,3,0]) children();
}

module gkf600_at_screws() {
    delta_x = 76/2;
    delta_y = 68/2;
    
    translate([ delta_x,  delta_y]) children();
    translate([ delta_x, -delta_y]) children();
    translate([-delta_x,  delta_y]) children();
    translate([-delta_x, -delta_y]) children();
}

module gkf600_cutouts() {
    gkf600_at_spindle() {
        cylinder(GKF600_BASE_DIMENSIONS[Z]+2*EPS, r=40/2, center=true);
        
        translate([0,0,GKF600_BASE_DIMENSIONS[Z]/2 - 2])
        cylinder(2+EPS, r=52/2);
    }
    
    gkf600_at_screws() {
        cylinder(GKF600_BASE_DIMENSIONS[Z]+2*EPS, r=5.25/2, center=true);
        
        translate([0,0,-GKF600_BASE_DIMENSIONS[Z]/2 - EPS])
        cylinder(3.5 + EPS, r=5);
    }
}

module gkf600_generic_base(chamfer=2) {
    difference() {
        
            translate([0,0, -GKF600_BASE_DIMENSIONS[Z] / 2]) hull() {
            translate([0,0, chamfer])
            linear_extrude(GKF600_BASE_DIMENSIONS[Z] - chamfer)
            offset(r=chamfer) offset(delta=-chamfer)
            square([GKF600_BASE_DIMENSIONS[X], GKF600_BASE_DIMENSIONS[Y]], center=true);
            
            linear_extrude(chamfer)
            square([GKF600_BASE_DIMENSIONS[X] - chamfer,
                    GKF600_BASE_DIMENSIONS[Y] - chamfer], center=true);
        }
        
        gkf600_cutouts();
   }
}