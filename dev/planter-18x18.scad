echo(version=version());

include <../lib/block-v2.scad>;

baseSideSize = 7.95;
baseHeight = 3.15;
grid=[12,12];
height=8;

heightLayers = height*3;

union(){
block(baseLayers=3, grid=grid, withKnobs=false, plateHeight=2*baseHeight);

translate([0,0,3*baseHeight])
block(baseLayers=heightLayers, grid=[grid[0],1], logoSide=1,logoSize=40,withBaseHoles=false,withText=true,
    text="\uf0eb",
    textFont="Font Awesome 5 Free Solid"); 

translate([0, (grid[0]-1)*baseSideSize, 3*baseHeight])
block(baseLayers=heightLayers, grid=[grid[0],1], withBaseHoles=false);

translate([0, baseSideSize, 3*baseHeight])
block(baseLayers=heightLayers, grid=[1,grid[0]-2], withBaseHoles=false);

translate([(grid[0]-1)*baseSideSize, baseSideSize, 3*baseHeight])
block(baseLayers=heightLayers, grid=[1,grid[0]-2], withBaseHoles=false); 
}