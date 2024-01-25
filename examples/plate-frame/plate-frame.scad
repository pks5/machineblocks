echo(version=version());

include <../../lib/block.scad>;

//Back
block(grid=[14,1], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true, withHolesX=true);
block(grid=[1,1], brickOffset=[-7.5,0,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true);

//Outer Wall
block(grid=[14,1], brickOffset=[0,1,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseSolid=true, withHolesX=true, withKnobs=false);
block(grid=[2,1], brickOffset=[-8,1,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseSolid=true, withKnobs=false);
block(grid=[1,1], brickOffset=[7.5,1,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseSolid=true, withKnobs=false);

//Left
block(grid=[1,14], brickOffset=[-7.5,-7.5,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true, withHolesY=true);
block(grid=[1,1], brickOffset=[-7.5,-15,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true);

//Outer Wall
block(grid=[1,14], brickOffset=[-8.5,-7.5,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseSolid=true, withHolesY=true, withKnobs=false);
block(grid=[1,1], brickOffset=[-8.5,0,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseSolid=true, withKnobs=false);
block(grid=[1,1], brickOffset=[-8.5,-15,0], sideAdjustment=[0,0,0,0], baseLayers=4, baseSolid=true, withKnobs=false);

//Front
block(grid=[14,1], brickOffset=[0,-15,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true, withHolesX=true);
block(grid=[1,1], brickOffset=[7.5,-15,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true);

//Right
block(grid=[1,14], brickOffset=[7.5,-7.5,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true, withHolesY=true);
block(grid=[1,1], brickOffset=[7.5,0,0], sideAdjustment=[0,0,0,0], baseLayers=3, baseSolid=true);
