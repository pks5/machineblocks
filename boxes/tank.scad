echo(version=version());

include <../lib/block-v2.scad>;

grid=[8,12];
totalHeight = 57;

union(){
block(baseLayers=3, grid=grid, withKnobs=true);


block(baseHeight=totalHeight, grid=[grid[0],1], withBaseHoles=false, brickOffset=[0,-5.5,3]); 

block(baseHeight=totalHeight, grid=[grid[0],1], withBaseHoles=false, brickOffset=[0,5.5,3]);

block(baseHeight=totalHeight, grid=[1,grid[1]-2], withBaseHoles=false, brickOffset=[-3.5,0,3], adjustSides=[-0.1,-0,1,0.1,0.1]);

block(baseHeight=totalHeight, grid=[1,grid[1]-2], withBaseHoles=false, brickOffset=[3.5,0,3], adjustSides=[-0.1,-0,1,0.1,0.1]); 
}