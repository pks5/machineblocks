echo(version=version());

include <../lib/block-v2.scad>;


        
block(baseLayers=3, grid=[2,1], withKnobsFilled=true, wallGapsX=[[0,0]]);

block(baseLayers=3, grid=[1, 2], withKnobsFilled=true, brickOffset=[-0.5, -0.5, 0], wallGapsY=[[1,1]]);