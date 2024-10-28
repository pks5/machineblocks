echo(version=version());

include <../lib/block.scad>;
 /*  
translate([-20, 0, 0])
        block(baseLayers=3, grid=[4,2], baseHeightAdjustment=-0.2, wallThickness = 1.5);


     
translate([-20, -20, 0])
        block(baseLayers=3, grid=[2,1], baseHeightAdjustment=-0.2, wallThickness = 1.5);



        
translate([-20, -60, 0])
        block(baseLayers=3, grid=[2,2], baseHeightAdjustment=-0.2, wallThickness = 1.5);
 */       
 
 translate([-20, -40, 0])
        block(grid=[12,2], wallGapsX=[[0,2,3]]);        