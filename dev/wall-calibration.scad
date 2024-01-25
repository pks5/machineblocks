echo(version=version());

include <../lib/block.scad>;

color("yellow")
    translate([-20, -20, 0])
        block(baseLayers=3, grid=[4,2]);


translate([20, 0, 0])
    block(baseLayers=3, grid=[1,1], knobType="NONE");

/*    
translate([-20, 0, 0])
    block(baseLayers=3, grid=[2,1], knobType="NONE");
*/

//brickHollow(height=9.57, minSize=[4.6,4.6], maxSize=[5.2,5.2], center=true);