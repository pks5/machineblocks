//Include the MachineBlocks library
use <../../lib/block.scad>;
include <../../config/config.scad>;

/* [Appearance] */

//Grid Size X-direction
gridX = 8; 
//Grid Size Y-direction
gridY = 2; 
//Number of layers
baseLayers = 1;
//Draw Knobs
studs = false;
//Log Height
logHeight = 48;
//Log Radius
logRadius = 4;

/* [Hidden] */

//Length of a 1x1 LEGO brick
gridSizeXY = unitGrid[0] * unitMbu;
//Height of a LEGO plate
gridSizeZ = unitGrid[1] * unitMbu;

machineblock(
    size = [gridX, gridY, baseLayers],
    studs = studs,
    align = "ccs"
);

translate([3.5 * gridSizeXY, 0, baseLayers * gridSizeZ + 0.5 * logHeight])
    cylinder(r = logRadius, h = logHeight, center = true, $fn = $preview ? 32 : 64);

translate([-3.5 * gridSizeXY, 0, baseLayers * gridSizeZ + 0.5 * logHeight])
    cylinder(r = logRadius, h = logHeight, center = true, $fn = $preview ? 32 : 64);


translate([0, 0, baseLayers * gridSizeZ + logHeight - 0.5 * gridY * gridSizeXY])
    rotate([90, 0, 0])
        machineblock(
            size = [gridX, gridY, baseLayers],
            studs = studs,
            baseCutoutType = "none",
            align = "center",
            text = "Welcome",
            textSide = 5,
            textSize = 8,
            textDepth = 1
        );