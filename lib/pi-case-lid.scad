echo(version=version());

include <./block-v2.scad>;

baseSideLength=8;
brickHeight = 3;
blockHeight = 28.40;
floorHeight = 3.1;
lidHeight = 3;
lidHeightTolerance = 0.1;
lidSpacing = 0.3;
grid = [8, 12];
halfGrid=[8, 0.5*grid[1]];
plateHeight = 0.6;
wallThickness = 2;
wallY1Thickness = 3;

wallInset = 1;
innerWallHeight=2;
knobSize=5;
knobHeight = 1.9;

lidHoleRadius=2;
drawDistance = 20;
cutSpace=1;

adjustSizeX = 0;
adjustSizeY = 0;

finalObjectSizeX = (halfGrid[0] * baseSideLength) + adjustSizeX;
finalObjectSizeY = 2* ((halfGrid[1] * baseSideLength) + adjustSizeY);

doubleThinWallThickness = 2*(wallThickness - wallInset);
totalLidHeight = lidHeight + knobHeight;

innerWallHolderHeight = 0.6;
innerWallHolderThickness = 0.1;

roundingRadius = 0.25;
roundingResolution = 15;
withKnobsFilled=true;


module pi_case_lid(
    knobGaps = []
){
    //Lid
    
    translate([0, 0, 0*(0.5 * totalLidHeight + innerWallHeight)]){
        color("red")
        union(){
            difference(){
                //Lid block with knobs
                block(baseHeight = lidHeight, withBaseHoles=false, grid=grid, withKnobs=true, withKnobsFilled=withKnobsFilled, knobSize=knobSize, knobGaps=knobGaps, adjustSizeX=adjustSizeX, adjustSizeY=adjustSizeY, center=true);
                
                //Cut border to fit as lid
                difference(){
                    cube([finalObjectSizeX+cutSpace, finalObjectSizeY+cutSpace, 2*totalLidHeight], center=true);
                    cube([finalObjectSizeX-doubleThinWallThickness, finalObjectSizeY-doubleThinWallThickness, 2*totalLidHeight+cutSpace], center=true);
                };
            };
            
            translate([0, 0.5 * (wallY1Thickness - wallThickness), -0.5 * (totalLidHeight + innerWallHeight)]){
                cube([finalObjectSizeX-2*wallThickness, finalObjectSizeY - (wallThickness + wallY1Thickness), innerWallHeight], center=true);
                roundedcube_simple(size = [finalObjectSizeX-2*wallThickness + 2*innerWallHolderThickness, finalObjectSizeY - (wallThickness + wallY1Thickness) + 2*innerWallHolderThickness, innerWallHolderHeight], 
                                    center = true, 
                                    radius=roundingRadius, 
                                    resolution=roundingResolution); 
            }
            /*
            translate([0, (wallY1Thickness - wallThickness), -0.5 * (totalLidHeight + innerWallHeight)]){
                difference(){
                    cube([finalObjectSizeX-2*wallThickness, finalObjectSizeY-2*wallThickness-1, innerWallHeight], center=true);
                    cube([finalObjectSizeX-3*wallThickness, finalObjectSizeY-3*wallThickness-1, innerWallHeight+cutSpace], center=true);
                }
            }
            */
        }
    }
}