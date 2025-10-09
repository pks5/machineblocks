use <../lib/block.scad>;



*translate([0,0,0]){
machineblock(size=[1,1,1], studs = false, baseRoundingRadius = [0,0,[0,7.6,0,0]], baseReliefCut=true);

machineblock(size=[1,1,1], offset=[1,0,0], studs = false, baseRoundingRadius = [0,0,[0,0,7.8,0]], baseReliefCut=true);

machineblock(size=[2,1,1], offset=[3,0,0], studs = false, baseRoundingRadius = [0,0,[0,7.8,7.8,0]], baseReliefCut=true);

machineblock(size=[2,2,1], offset=[2,2,0], studs = false, baseRoundingRadius = [0,0,7.8], baseReliefCut=true);
  }      
        
        
*difference(){
    machineblock(size=[4,4,1], studs=true, align="start", alignChildren="start"){
        machineblock(
          size=[2,2,1], 
          offset=[0,0,0], 
          studs=false,
          baseCutoutType="none",
          baseSideAdjustment=[-0.1,1.5,-0.1,1.5], 
          align="start",
          baseClampOuter=true
        );
    
    };
    machineblock(size=[2,2,6], offset=[0,0,0], studs=false, baseCutoutType="none", baseSideAdjustment=0.1, align=["start", "start", "center"]);
 }
 

 
 
 *machineblock(
    scale=3,
    size=[6,6,3], 
    baseRoundingRadius=[0,0,8],
    studs=false,
   tongue=true, 
   baseReliefCut = true,
   
    align=["start","start","start"], 
    previewRender=false,
    pit=true,
    pitWallThickness=0.33,
    pitKnobPadding=0.1
 );
 
 machineblock(size=[1,4,3], holeY = [true, [0,0,0,0],[1,0,1,0,"axle"]]);