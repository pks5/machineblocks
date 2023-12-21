echo(version=version());

include <../lib/block-v2.scad>;

//Back
block(grid=[14,1], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false, withXHoles=true);
block(grid=[1,1], brickOffset=[-7.5,0], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false);

//Outer Wall
block(grid=[14,1], brickOffset=[0,1], adjustSizeX=0, adjustSizeY=0, baseLayers=4, withBaseHoles=false, withXHoles=true, withKnobs=false);
block(grid=[2,1], brickOffset=[-8,1], adjustSizeX=0, adjustSizeY=0, baseLayers=4, withBaseHoles=false, withKnobs=false);
block(grid=[1,1], brickOffset=[7.5,1], adjustSizeX=0, adjustSizeY=0, baseLayers=4, withBaseHoles=false, withKnobs=false);

//Left
block(grid=[1,14], brickOffset=[-7.5,-7.5], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false, withYHoles=true);
block(grid=[1,1], brickOffset=[-7.5,-15], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false);

//Outer Wall
block(grid=[1,14], brickOffset=[-8.5,-7.5], adjustSizeX=0, adjustSizeY=0, baseLayers=4, withBaseHoles=false, withYHoles=true, withKnobs=false);
block(grid=[1,1], brickOffset=[-8.5,0], adjustSizeX=0, adjustSizeY=0, baseLayers=4, withBaseHoles=false, withKnobs=false);
block(grid=[1,1], brickOffset=[-8.5,-15], adjustSizeX=0, adjustSizeY=0, baseLayers=4, withBaseHoles=false, withKnobs=false);

//Front
block(grid=[14,1], brickOffset=[0,-15], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false, withXHoles=true);
block(grid=[1,1], brickOffset=[7.5,-15], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false);

//Right
block(grid=[1,14], brickOffset=[7.5,-7.5], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false, withYHoles=true);
block(grid=[1,1], brickOffset=[7.5,0], adjustSizeX=0, adjustSizeY=0, baseLayers=3, withBaseHoles=false);
