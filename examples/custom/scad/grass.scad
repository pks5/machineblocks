use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

grid = [6,6,1];
pitWallThickness = 0.8 / 8;
gridSizeZ = 3.2;
gridSizeXY = 8;
brickHeight = 3.4;

grassFitTolerance = 0.1;
grassHeight = 5;
strawWidth = 0.8;
strawThickness = 0.2;
preferredSpaceX = 0.8;
preferredSpaceY = 0.8;
strawOffsetX = 0.2;
strawOffsetY = 0.2;

brimThickness = 8;
brimHeight = 0.2;
pitDepth = 0.8;

withTop = true;
withBottom = true;

if(withBottom){
    machineblock(
        size = grid,
        baseHeight = brickHeight,
        baseTopPlateHeightAdjustment = -1, // mm
        stabilizerExpansion = 1, // Integer, Create expansion after each [n] bricks
        stabilizerExpansionOffset = 0,
        pitDepth = pitDepth,
        pitWallThickness = pitWallThickness,
        pit = true,
        studs = false,
        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender,
        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        studRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution
    );
}

if(withTop){
    grassSizeX = grid[0] * gridSizeXY - 2*(pitWallThickness + grassFitTolerance);
    grassSizeY = grid[1] * gridSizeXY - 2*(pitWallThickness + grassFitTolerance);
    columnsCount = 1 + floor((grassSizeX - 2*strawOffsetX - strawWidth) / (strawWidth + preferredSpaceX)); 
    rowsCount = 1 + floor((grassSizeY - 2*strawOffsetY - strawThickness) / (strawThickness + preferredSpaceY));
    spaceX = (grassSizeX - 2*strawOffsetX - columnsCount*strawWidth) / (columnsCount - 1); 
    spaceY = (grassSizeY - 2*strawOffsetY - rowsCount*strawThickness) / (rowsCount - 1);
    
color([0.945, 0.769, 0.059])
    translate([0,80,0]){
        
        translate([0,0,0.5*grassSizeY])
        rotate([90,0,0])
            union(){
                translate([0,0,-0.5*(pitDepth+grassHeight)])
                    cube([grassSizeX, grassSizeY, pitDepth], center=true);
                    
                
                translate([0,0,0.5*(pitDepth+grassHeight)])
                    cube([grassSizeX, grassSizeY, pitDepth], center=true);
                
                translate([-0.5*(grassSizeX-strawWidth), -0.5*(grassSizeY-strawThickness), 0])
                for (a = [ 0 : 1 : columnsCount - 1 ]){
                    for (b = [ 0 : 1 : rowsCount - 1 ]){
                        translate([a*(strawWidth + spaceX)+strawOffsetX, b*(strawThickness + spaceY)+strawOffsetY, 0])
                            cube([strawWidth, strawThickness, grassHeight], center=true);
                    }
                }
            }
                
        //Brim
        //color("red"){
            translate([0,-0.5*(grassHeight+2*pitDepth+brimThickness),0.5*brimHeight])
                    cube([grassSizeX, brimThickness, brimHeight], center=true);
                
            translate([0,0.5*(grassHeight+2*pitDepth+brimThickness),0.5*brimHeight])
                    cube([grassSizeX, brimThickness, brimHeight], center=true);
        //}
    }
}