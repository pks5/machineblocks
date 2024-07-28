echo(version=version());

include <../lib/block.scad>;

color("yellow")
    translate([-20, 10, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "technic");

color("yellow")
    translate([-20, 0, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "technic");

color("yellow")
    translate([-20, -10, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "technic");

color("yellow")
    translate([-20, -20, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "technic");
        
color("yellow")
    translate([-20, -30, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "technic");

color("yellow")
    translate([-20, -40, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "technic");


color("blue")
    translate([-20, -60, 0])
        block(baseLayers=3, grid=[3,2], baseRoundingRadius=[0,0,[0,0,4,0]]);        
color("blue")
    translate([-20, -80, 0])
        block(baseLayers=3, grid=[3,2], baseRoundingRadius=[0,0,[4,4,4,0]]);        

color("green")
    translate([10, -80, 0])
        block(grid=[3, 14], adhesionHelpers=true);

translate([10, -180, 0])
mb_rounded_block(
				radius = [0, 0, [4, 4, 4, 4]], size = [63.8, 7.8, 3.2],
				center = true, 
				resolution = 30
			);
 
        