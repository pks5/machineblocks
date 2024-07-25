echo(version=version());

include <../../lib/block.scad>;

//Back
block(grid=[14,1], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", holesX=true);
block(grid=[1,1], gridOffset=[-7.5,0,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");

//Outer Wall
block(grid=[14,1], gridOffset=[0,1,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", holesX=true, knobs=false);
block(grid=[2,1], gridOffset=[-8,1,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);
block(grid=[1,1], gridOffset=[7.5,1,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);

//Left
block(grid=[1,14], gridOffset=[-7.5,-7.5,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", holesY=true);
block(grid=[1,1], gridOffset=[-7.5,-15,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");

//Outer Wall
block(grid=[1,14], gridOffset=[-8.5,-7.5,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", holesY=true, knobs=false);
block(grid=[1,1], gridOffset=[-8.5,0,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);
block(grid=[1,1], gridOffset=[-8.5,-15,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);

//Front
block(grid=[14,1], gridOffset=[0,-15,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", holesX=true);
block(grid=[1,1], gridOffset=[7.5,-15,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");

//Right
block(grid=[1,14], gridOffset=[7.5,-7.5,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", holesY=true);
block(grid=[1,1], gridOffset=[7.5,0,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");
