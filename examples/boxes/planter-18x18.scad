echo(version=version());

use <../../lib/block.scad>;

baseSideSize = 7.95;
baseHeight = 3.15;
grid=[12,12];
height=8;

heightLayers = height*3;

union(){
block(baseLayers=3, grid=grid, knobs=false);


block(baseLayers=heightLayers, grid=[grid[0],1], baseCutoutType = "none",
    text="\ue5aa",
    textSide=2,
    textSize=40,
    textFont="Font Awesome 6 Free Solid", gridOffset=[0,-5.5,3]); 


block(baseLayers=heightLayers, grid=[grid[0],1], baseCutoutType = "none", gridOffset=[0,5.5,3]);


block(baseLayers=heightLayers, grid=[1,grid[0]-2], baseCutoutType = "none", gridOffset=[-5.5,0,3], baseSideAdjustment=[-0.1,-0.1,0.1,0.1]);


block(baseLayers=heightLayers, grid=[1,grid[0]-2], baseCutoutType = "none", gridOffset=[5.5,0,3], baseSideAdjustment=[-0.1,-0.1,0.1,0.1]); 
}