
include <../../lib/block.scad>;

block(
            baseLayers=3,
            grid=[2,1],
            withPit=true,
            pitWallGaps= [[3,0,0]],
            screwHolesX=[[0,1], [1,1]],
            //screwHolesZ = [[0,0], [7,0]],
            //screwHoleSize = 2,
            knobTongueClampThickness = 0.1
        );