echo(version=version());

use <../../lib/block.scad>;

grid=[8,12];
totalHeight = 57;

union(){
block(baseLayers=3, grid=grid, withKnobs=true);


block(baseHeight=totalHeight, grid=[grid[0],1], baseCutoutType = "NONE", gridOffset=[0,-5.5,3]); 

block(baseHeight=totalHeight, grid=[grid[0],1], baseCutoutType = "NONE", gridOffset=[0,5.5,3]);

block(baseHeight=totalHeight, grid=[1,grid[1]-2], baseCutoutType = "NONE", gridOffset=[-3.5,0,3], baseSideAdjustment=[-0.1,-0,1,0.1,0.1]);

block(baseHeight=totalHeight, grid=[1,grid[1]-2], baseCutoutType = "NONE", gridOffset=[3.5,0,3], baseSideAdjustment=[-0.1,-0,1,0.1,0.1]); 
}