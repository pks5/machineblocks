echo(version=version());

use <../../lib/block.scad>;

grid=[8,12];
totalHeight = 57;

union(){
block(baseLayers=3, grid=grid, withKnobs=true);


block(baseHeight=totalHeight, grid=[grid[0],1], baseSolid=true, brickOffset=[0,-5.5,3]); 

block(baseHeight=totalHeight, grid=[grid[0],1], baseSolid=true, brickOffset=[0,5.5,3]);

block(baseHeight=totalHeight, grid=[1,grid[1]-2], baseSolid=true, brickOffset=[-3.5,0,3], sideAdjustment=[-0.1,-0,1,0.1,0.1]);

block(baseHeight=totalHeight, grid=[1,grid[1]-2], baseSolid=true, brickOffset=[3.5,0,3], sideAdjustment=[-0.1,-0,1,0.1,0.1]); 
}