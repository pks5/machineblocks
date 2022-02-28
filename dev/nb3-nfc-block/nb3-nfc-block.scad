echo(version=version());

include <../../lib/hollow_block.scad>;

floorHeight = 3.8;
plateHeight = 1.3;
brickHeight = 2;
withTop=false;
withBottom=true;

if(withBottom){
    translate([-30, 0, 0]){
        hollowBlock(
            brickHeight=brickHeight, 
            floorHeight=floorHeight, 
            plateHeight=plateHeight,
            adjustSizeX=0,
            adjustSizeY=0,
            innerWallHeight=1.2, 
            withInnerWallFilled=true, 
            top=false,
            center=true, 
            alwaysOnFloor=true,
            grid=[6,6]
        );
    }
}

if(withTop){
    translate([30, 0, 0]){
        difference(){
            hollowBlock(
                brickHeight=brickHeight, 
                floorHeight=floorHeight, 
                plateHeight=plateHeight,
                adjustSizeX=0,
                adjustSizeY=0,
                top=true,
                center=true,
                alwaysOnFloor=true,
                grid=[6,6]
            );
            
            translate([-2, -24, 7.8]){
                roundedcube([12, 12, 3.9], true, 1, "y");
            }
            
            translate([-24, 2, 7.8]){
                roundedcube([21, 21, 3.9], true, 1, "x");
            }
        }   
         
        color("red"){
            difference(){
                translate([-17.25, -17.25, 15.85]){
                    cube([10.5, 10.5, 2.5], true);
                }
                
                translate([-15, -15, 8.55]){
                    cylinder(h=17.1, r=0.5 * 2.2, center=true, $fn=15);
                }
            }
                
            translate([18.25, -18.25, 15.85]){
                cube([8.5, 8.5, 2.5], true);
            }
            
            difference(){
                translate([15.25, 16.25, 15.85]){
                    cube([14.5, 12.5, 2.5], true);
                }
                
                translate([11, 13, 8.55]){
                    cylinder(h=17.1, r=0.5 * 2.2, center=true, $fn=15);
                }
            }
            
            translate([-18.25, 18.25, 15.85]){
                cube([8.5, 8.5, 2.5], true);
            }
        }
    }
}