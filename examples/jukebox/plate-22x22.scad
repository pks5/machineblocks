include <../../lib/block.scad>;

knobType = "CLASSIC";

block(
    baseLayers=1,
    grid=[1,20],
    wallGapsY=[[0,0], [19,0]],
    brickOffset=[9.5,0,0],
    knobType = knobType,
    knobs = false
);


block(
    baseLayers=1,
    grid=[20,1],
    wallGapsX=[[0,0], [19,0]],
    brickOffset=[0,9.5,0],
    knobType = knobType,
    knobs = false
);



block(
    baseLayers=1,
    grid=[1,20],
    wallGapsY=[[0,1], [19,1]],
    brickOffset=[-9.5,0,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[20,1],
    wallGapsX=[[0,1], [19,1]],
    brickOffset=[0,-9.5,0],
    knobType = knobType,
    knobs = false
);


block(
    sideAdjustment=0.1,
    baseLayers=1,
    grid=[18,18],
    baseCutoutType = "NONE",
    knobs = [[1,0,4,1], [1,6,4,7], [1,12,4,13], [7,0,10,1], [7,6,10,7], [7,12,10,13], [13,0,16,1], [13,6,16,7], [13,12,16,13] ],
    knobType = knobType,
    previewQuality = 0.4,
    holesZ = [[2,3,2,3], [2,9,2,9], [2,15,2,15], [8,3,8,3], [8,9,8,9], [8,15,8,15], [14,3,14,3], [14,9,14,9], [14,15,14,15]],
    holeZSize=25
);