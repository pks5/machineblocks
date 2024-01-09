echo(version=version());

include <../lib/block-v2.scad>;

translate([-20, -20, 0])
        block(baseLayers=3, grid=[3,2], knobsFilled=true);
        
translate([-20, -40, 0])
        block(baseLayers=3, grid=[3,2], knobsFilled=true);
        
translate([-20, -60, 0])
        block(baseLayers=3, grid=[4,2], knobsFilled=true);
        
translate([-20, -80, 0])
        block(baseLayers=3, grid=[6,2], knobsFilled=true);
        
translate([20, -20, 0])
        block(baseLayers=3, grid=[3,1], knobsFilled=true);
        
translate([20, -40, 0])
        block(baseLayers=3, grid=[4,1], knobsFilled=true);
        
translate([20, -60, 0])
        block(baseLayers=3, grid=[6,1], knobsFilled=true);
        
translate([20, -80, 0])
        block(baseLayers=3, grid=[3,1], knobsFilled=true);