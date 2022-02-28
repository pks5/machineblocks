echo(version=version());

include <../../lib/hollow_block.scad>;

floorHeight = 3.8;
plateHeight = 1.3;
brickHeight = 4;
withTop=true;
withBottom=false;

if(withBottom){
    translate([-30, 0, 0]){
        difference(){
            union(){
                hollowBlock(
                    brickHeight=brickHeight, 
                    floorHeight=floorHeight, 
                    plateHeight=plateHeight,
                    innerWallHeight=1.2, 
                    withInnerWallFilled=true, 
                    top=false,
                    center=true, 
                    alwaysOnFloor=true,
                    grid=[2,4]
                );
                
                translate([-5.5,0,20.25]){
                  cube([1.5, 25.5, 30.5], true);  
                }
                
                translate([-1.75,0,8.15]){
                  cube([6, 25.5, 6.3], true);  
                }
                
                translate([-2.75,-10.6,23.4]){
                  cube([4, 4.3, 24.2], true);  
                }
                
                translate([-2.75,10.6,23.4]){
                  cube([4, 4.3, 24.2], true);  
                }
            };
            
            translate([0,0,21.5]){
                rotate([0, 90,0]){
                    cylinder(h=17.9, r=0.5 * 8, center=true, $fn=15);
                }
            }
            
            translate([4.2,-10.6,21]){
                rotate([0, 90,0]){
                    cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
                }
            }
            
            translate([4.2,-10.6,33.35]){
                rotate([0, 90,0]){
                    cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
                }
            }
            
            translate([4.2,10.6,21]){
                rotate([0, 90,0]){
                    cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
                }
            }
            
            translate([4.2,10.6,33.35]){
                rotate([0, 90,0]){
                    cylinder(h=17.9, r=0.5 * 2.2, center=true, $fn=15);
                }
            }
        };
        
     }
    
    
}

if(withTop){
    translate([30, 0, 0]){
        difference(){
            hollowBlock(
                brickHeight=brickHeight, 
                floorHeight=floorHeight, 
                plateHeight=plateHeight,
                top=true,
                center=true,
                alwaysOnFloor=true,
                grid=[2,4]
            );
            
            translate([5, 0, 6.25]){
                roundedcube([18, 18, 2.5], true, 1, "x");
            }
            
            translate([-5, 0, 21.5]){
                rotate([0, 90,0]){
                    cylinder(h=10, r=0.5 * 5, center=true, $fn=15);
                }
            }
            
            translate([-8, 0, 21.5]){
                rotate([0, 90,0]){
                    cylinder(h=1, r=0.5 * 6, center=true, $fn=15);
                }
            }
        }
        
        
    }
}