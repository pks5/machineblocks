use <roundedcube.scad>;

module base(
    objectSize, 
    height, 
    sideAdjustment, 
    baseRounding, 
    roundingRadius, 
    roundingResolution,
    withPit,
    pitWallThickness,
    pitDepth
){
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + sideAdjustment[0] + sideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + sideAdjustment[2] + sideAdjustment[3];

    size = [objectSizeXAdjusted, objectSizeYAdjusted, height];

    difference(){
        translate([0.5*(sideAdjustment[1] - sideAdjustment[0]), 0.5*(sideAdjustment[3] - sideAdjustment[2]), 0]){
            if(baseRounding == "none"){
                cube(
                    size = size, 
                    center = true
                );    
            }
            else if(baseRounding == "all"){
                roundedcube_simple(
                    size = size, 
                    center = true, 
                    radius = roundingRadius, 
                    resolution = roundingResolution
                );    
            }
            else{
                roundedcube(
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
            pWallThickness = pitWallThickness[0] == undef 
                ? [pitWallThickness, pitWallThickness, pitWallThickness, pitWallThickness] 
                : (len(pitWallThickness) == 2 ? [pitWallThickness[0], pitWallThickness[0], pitWallThickness[1], pitWallThickness[1]] : pitWallThickness);


            pitSizeX = objectSize[0] - pWallThickness[0] - pWallThickness[1];
            pitSizeY = objectSize[1] - pWallThickness[2] - pWallThickness[3];
            echo(pitSizeX = pitSizeX, pitSizeY = pitSizeY, pitDepth = pitDepth, pitWallThickness = pWallThickness);

            translate([0.5*(pWallThickness[1] - pWallThickness[0]), 0.5*(pWallThickness[3] - pWallThickness[2]), 0.5 * (height - pitDepth) + 0.5 * cutOffset])
                cube([pitSizeX, pitSizeY, pitDepth + cutOffset], center = true);
        }
    }
}