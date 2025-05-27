echo(version=version());

include <../lib/block.scad>;

/* [Hidden] */

grid = [1, 1];
gridSizeXY = 8.0;
gridSizeZ = 3.2;
offsetX = 0.5 * (grid[0] - 1);
holeXGridOffsetZ = 1.75;
holeXGridSizeZ = 3;
tubeXSize = 6.4;
holeXSize = 5.1;
wallThickness = 1.5;
pillarRoundingResolution = 64;
objectSizeY = gridSizeXY * grid[1];
holeXInsetDepth = 0.9;
holeRoundingResolution = 64;
holeXInsetThickness = 0.55;

function posX(a) = (a - offsetX) * gridSizeXY;

difference(){
    block(baseLayers=3, baseCutoutMaxDepth=2.4, grid=grid, knobType = "technic", alignBottom=true);
    
    a=0;
    translate([posX(a), 0, holeXGridOffsetZ*gridSizeZ]){
        rotate([90, 0, 0]){ 
            cylinder(h=objectSizeY + 2*wallThickness, r=0.5 * holeXSize, center=true, $fn=pillarRoundingResolution);
            translate([0, 0, 0.5 * objectSizeY])
                                        cylinder(h=2*holeXInsetDepth, r=0.5 * (holeXSize + 2*holeXInsetThickness), center=true, $fn=holeRoundingResolution);
                                    translate([0, 0, -0.5 * objectSizeY])
                                        cylinder(h=2*holeXInsetDepth, r=0.5 * (holeXSize + 2*holeXInsetThickness), center=true, $fn=holeRoundingResolution);
        }
    };
    
}
        