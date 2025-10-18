//Include the MachineBlocks library
use <../../lib/block.scad>;
include <../../config/config.scad>;

/* [Appearance] */

//Grid Size X-direction
gridX = 6; 
//Grid Size Y-direction
gridY = 6; 
//Number of layers
baseLayers = 1;
//Draw Knobs
studs = [true, [1, 1, gridX - 2, gridY - 2, true]];
// Log Height
logHeight = 30;
// Log Radius
logRadius = 8;
// Tree Radius
treeRadius = 32;

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

translate([0, 0, baseLayers * gridSizeZ + 0.5 * logHeight])
    cylinder(r = logRadius, h = logHeight, center = true, $fn = $preview ? 32 : 64);

translate([0, 0, baseLayers * gridSizeZ + logHeight + 0.95*treeRadius])
    sphere(r = treeRadius, $fn = $preview ? 32 : 64);