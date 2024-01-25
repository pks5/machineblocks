echo(version=version());

include <../lib/block.scad>;

translate([-20, -20, 0])
        block(baseLayers=3, grid=[3,2]);
        
translate([-20, -40, 0])
        block(baseLayers=3, grid=[3,2]);
        
translate([-20, -60, 0])
        block(baseLayers=3, grid=[4,2]);
        
translate([-20, -80, 0])
        block(baseLayers=3, grid=[6,2]);
        
translate([20, -20, 0])
        block(baseLayers=3, grid=[3,1]);
        
translate([20, -40, 0])
        block(baseLayers=3, grid=[4,1]);
        
translate([20, -60, 0])
        block(baseLayers=3, grid=[6,1]);
        
translate([20, -80, 0])
        block(baseLayers=3, grid=[3,1]);