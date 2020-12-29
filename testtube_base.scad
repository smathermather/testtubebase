//num_tubes=12;

/*
scale([25/15,25/15,25/15]){
    import("JPTestTubeHolderBase_V2.stl", convexity=10);
}
*/

module tubes(tube_size, height, num_tubes, internal_offset, external_offset) {
    rotate_angle=360/num_tubes;
    for (tube = [1 : num_tubes]){
        if(tube%2==0) {
            rotate([0,0,tube*rotate_angle]){
                translate([0,internal_offset,0]){
                    {cylinder(r=tube_size/2*1.05, h=height, $fn=50);}
                    //{cylinder(r=tube_size/2*1.05, h=height);}
                }
            }
        }
        else if(tube%2==1) {
            rotate([0,0,tube*rotate_angle]){
                translate([0,external_offset / 1.5,0]){
                    {cylinder(r=tube_size/2*1.05, h=height, $fn=50);}
                }
            }        
        }

    }
}

tube_size=25;
tube_height=34;
num_tubes=12;
internal_offset=30;
external_offset=75;
smooothness=5;
//tubes(tube_size, tube_height, num_tubes, internal_offset, external_offset);

module layermaker(tube_size, tube_height, num_tubes, smooothness) {
    difference(){
        minkowski(){
            hull(){
                    tubes(
                        tube_size * 1.1
                        ,10
                        ,num_tubes
                        ,internal_offset
                        ,external_offset
                );
            }
            sphere(smooothness, $fn=50);
        }

        tubes(
            tube_size
            ,tube_height + 6
            ,num_tubes
            ,internal_offset
            ,external_offset
        );
    }
}

layermaker(tube_size, tube_height, num_tubes);
cylinder(r=12/2, 140, $fn=50);
cylinder(r=15/2, 130, $fn=50);