echo(version=version());

include <../lib/block.scad>;

translate([-20, 0, 0])
        block(baseLayers=3, grid=[4,2], heightAdjustment=-0.2, wallThickness = 1.5);


 /*       
translate([-20, -20, 0])
        block(baseLayers=3, grid=[2,1], heightAdjustment=-0.2, wallThickness = 1.5);
*/

translate([-20, -40, 0])
        block(baseLayers=3, grid=[3,2], heightAdjustment=-0.2, wallThickness = 1.5);        
        
translate([-20, -60, 0])
        block(baseLayers=3, grid=[2,2], heightAdjustment=-0.2, wallThickness = 1.5);
        