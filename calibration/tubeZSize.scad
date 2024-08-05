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
    text="tubeZSize",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

rotate([180,0,0])
block(
    grid=[2,2],
    tubeZSize = 6.2,
    gridOffset=[-4,0,-2],
    knobs=false,
    baseSideAdjustment=-4,
    stabilizerGrid=false,
    topPlateHelpers=false
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[-4,-1,0],
    baseSideAdjustment = 0,
    text = "6.2",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

rotate([180,0,0])
block(
    grid=[2,2],
    tubeZSize = 6.3,
    gridOffset=[-2,0,-2],
    knobs=false,
    baseSideAdjustment=-4,
    stabilizerGrid=false,
    topPlateHelpers=false
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[-2,-1,0],
    baseSideAdjustment = 0,
    text = "6.3",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

rotate([180,0,0])
block(
    grid=[2,2],
    tubeZSize = 6.4,
    gridOffset=[0,0,-2],
    knobs=false,
    baseSideAdjustment=-4,
    stabilizerGrid=false,
    topPlateHelpers=false
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[0,-1,0],
    baseSideAdjustment = 0,
    text = "6.4",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

rotate([180,0,0])
block(
    grid=[2,2],
    tubeZSize = 6.5,
    gridOffset=[2,0,-2],
    knobs=false,
    baseSideAdjustment=-4,
    stabilizerGrid=false,
    topPlateHelpers=false
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[2,-1,0],
    baseSideAdjustment = 0,
    text = "6.5",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);

rotate([180,0,0])
block(
    grid=[2,2],
    tubeZSize = 6.6,
    gridOffset=[4,0,-2],
    knobs=false,
    baseSideAdjustment=-4,
    stabilizerGrid=false,
    topPlateHelpers=false
);

block(
    grid = [1, 1],
    baseCutoutType = "none",
    knobs = false,
    gridOffset=[4,-1,0],
    baseSideAdjustment = 0,
    text = "6.6",
    textFont = "Arial Black",
    textSize=3,
    textSide=5,
    textDepth=0.6
);