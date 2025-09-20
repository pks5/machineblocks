echo(version=version());

include <../../lib/block.scad>;

outerWallX = false;
outerWallY = true;
outerWallHolesX = true;
outerWallHolesY = false;
grid = [18,16];

//Back
block(grid=[grid[0]-2,1], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", holesX=outerWallHolesX, align="ccs");
block(grid=[1,1], gridOffset=[-(0.5*(grid[0]-1)),0,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", align="ccs");

if(outerWallX){
    //Outer Wall
    block(grid=[grid[0]-2,1], gridOffset=[0,1,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "none", holesX=outerWallHolesX, knobs=false, align="ccs");
    block(grid=[2,1], gridOffset=[-(0.5*grid[0]),1,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "none", knobs=false, align="ccs");
    block(grid=[1,1], gridOffset=[(0.5*(grid[0]-1)),1,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "none", knobs=false, align="ccs");
}

//Left
block(grid=[1,grid[1]-2], gridOffset=[-(0.5*(grid[0]-1)),-(0.5*(grid[1]-1)),0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", holesY=outerWallHolesY, align="ccs");
block(grid=[1,1], gridOffset=[-(0.5*(grid[0]-1)),-(grid[1]-1),0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", align="ccs");

if(outerWallY){
    //Outer Wall
    block(grid=[1,grid[1]-2], gridOffset=[-(0.5*(grid[0]+1)),-(0.5*(grid[1]-1)),0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "none", holesY=outerWallHolesY, knobs=false, align="ccs");
    block(grid=[1,1], gridOffset=[-(0.5*(grid[0]+1)),0,0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "none", knobs=false, align="ccs");
    block(grid=[1,1], gridOffset=[-(0.5*(grid[0]+1)),-(grid[1]-1),0], baseSideAdjustment=[0,0,0,0], baseLayers=4, baseCutoutType = "none", knobs=false, align="ccs");
}

//Front
block(grid=[grid[0]-2,1], gridOffset=[0,-(grid[1]-1),0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", holesX=true, align="ccs");
block(grid=[1,1], gridOffset=[(0.5*(grid[0]-1)),-(grid[1]-1),0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", align="ccs");

//Right
block(grid=[1,grid[1]-2], gridOffset=[(0.5*(grid[0]-1)),-(0.5*(grid[1]-1)),0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", holesY=true, align="ccs");
block(grid=[1,1], gridOffset=[(0.5*(grid[0]-1)),0,0], baseSideAdjustment=[0,0,0,0], baseLayers=3, baseCutoutType = "none", align="ccs");
