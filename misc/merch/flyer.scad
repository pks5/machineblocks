//Import MachineBlocks block() module
use <../../lib/block.scad>;

//Generate 6x6 Plate with text between knobs
block(
    baseLayers = 1,
    grid = [16, 9],
    brickOffset = [7, 0, 0],
    withSvg=true,
    svgFile="../misc/merch/images/mb.svg",
    svgDimensions = [158.940, 158.940],
    svgScale=0.2,
    svgSide=5,
    svgDepth=0.6,
    svgOffset=[40,12],
    knobGaps = [[1,1,14,2], [11,4,14,7]],
    knobSize = 5.0, //Reduce this value if the knobs do not fit into a LEGO brick or only with great difficulty
    sideAdjustment = -0.1,
    heightAdjustment = 0.0 //Reduce this value if the base of the brick is too high
);