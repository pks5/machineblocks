echo(version=version());

include <../lib/block-v2.scad>;

baseSideSize = 7.95;
baseHeight = 3.15;
grid=[8,12];
height=6;

heightLayers = height*3;

union(){
block(baseLayers=3, grid=grid, withKnobs=false, plateHeight=(2*baseHeight + 0.65));

translate([0,0,3*baseHeight])
block(baseLayers=heightLayers, grid=[grid[0],1], withBaseHoles=false); 

translate([0, (grid[1]-1)*baseSideSize, 3*baseHeight])
block(baseLayers=heightLayers, grid=[grid[0],1], withBaseHoles=false);

translate([0, baseSideSize, 3*baseHeight])
block(baseLayers=heightLayers, grid=[1,grid[1]-2], withBaseHoles=false);

translate([(grid[0]-1)*baseSideSize, baseSideSize, 3*baseHeight])
block(baseLayers=heightLayers, grid=[1,grid[1]-2], withBaseHoles=false); 
}