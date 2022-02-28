echo(version=version());

include <../lib/block-v2.scad>;

color("green")
    translate([-80, 10, 0])
        block(baseLayers=3, withXHoles = true,grid=[20,1], withKnobsFilled=false);

color("green")
    translate([-80, 0, 0])
        block(baseLayers=3, withXHoles = true,grid=[16,1], withKnobsFilled=false);

color("green")
    translate([-80, -10, 0])
        block(baseLayers=3, withXHoles = true,grid=[12,1], withKnobsFilled=false);

color("green")
    translate([-80, -20, 0])
        block(baseLayers=3, withXHoles = true,grid=[10,1], withKnobsFilled=false);
        
color("green")
    translate([-80, -30, 0])
        block(baseLayers=3, grid=[9,1], withXHoles = true, withKnobsFilled=false);
        
color("green")
    translate([-80, -40, 0])
        block(baseLayers=3, grid=[8,1], withXHoles = true, withKnobsFilled=false);
        
color("green")
    translate([-80, -50, 0])
        block(baseLayers=3, grid=[7,1], withXHoles = true, withKnobsFilled=false);

color("green")
    translate([-80, -60, 0])
        block(baseLayers=3, grid=[6,1], withXHoles = true, withKnobsFilled=false);
        
color("green")
    translate([-80, -70, 0])
        block(baseLayers=3, grid=[5,1], withXHoles = true, withKnobsFilled=false);
        
color("green")
    translate([-80, -80, 0])
        block(baseLayers=3, grid=[4,1], withXHoles = true, withKnobsFilled=false);
        
color("green")
    translate([-80, -90, 0])
        block(baseLayers=3, grid=[3,1], withXHoles = true, withKnobsFilled=false);    

color("green")
    translate([-80, -100, 0])
        block(baseLayers=3, grid=[2,1], withXHoles = true, withKnobsFilled=false);     