//Import MachineBlocks block() module
use <../../lib/block.scad>;

//Generate 6x6 Plate with text between knobs
block(
    baseLayers = 1,
    grid = [16, 9],
    gridOffset = [7, 0, 0],
    svg="../sets/merch/images/mb.svg",
    svgDimensions = [158.940, 158.940],
    svgScale=0.2,
    svgSide=5,
    svgDepth=0.4,
    svgOffset=[5,1.5],
    textFont="RBNo3.1 Bold",
    text="MachineBlocks.com",
    textSide=5,
    textDepth=0.4,
    textSize=7,
    textOffset=[0, -3],
    knobs = [true, [2,1,13,1, true], [11,4,14,7, true]],
    baseRoundingRadius=[0,0,4],
    baseCutoutRoundingRadius=2.6,
    knobSize = 5.0, //Reduce this value if the knobs do not fit into a LEGO brick or only with great difficulty
    baseSideAdjustment = -0.1,
    baseHeightAdjustment = 0.0 //Reduce this value if the base of the brick is too high
);