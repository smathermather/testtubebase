// Test tube size
tube_size=25;
tube_height=34;

// Number of tubes. Internal and external offsets may need adjusted
num_tubes=12;
internal_offset=30;
external_offset=75;
smooothness=20;

// Generates tube holes
module tubes(tube_size, height, num_tubes, internal_offset, external_offset) {
    rotate_angle=360/num_tubes;
    for (tube = [1 : num_tubes]){
        if(tube%2==0) {
            rotate([0,0,tube*rotate_angle]){
                translate([0,internal_offset,0]){
                    {cylinder(r=tube_size/2*1.01, h=height, $fn=50);}
                    //{cylinder(r=tube_size/2*1.01, h=height);}
                }
            }
        }
        else if(tube%2==1) {
            rotate([0,0,tube*rotate_angle]){
                translate([0,external_offset / 1.5,0]){
                    {cylinder(r=tube_size/2*1.01, h=height, $fn=50);}
                }
            }        
        }

    }
}

// Creates the holder array by doing the following:
// Takes tube locations, creates a convex hull of them,
// buffers them a bit with a Minkowski function, and then
// smoothes the whole result with another Minkowski function
module layermaker(tube_size, tube_height, num_tubes, tube_offset) {
    difference(){
        minkowski(){
            hull(){
                    tubes(
                        tube_size * 1.1
                        ,5
                        ,num_tubes
                        ,internal_offset
                        ,external_offset
                );
            }
            sphere(2, $fn=50);
        }

        translate([0,0,tube_offset]){
            tubes(
                tube_size
                ,tube_height + 6
                ,num_tubes
                ,internal_offset
                ,external_offset
            );
        }
    }
}

// Create base
layermaker(tube_size, tube_height, num_tubes, 0);
cylinder(r=12/2, 140, $fn=50);
cylinder(r=15/2, 130, $fn=50);

// Create upper
difference(){
    translate([0,0,130]){
        layermaker(tube_size, 50, num_tubes, -30);
    }
    cylinder(r=12/2, 142, $fn=50);
}
