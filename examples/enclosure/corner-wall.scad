include <../../lib/block.scad>;

parts = "ALL";


if(parts == "WALL" || parts == "ALL"){
block(
        baseLayers=23, 
        grid=[3,1], 
        wallGapsX=[[0,0]],
        brickOffset=[0, 1, 0],
        withPit = true,
            pitWallGaps= [[2,0,0]],
            screwHoles = [[0,0], [2,0]],
            knobClampThickness = 0.1
    );

    block(
        baseLayers=23, 
        grid=[1, 3], 
        wallGapsY=[[2,1]], 
        brickOffset=[-1, 0, 0],
        withPit = true,
            pitWallGaps= [[1,0,0]],
            screwHoles = [[0,0], [0,2]],
            knobClampThickness = 0.1
    );

    }

if(parts == "TOP" || parts == "ALL"){
       
        translate([0,40,0]){
       
            block(
            baseLayers=1, 
            grid=[3,1], 
            wallGapsX=[[0,0]],
            brickOffset=[0, 1, 0],
            pitWallGaps= [[2,0,0]],
            knobClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        ); 

        block(
            baseLayers=1, 
            grid=[1, 3], 
            wallGapsY=[[2,1]], 
            brickOffset=[-1, 0, 0],
            pitWallGaps= [[1,0,0]],
            knobClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        ); 
    }
}