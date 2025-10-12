//Import MachineBlocks block() module
use <../../lib/block.scad>;

//Generate 6x6 Plate with text between knobs
machineblock(
    size = [6, 6,1],
    svg="../examples/merch/images/mb.svg",
    svgDimensions = [158.940, 158.940],
    svgScale=0.2,
    svgSide=5,
    svgDepth=0.6,
    studs = [true, [1,1,4,4, true]]
);