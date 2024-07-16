echo(version=version());

include <../../lib/block.scad>;

grid = [6,6];
pitWallThickness = 0.8;
originalBaseHeight=3.2;
baseSideLength = 8;
brickHeight=3.4;

grassFitTolerance=0.1;
grassHeight=5;
strawWidth=0.8;
strawThickness=0.2;
preferredSpaceX=0.8;
preferredSpaceY=0.8;
strawOffsetX=0.2;
strawOffsetY=0.2;

brimThickness=8;
brimHeight=0.2;
pitDepth = 0.8;

withTop=true;
withBottom=true;

if(withBottom){
    block(
        grid=grid,
        baseHeight=brickHeight,
        topPlateHeight=0.4,
        stabilizerGridHeight=1,
        pitDepth=pitDepth,
        baseHeightOriginal=originalBaseHeight,
        baseSideLength = baseSideLength,
        pitWallThickness = pitWallThickness,
        withPit=true,
        knobs=false
    );
}

if(withTop){
    grassSizeX = grid[0] * baseSideLength - 2*(pitWallThickness + grassFitTolerance);
    grassSizeY = grid[1] * baseSideLength - 2*(pitWallThickness + grassFitTolerance);
    columnsCount = 1 + floor((grassSizeX - 2*strawOffsetX - strawWidth) / (strawWidth + preferredSpaceX)); 
    rowsCount = 1 + floor((grassSizeY - 2*strawOffsetY - strawThickness) / (strawThickness + preferredSpaceY));
    spaceX = (grassSizeX - 2*strawOffsetX - columnsCount*strawWidth) / (columnsCount - 1); 
    spaceY = (grassSizeY - 2*strawOffsetY - rowsCount*strawThickness) / (rowsCount - 1);
    
color([0.945, 0.769, 0.059])
    translate([0,40,0]){
        
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