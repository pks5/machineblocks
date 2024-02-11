include <../../lib/block.scad>;

knobType = "NONE";

block(
    baseLayers=1,
    grid=[16,1],
    wallGapsX=[[0,0], [15,0]],
    brickOffset=[0,7.5,0],
    knobType = knobType
);

block(
    baseLayers=1,
    grid=[1,16],
    wallGapsY=[[0,0], [15,0]],
    brickOffset=[7.5,0,0],
    knobType = knobType
);

block(
    baseLayers=1,
    grid=[1,16],
    wallGapsY=[[0,1], [15,1]],
    brickOffset=[-7.5,0,0],
    knobType = knobType
);

block(
    baseLayers=1,
    grid=[16,1],
    wallGapsX=[[0,1], [15,1]],
    brickOffset=[0,-7.5,0],
    knobType = knobType
);

block(
    baseLayers=1,
    grid=[6,14],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    brickOffset=[-4,0,0]
);

block(
    baseLayers=1,
    grid=[6,14],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    brickOffset=[4,0,0]
);

block(
    baseLayers=1,
    grid=[2,11],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    brickOffset=[0,-1.5,0]
);

block(
    baseLayers=1,
    grid=[2,3],
    sideAdjustment=0.2,
    knobType = knobType,
    brickOffset=[0,5.5,0]
);