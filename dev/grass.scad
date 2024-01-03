echo(version=version());

include <../lib/block-v2.scad>;

grid = [6,6];
cavityWallThickness = 2.6;
defaultBaseHeight=3.2;
baseSideLength = 8;
brickHeight=4;

grassFitTolerance=0.1;
grassHeight=4;
strawWidth=0.4;
strawThickness=0.2;
preferredSpaceX=0.4;
preferredSpaceY=0.4;

brimThickness=8;
brimHeight=0.2;

block(
    grid=grid,
    baseHeight=brickHeight,
    defaultBaseHeight=defaultBaseHeight,
    baseSideLength = baseSideLength,
    cavityWallThickness = 2.6,
    withCavity=true,
    withKnobs=false
);

grassSizeX = grid[0] * baseSideLength - 2*(cavityWallThickness + grassFitTolerance);
grassSizeY = grid[1] * baseSideLength - 2*(cavityWallThickness + grassFitTolerance);
columnsCount = 1 + floor((grassSizeX - strawWidth) / (strawWidth + preferredSpaceX)); 
rowsCount = 1 + floor((grassSizeY - strawThickness) / (strawThickness + preferredSpaceY));
spaceX = (grassSizeX - columnsCount*strawWidth) / (columnsCount - 1); 
spaceY = (grassSizeY - rowsCount*strawThickness) / (rowsCount - 1);
cavityDepth = brickHeight - defaultBaseHeight;

translate([60,0,0]){
    
    translate([0,0,0.5*grassSizeY])
    rotate([90,0,0])
        union(){
            translate([0,0,-0.5*(cavityDepth+grassHeight)])
                cube([grassSizeX, grassSizeY, cavityDepth], center=true);
                
            
            translate([0,0,0.5*(cavityDepth+grassHeight)])
                cube([grassSizeX, grassSizeY, cavityDepth], center=true);
            
            translate([-0.5*(grassSizeX-strawWidth), -0.5*(grassSizeY-strawThickness), 0])
            for (a = [ 0 : 1 : columnsCount - 1 ]){
                for (b = [ 0 : 1 : rowsCount - 1 ]){
                    translate([a*(strawWidth + spaceX), b*(strawThickness + spaceY), 0])
                        cube([strawWidth, strawThickness, grassHeight], center=true);
                }
            }
        }
            
    //Brim
    color("red"){
        translate([0,-0.5*(grassHeight+2*cavityDepth+brimThickness),0.5*brimHeight])
                cube([grassSizeX, brimThickness, brimHeight], center=true);
            
        translate([0,0.5*(grassHeight+2*cavityDepth+brimThickness),0.5*brimHeight])
                cube([grassSizeX, brimThickness, brimHeight], center=true);
    }
}