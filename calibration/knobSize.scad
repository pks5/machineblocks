echo(version=version());

include <../lib/block.scad>;



block(
    grid = [9, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[0,0,0],
    baseSideAdjustment = 0
);

block(
    grid = [3, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[0,1,0],
    baseSideAdjustment = 0,
    text="knobSize",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    baseCutoutType = "none",
    knobSize = 4.8,
    gridOffset=[-4,0,1]
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[-4,-1,0],
    baseSideAdjustment = 0,
    text = "4.8",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    baseCutoutType = "none",
    knobSize = 4.9,
    gridOffset=[-2,0,1]
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[-2,-1,0],
    baseSideAdjustment = 0,
    text = "4.9",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    baseCutoutType = "none",
    knobSize = 5.0,
    gridOffset=[0,0,1]
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[0,-1,0],
    baseSideAdjustment = 0,
    text = "5.0",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    baseCutoutType = "none",
    knobSize = 5.1,
    gridOffset=[2,0,1]
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[2,-1,0],
    baseSideAdjustment = 0,
    text = "5.1",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    baseCutoutType = "none",
    knobSize = 5.2,
    gridOffset=[4,0,1]
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[4,-1,0],
    baseSideAdjustment = 0,
    text = "5.2",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);