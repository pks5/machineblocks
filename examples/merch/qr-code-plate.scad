//Import MachineBlocks block() module
use <../../lib/block.scad>;

//Generate 6x6 Plate with text between knobs
block(
    baseLayers = 1,
    grid = [6, 6],
    brickOffset = [7, 0, 0],
    withSvg=true,
    svgFile="../examples/merch/images/mb.svg",
    svgDimensions = [158.940, 158.940],
    svgScale=0.2,
    svgSide=5,
    svgDepth=0.6,
    knobs = [true, [1,1,4,4, true]],
    knobSize = 5.0, //Reduce this value if the knobs do not fit into a LEGO brick or only with great difficulty
    sideAdjustment = -0.1,
    heightAdjustment = 0.0 //Reduce this value if the base of the brick is too high
);