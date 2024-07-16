include <../../lib/block.scad>;

knobType = "CLASSIC";

block(
    baseLayers=1,
    grid=[16,1],
    wallGapsX=[[0,0], [15,0]],
    brickOffset=[0,7.5,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[1,16],
    wallGapsY=[[0,0], [15,0]],
    brickOffset=[7.5,0,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[1,16],
    wallGapsY=[[0,1], [15,1]],
    brickOffset=[-7.5,0,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[16,1],
    wallGapsX=[[0,1], [15,1]],
    brickOffset=[0,-7.5,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[14,14],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false
);