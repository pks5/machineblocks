/**
* MachineBlocks Brick 4x2 with text or symbols
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*/

//Include the MachineBlocks library
include <../../lib/block.scad>;

/*
block(
    grid=[16,2], 
    knobs=false,
    withText=true, 
    textSize=12, 
    textSide=5,
    sideAdjustment=[0,0,0,0],
    text="martian", 
    textFont="Space Age", 
    textDepth=0.8, 
    textSpacing=1.1,
    textOffset=[10,-0.6],

    withSvg = true,
    svgFile = "../../martian/martian-logo.svg",
    svgDimensions = [640, 640],
    svgSide = 5,
    svgScale = 0.02,
    svgOffset = [-50, 0],
    svgDepth = 0.8
);
*/

translate([0, 20, 0])
block(
    grid=[8,1], 
    knobs=false,
    baseCutoutType="NONE",
    withText=true, 
    textSize=6, 
    textSide=5,
    sideAdjustment=[0,0,0,0],
    text="martian", 
    textFont="Space Age", 
    textDepth=0.8, 
    textSpacing=1.1,
    textOffset=[5,-0.3],

    withSvg = true,
    svgFile = "../../martian/martian-logo.svg",
    svgDimensions = [640, 640],
    svgSide = 5,
    svgScale = 0.01,
    svgOffset = [-25, 0],
    svgDepth = 0.8
);
