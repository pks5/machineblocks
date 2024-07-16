echo(version=version());

include <../../lib/block.scad>;

//Back
block(grid=[14,1], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", withHolesX=true);
block(grid=[1,1], brickOffset=[-7.5,0,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");

//Outer Wall
block(grid=[14,1], brickOffset=[0,1,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", withHolesX=true, knobs=false);
block(grid=[2,1], brickOffset=[-8,1,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);
block(grid=[1,1], brickOffset=[7.5,1,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);

//Left
block(grid=[1,14], brickOffset=[-7.5,-7.5,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", withHolesY=true);
block(grid=[1,1], brickOffset=[-7.5,-15,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");

//Outer Wall
block(grid=[1,14], brickOffset=[-8.5,-7.5,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", withHolesY=true, knobs=false);
block(grid=[1,1], brickOffset=[-8.5,0,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);
block(grid=[1,1], brickOffset=[-8.5,-15,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "NONE", knobs=false);

//Front
block(grid=[14,1], brickOffset=[0,-15,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", withHolesX=true);
block(grid=[1,1], brickOffset=[7.5,-15,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");

//Right
block(grid=[1,14], brickOffset=[7.5,-7.5,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE", withHolesY=true);
block(grid=[1,1], brickOffset=[7.5,0,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "NONE");
