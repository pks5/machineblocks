use <shapes.scad>;



module mb_slant_prism(l, w, h){
    translate([-0.5*l, -0.5*w, -0.5*h])
       polyhedron(
               points=[[0,0,h], [l,0,h], [l,w,h], [0,w,h], [0,w,0], [0,0,0]],
               faces=[[1,2,4,5],[3,2,1,0],[5,4,3,0],[0,1,5],[2,3,4]]
               );
}

module mb_base_cutout(
    grid,
    baseSideLength,
    objectSize,
    baseHeight,
    wallThickness,
    topPlateHeight,
    baseClampHeight,
    baseClampThickness,
    withPit,
    pitDepth,
    slanting,
    slantingLowerHeight
){
    baseClampWallThickness = wallThickness + baseClampThickness;

    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    slantingX = baseSideLength * slanting[0] - (slanting[0] >= grid[0] ? wallThickness : 0) + cutTolerance;

    difference(){
        union(){
            /*
            * Bottom Hole
            */
            color([0.953, 0.612, 0.071]) //f39c12
            translate([0, 0, 0.5*(baseClampHeight - (withPit ? pitDepth : 0) - topPlateHeight) ])
                cube([objectSize[0] - 2*wallThickness, objectSize[1] - 2*wallThickness, baseHeight - (withPit ? pitDepth : 0) - topPlateHeight - baseClampHeight], center = true);    

            /*
            * Clamp Skirt
            */
            color([0.902, 0.494, 0.133]) //e67e22
            translate([0, 0, 0.5*(baseClampHeight - baseHeight)])
                cube([objectSize[0] - 2 * baseClampWallThickness, objectSize[1] - 2 * baseClampWallThickness, baseClampHeight * cutMultiplier], center = true);
        }

        /*
        * Slanting
        */
        if(slanting[0] > 0){
            translate([-0.5 * (objectSize[0] - 2*wallThickness - slantingX + cutTolerance), 0, 0.5*(slantingLowerHeight + cutTolerance)])
                mb_slant_prism(slantingX, objectSize[1] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance);
        }
    }
    

}

module mb_base(
    grid,
    baseSideLength,
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
    slanting,
    slantingLowerHeight
){
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    //Object Size     
    objectSizeX = baseSideLength * grid[0];
    objectSizeY = baseSideLength * grid[1];

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + sideAdjustment[0] + sideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + sideAdjustment[2] + sideAdjustment[3];

    slantingX = baseSideLength * slanting[0] + sideAdjustment[0] + (slanting[0] >= grid[0] ? sideAdjustment[1] : 0) + cutTolerance;

    size = [objectSizeXAdjusted, objectSizeYAdjusted, height];

    function posX(a) = (a - offsetX) * baseSideLength;
    function posY(b) = (b - offsetY) * baseSideLength;

    function sideX(side) = 0.5 * (sideAdjustment[1] - sideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sideAdjustment[3] - sideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    difference(){
        translate([0.5*(sideAdjustment[1] - sideAdjustment[0]), 0.5*(sideAdjustment[3] - sideAdjustment[2]), 0]){
            difference(){
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

                /*
                * Slanting
                */
                if(slanting[0] > 0){
                    translate([-0.5 * (objectSizeXAdjusted - slantingX + cutTolerance), 0, 0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(slantingX, objectSizeYAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance);
                }
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