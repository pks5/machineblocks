include <../../lib/block.scad>;

parts = "ALL";


if(parts == "WALL" || parts == "ALL"){
block(
        baseLayers=23, 
        grid=[4,1], 
        wallGapsX=[[0,0]],
        brickOffset=[0, 1.5, 0],
        withPit = true,
        pitWallGaps = [[2,0,0]],
        screwHolesZ = [[0,0], [3,0]],
        screwHoleZSize = 2,
        screwHolesY = [[0, 2], [0, 21]],
        screwHoleXYSize = 2.4,
        knobTongueClampThickness = 0.1
    );

    block(
        baseLayers=23, 
        grid=[1, 4], 
        wallGapsY=[[3,1]], 
        brickOffset=[-1.5, 0, 0],
        withPit = true,
        pitWallGaps= [[1,0,0]],
        screwHolesZ = [[0,0], [0,3]],
        screwHoleZSize = 2,
        screwHolesX = [[0, 2], [0, 21]],
        screwHoleXYSize = 2.4,
        knobClampThickness = 0.1
    );

    }

if(parts == "TOP" || parts == "ALL"){
       
        translate([0,40,0]){
       
            block(
            baseLayers=1, 
            grid=[4,1], 
            wallGapsX=[[0,0]],
            brickOffset=[0, 1.5, 0],
            pitWallGaps= [[2,0,0]],
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE"
        );

        block(
            baseLayers=1, 
            grid=[1, 4], 
            wallGapsY=[[3,1]], 
            brickOffset=[-1.5, 0, 0],
            pitWallGaps= [[1,0,0]],
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = -0.1,
            baseCutoutType = "GROOVE"
        ); 
    }
}