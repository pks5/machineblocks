echo(version=version());

include <../lib/block-v2.scad>;

baseSideSize = 7.95;
baseHeight = 3.15;
grid=[12,12];
height=8;

heightLayers = height*3;

union(){
block(baseLayers=3, grid=grid, withKnobs=false);


block(baseLayers=heightLayers, grid=[grid[0],1], withBaseHoles=false,withText=true,
    text="\ue5aa",
    textSize=40,
    textFont="Font Awesome 6 Free Solid", brickOffset=[0,-5.5,3]); 


block(baseLayers=heightLayers, grid=[grid[0],1], withBaseHoles=false, brickOffset=[0,5.5,3]);


block(baseLayers=heightLayers, grid=[1,grid[0]-2], withBaseHoles=false, brickOffset=[-5.5,0,3], adjustSizeY=0.2);


block(baseLayers=heightLayers, grid=[1,grid[0]-2], withBaseHoles=false, brickOffset=[5.5,0,3], adjustSizeY=0.2); 
}