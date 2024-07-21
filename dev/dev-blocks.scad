echo(version=version());

include <../lib/block.scad>;

color("yellow")
    translate([-20, 10, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");

color("yellow")
    translate([-20, 0, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");

color("yellow")
    translate([-20, -10, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");

color("yellow")
    translate([-20, -20, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");
        
color("yellow")
    translate([-20, -30, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");

color("yellow")
    translate([-20, -40, 0])
        block(baseLayers=3, grid=[2,1], holesX=true, knobType = "TECHNIC");


color("blue")
    translate([-20, -60, 0])
        block(baseLayers=3, grid=[3,2]);        

color("green")
    translate([10, -80, 0])
        block(grid=[3, 14], adhesionHelpers=true);