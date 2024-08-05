echo(version=version());

include <../lib/block.scad>;

textFont = "RBNo3.1 Black";

block(
    grid = [9, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[0,0,0],
    baseSideAdjustment = [0,0,0.2,0],
    text="wallThickness",
    textFont = textFont,
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    grid = [1, 1],
    knobs = false,
    gridOffset=[-4,-1,0],
    text = "1.3",
    wallThickness=1.3,
    textFont = textFont,
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    grid = [1, 1],
    knobs = false,
    gridOffset=[-2,-1,0],
    text = "1.4",
    wallThickness=1.4,
    textFont = textFont,
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    grid = [1, 1],
    knobs = false,
    gridOffset=[0,-1,0],
    text = "1.5",
    wallThickness=1.5,
    textFont = textFont,
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    grid = [1, 1],
    knobs = false,
    gridOffset=[2,-1,0],
    text = "1.6",
    wallThickness=1.6,
    textFont = textFont,
    textSize=3,
    textSide=5,
    textDepth=0.6
);

block(
    grid = [1, 1],
    knobs = false,
    gridOffset=[4,-1,0],
    text = "1.7",
    wallThickness=1.7,
    textFont = textFont,
    textSize=3,
    textSide=5,
    textDepth=0.6
);