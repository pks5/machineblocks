include <../../lib/block.scad>;

parts = "WALL";


if(parts == "WALL" || parts == "ALL"){
block(
        baseLayers=23, 
        grid=[3,1], 
        wallGapsX=[[0,0]],
        brickOffset=[0, 1, 0],
        pit = true,
        tongue = true,
        tongueRoundingRadius = [0.5, 2.7, 0.5, 0.5],
        pitWallGaps = [[2,0,0]],

        pitRoundingRadius=[0, 1.2, 0, 0],
        screwHolesZ = [[0,0], [2,0]],
        screwHoleZSize = 2,
        screwHolesY = [[0, 2], [0, 21]],
        screwHoleYSize = 2.4,
        knobTongueClampThickness = 0.1,
        baseRoundingRadius=[0,0,[0, 4,0,0]],
        baseCutoutRoundingRadius=[0,2.7,0,0],
        previewQuality=1
    );

    block(
        baseLayers=23, 
        grid=[1, 3], 
        wallGapsY=[[2,1]], 
        brickOffset=[-1, 0, 0],
        pit = true,
        tongue = true,
        tongueRoundingRadius = [0.5, 2.7, 0.5, 0.5],
        pitWallGaps= [[1,0,0]],
        pitRoundingRadius=[0, 1.2, 0, 0],
        screwHolesZ = [[0,0], [0,2]],
        screwHoleZSize = 2,
        screwHolesX = [[0, 2], [0, 21]],
        screwHoleXSize = 2.4,
        knobClampThickness = 0.1,
        baseRoundingRadius=[0,0,[0, 4,0,0]],
        baseCutoutRoundingRadius=[0,2.7,0,0],
        previewQuality=0.5
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
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = 0,
            baseCutoutType = "GROOVE",
            baseRoundingRadius=[0,0,[0, 4,0,0]],
            previewQuality=0.5
        );

        block(
            baseLayers=1, 
            grid=[1, 3], 
            wallGapsY=[[2,1]], 
            brickOffset=[-1, 0, 0],
            pitWallGaps= [[1,0,0]],
            knobTongueClampThickness = 0.1,
            knobTongueAdjustment = -0.1,
            baseCutoutType = "GROOVE",
            baseRoundingRadius=[0,0,[0, 4,0,0]],
            previewQuality=0.5
        ); 
    }
}