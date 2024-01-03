echo(version=version());

include <../lib/block-v2.scad>;

grid = [6,6];
cavityWallThickness = 2.6;
cavityDepth=0.8;
grassHeight=2.4;
strawWidth=0.4;
preferredSpaceX=0.4;
preferredSpaceY=0.4;

block(
    grid=grid,
    baseHeight=4,
    withCavity=true,
    withKnobs=false
);

//spaceX = 

translate([60,0,0]){
    
    translate([0,0,-0.5*(cavityDepth+grassHeight)])
        block(
            baseHeight=cavityDepth,
            grid=grid,
            withBaseHoles=false,
            withKnobs=false,
            adjustSize=[-cavityWallThickness, -cavityWallThickness, -cavityWallThickness, -cavityWallThickness]
        );
    
    translate([0,0,0.5*(cavityDepth+grassHeight)])
        block(
            baseHeight=cavityDepth,
            grid=grid,
            withBaseHoles=false,
            withKnobs=false,
            adjustSize=[-cavityWallThickness, -cavityWallThickness, -cavityWallThickness, -cavityWallThickness]
        );
    
}