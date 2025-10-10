//Import MachineBlocks block() module
use <../../lib/block.scad>;

//Generate 6x6 Plate with text between knobs
machineblock(
    size = [16, 9, 1],
    
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
    studs = [true, [2,1,13,1, true], [11,4,14,7, true]],
    baseRoundingRadius=[0,0,4],
    baseCutoutRoundingRadius=2.6
);