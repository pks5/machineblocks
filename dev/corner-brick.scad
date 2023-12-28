echo(version=version());

include <../lib/block-v2.scad>;


        
block(baseLayers=3, grid=[2,1], withKnobsFilled=true, wallGapsX=[[0,0]], withHullRounding=false);

block(baseLayers=3, grid=[1, 3], withKnobsFilled=true, brickOffset=[-0.5, -1, 0], wallGapsY=[[2,1]]);