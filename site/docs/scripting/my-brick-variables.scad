use <../../../lib/block.scad>;
include <../../../config/config.scad>;

// Size of the brick in the X direction, expressed as a multiple of a 1×1 brick
sizeX = 7; // [1:32]
// Size of the brick in the Y direction, expressed as a multiple of a 1×1 brick
sizeY = 2; // [1:32]
// Height of the brick, given as the number of plates
height = 3; // [1:32]
// Type of the studs
studType = "hollow"; // [solid, hollow]
// Whether the brick should have pin holes in X-direction
holeX = true;

machineblock(
    size = [sizeX, sizeY, height],
    studType = studType,
    holeX = holeX
);