echo(version=version());

include <../lib/block.scad>;

/* [Hidden] */

grid = [2, 1];

//block(baseLayers=3, grid=grid, knobType = "technic", holesX=true);

//block(baseLayers=1, grid=grid, gridOffset=[0,1,1], baseSideAdjustment=[-0.1,-0.1,0.1,-0.1]);


*translate([0,0,0]){
block(baseLayers=1, grid=[1,1], knobs = false, baseRoundingRadius = [0,0,[0,7.6,0,0]], baseReliefCut=true);

block(baseLayers=1, grid=[1,1], gridOffset=[1,0,0], knobs = false, baseRoundingRadius = [0,0,[0,0,7.8,0]], baseReliefCut=true);

block(baseLayers=1, grid=[2,1], gridOffset=[3,0,0], knobs = false, baseRoundingRadius = [0,0,[0,7.8,7.8,0]], baseReliefCut=true);

block(baseLayers=1, grid=[2,2], gridOffset=[2,2,0], knobs = false, baseRoundingRadius = [0,0,7.8], baseReliefCut=true);
  }      
        
        
difference(){
    block(grid=[4,4], knobs=false, align="start", alignChildren="start"){
        block(grid=[2,2], gridOffset=[0,0,0], knobs=true, baseCutoutType="none", baseSideAdjustment=1.5, align=["center","center","start"]);
    
    };

    block(grid=[2,2], gridOffset=[2,2,0], baseLayers=3, knobs=false, baseCutoutType="none", baseSideAdjustment=0.1, align=["start", "start", "center"]);
 }
 
 
 *block(grid=[4,2], baseLayers=3, knobs=true, align=["start","start","start"], previewRender=false);