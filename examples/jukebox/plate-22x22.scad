include <../../lib/block.scad>;

knobType = "CLASSIC";

block(
    baseLayers=1,
    grid=[1,20],
    wallGapsY=[[0,0], [19,0]],
    gridOffset=[9.5,0,0],
    knobType = knobType,
    knobs = false
);


block(
    baseLayers=1,
    grid=[20,1],
    wallGapsX=[[0,0], [19,0]],
    gridOffset=[0,9.5,0],
    knobType = knobType,
    knobs = false
);



block(
    baseLayers=1,
    grid=[1,20],
    wallGapsY=[[0,1], [19,1]],
    gridOffset=[-9.5,0,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[20,1],
    wallGapsX=[[0,1], [19,1]],
    gridOffset=[0,-9.5,0],
    knobType = knobType,
    knobs = false
);


block(
    baseSideAdjustment=0.1,
    baseLayers=1,
    grid=[18,18],
    baseCutoutType = "NONE",
    knobs = [[1,0,4,1], [1,6,4,7], [1,12,4,13], [7,0,10,1], [7,6,10,7], [7,12,10,13], [13,0,16,1], [13,6,16,7], [13,12,16,13] ],
    knobType = knobType,
    previewQuality = 0.4,
    holesZ = [[2,3,2,3], [2,9,2,9], [2,15,2,15], [8,3,8,3], [8,9,8,9], [8,15,8,15], [14,3,14,3], [14,9,14,9], [14,15,14,15]],
    holeZSize=25
);

difference(){

block(
    baseSideAdjustment=0.1,
    baseLayers=1,
    grid=[20,20],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    holesZ = [[3,4,3,4], [3,10,3,10], [3,16,3,16], [9,4,9,4], [9,10,9,10], [9,16,9,16], [15,4,15,4], [15,10,15,10], [15,16,15,16]],
    holeZSize=25,
    gridOffset=[0,0,1]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[-6,-8,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[-6,-2,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[-6,4,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[0,-8,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[0,-2,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[0,4,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[6,-8,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[6,-2,0.8]
);

block(
    baseSideAdjustment=0.4,
    baseLayers=3,
    grid=[4,2],
    baseCutoutType = "NONE",
    knobs = false,
    previewQuality = 0.4,
    gridOffset=[6,4,0.8]
);

}