use <shapes.scad>;

module mb_base(
    objectSize, 
    height, 
    sideAdjustment, 
    baseRounding, 
    roundingRadius, 
    roundingResolution,
    withPit,
    pitWallThickness,
    pitDepth,
    pitWallGaps,
){
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + sideAdjustment[0] + sideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + sideAdjustment[2] + sideAdjustment[3];

    size = [objectSizeXAdjusted, objectSizeYAdjusted, height];

    function sideX(side) = 0.5 * (sideAdjustment[1] - sideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sideAdjustment[3] - sideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    difference(){
        translate([0.5*(sideAdjustment[1] - sideAdjustment[0]), 0.5*(sideAdjustment[3] - sideAdjustment[2]), 0]){
            if(baseRounding == "none"){
                cube(
                    size = size, 
                    center = true
                );    
            }
            else if(baseRounding == "all"){
                mb_roundedcube_simple(
                    size = size, 
                    center = true, 
                    radius = roundingRadius, 
                    resolution = roundingResolution
                );    
            }
            else{
                mb_roundedcube(
                    size = size, 
                    center = true, 
                    radius = roundingRadius, 
                    apply_to = baseRounding,
                    resolution = roundingResolution
                );
            }
        }

        /*
        * Pit
        */
        if(withPit){
            pitSizeX = objectSize[0] - pitWallThickness[0] - pitWallThickness[1];
            pitSizeY = objectSize[1] - pitWallThickness[2] - pitWallThickness[3];
            echo(pitSizeX = pitSizeX, pitSizeY = pitSizeY, pitDepth = pitDepth, pitWallThickness = pitWallThickness);

            translate([0.5*(pitWallThickness[1] - pitWallThickness[0]), 0.5*(pitWallThickness[3] - pitWallThickness[2]), 0.5 * (height - pitDepth) + 0.5 * cutOffset])
                cube([pitSizeX, pitSizeY, pitDepth + cutOffset], center = true);
        
            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                gap = pitWallGaps[gapIndex];
                if(gap[0] < 2){
                    translate([sideX(gap[0]), -0.5 * (gap[2] - gap[1]), 0.5*(height - pitDepth + cutOffset)])
                        cube([2*pitWallThickness[gap[0]]*cutMultiplier, pitSizeY - gap[1] - gap[2], pitDepth + cutOffset], center = true);
                }  
                else{
                    translate([-0.5 * (gap[2] - gap[1]), sideY(gap[0] - 2), 0.5*(height - pitDepth + cutOffset)])
                        cube([pitSizeX - gap[1] - gap[2] , 2*pitWallThickness[gap[0]]*cutMultiplier, pitDepth + cutOffset], center = true);     
                } 
            }
        }
    }
}