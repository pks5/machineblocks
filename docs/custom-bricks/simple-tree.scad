//Include the MachineBlocks library
use <../../lib/block.scad>;

//Grid Size X-direction
gridX = 6; 
//Grid Size Y-direction
gridY = 6; 
//Length of a 1x1 LEGO brick
gridSizeXY = 8.0;
//Height of a LEGO plate
gridSizeZ = 3.2;
//Number of layers
baseLayers = 1;
//Draw Knobs
knobs = [true, [1, 1, gridX - 2, gridY - 2, true]];

//Adjustment of the height (mm)
baseHeightAdjustment = 0.0;
//Adjustment of each side (mm)
baseSideAdjustment = -0.1;
//Diameter of the knobs (mm)
knobSize = 5.0;
//Thickness of the walls (mm)
wallThickness = 1.5;
//Diameter of the Z-Tubes (mm)
tubeZSize = 6.4;

logHeight = 30;
logRadius = 8;
treeRadius = 32;

block(
    grid = [gridX, gridY],
    gridSizeXY = gridSizeXY,
    gridSizeZ = gridSizeZ,
    baseLayers = baseLayers,
    knobs = knobs,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize
);

translate([0, 0, baseLayers * gridSizeZ + 0.5 * logHeight])
    cylinder(r = logRadius, h = logHeight, center = true, $fn = $preview ? 32 : 64);

translate([0, 0, baseLayers * gridSizeZ + logHeight + 0.95*treeRadius])
    sphere(r = treeRadius, $fn = $preview ? 32 : 64);