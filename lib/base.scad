use <shapes.scad>;



module mb_slant_prism(side, l, w, h, inv){
    invRot = inv ? 180 : 0;
    rotations = [[invRot, 0, 0], [invRot, 0, 180], [invRot, 0, 90], [invRot, 0, 270]];

    rotate(rotations[side])
        translate([-0.5*l, -0.5*w, -0.5 * h])
            polyhedron(
                    points=[[0,0,h], [l,0,h], [l,w,h], [0,w,h], [0,w,0], [0,0,0]],
                    faces=[[1,2,4,5],[3,2,1,0],[5,4,3,0],[0,1,5],[2,3,4]]
                    );
}

module mb_base_cutout(
    grid,
    baseSideLength,
    baseHeight,
    sideAdjustment, 
    roundingRadius, 
    roundingResolution,
    wallThickness,
    topPlateHeight,
    baseClampHeight,
    baseClampThickness,
    pit,
    pitDepth,
    slanting,
    slantingLowerHeight
){
    baseClampWallThickness = wallThickness + baseClampThickness;

    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    objectSizeX = baseSideLength * (grid[0] + slanting(slanting[0]) + slanting(slanting[1]));
    objectSizeY = baseSideLength * (grid[1] + slanting(slanting[2]) + slanting(slanting[3]));
    objectSize=[objectSizeX, objectSizeY];

    offsetX = -0.5* slanting(slanting[0]) * baseSideLength;
    offsetY = -0.5* slanting(slanting[2]) * baseSideLength;

    echo(slanting=slanting, offsetY = offsetY);

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + sideAdjustment[0] + sideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + sideAdjustment[2] + sideAdjustment[3];

    function slantingSize(side) = (slanting[side] >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (baseSideLength * slanting[side] + sideAdjustment[side])) + cutTolerance;
    function slanting(s) = s > 0 ? 0 : s;

    difference(){
        union(){
            translate([offsetX, offsetY, 0]){ 
                /*
                * Bottom Hole
                */
                color([0.953, 0.612, 0.071]) //f39c12
                translate([0, 0, 0.5*(baseClampHeight - (pit ? pitDepth : 0) - topPlateHeight) ])
                    mb_rounded_block(
                        size = [objectSize[0] - 2*wallThickness, objectSize[1] - 2*wallThickness, baseHeight - (pit ? pitDepth : 0) - topPlateHeight - baseClampHeight], 
                        center = true, 
                        radius=roundingRadius == 0 ? 0 : [0,0,roundingRadius], 
                        resolution=roundingResolution
                    );    

                /*
                * Clamp Skirt
                */
                color([0.902, 0.494, 0.133]) //e67e22
                translate([0, 0, 0.5*(baseClampHeight - baseHeight)])
                    mb_rounded_block(
                        size = [objectSize[0] - 2 * baseClampWallThickness, objectSize[1] - 2 * baseClampWallThickness, baseClampHeight * cutMultiplier], 
                        center = true, 
                        radius=roundingRadius == 0 ? 0 : [0,0,roundingRadius], 
                        resolution=roundingResolution
                    );
            }
        }

        /*
        * Slanting
        */
        if(slanting[0] > 0){
            slanting0 = slantingSize(0);
            translate([-0.5 * (objectSize[0] - 2*wallThickness - slanting0 + cutTolerance), 0, 0.5*(slantingLowerHeight + cutTolerance)])
                mb_slant_prism(0, slanting0, objectSize[1] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
        }

        if(slanting[1] > 0){
            slanting1 = slantingSize(1);
            translate([0.5 * (objectSize[0] - 2*wallThickness - slanting1 + cutTolerance), 0, 0.5*(slantingLowerHeight + cutTolerance)])
                mb_slant_prism(1, slanting1, objectSize[1] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
        }

        if(slanting[2] > 0){
            slanting2 = slantingSize(2);
            translate([0, -0.5 * (objectSize[1] - 2*wallThickness - slanting2 + cutTolerance), 0.5*(slantingLowerHeight + cutTolerance)])
                mb_slant_prism(2, slanting2, objectSize[0] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
        }
        
        if(slanting[3] > 0){
            slanting3 = slantingSize(3);
            translate([0, 0.5 * (objectSize[1] - 2*wallThickness - slanting3 + cutTolerance), 0.5*(slantingLowerHeight + cutTolerance)])
                mb_slant_prism(3, slanting3, objectSize[0] * cutMultiplier, baseHeight - slantingLowerHeight + cutTolerance, false);
        }
    }
    

}

module mb_base(
    grid,
    baseSideLength,
    objectSize, 
    height, 
    sideAdjustment, 
    roundingRadius, 
    roundingRadiusZ,
    roundingResolution,
    pit,
    pitRoundingRadius,
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

    size = [objectSizeXAdjusted, objectSizeYAdjusted, height];

    function sideX(side) = 0.5 * (sideAdjustment[1] - sideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sideAdjustment[3] - sideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    function slantingSize(side) = (abs(slanting[side]) >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (baseSideLength * abs(slanting[side]) + sideAdjustment[side])) + cutTolerance;

    difference(){
        translate([0.5*(sideAdjustment[1] - sideAdjustment[0]), 0.5*(sideAdjustment[3] - sideAdjustment[2]), 0]){
            difference(){
                mb_rounded_block(
                    size = size, 
                    center=true, 
                    resolution = roundingResolution,
                    radius = roundingRadius
                );
                
                /*
                * Slanting
                */
                if(slanting[0] != 0){
                    slanting0 = slantingSize(0);
                    translate([-0.5 * (objectSizeXAdjusted - slanting0 + cutTolerance), 0, sign(slanting[0])*0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(0, slanting0, objectSizeYAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[0] < 0);
                }

                if(slanting[1] != 0){
                    slanting1 = slantingSize(1);
                    translate([0.5 * (objectSizeXAdjusted - slanting1 + cutTolerance), 0, sign(slanting[1])*0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(1, slanting1, objectSizeYAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[1] < 0);
                }

                if(slanting[2] != 0){
                    slanting2 = slantingSize(2);
                    translate([0, -0.5 * (objectSizeYAdjusted - slanting2 + cutTolerance), sign(slanting[2])*0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(2, slanting2, objectSizeXAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[2] < 0);
                }

                if(slanting[3] != 0){
                    slanting3 = slantingSize(3);
                    translate([0, 0.5 * (objectSizeYAdjusted - slanting3 + cutTolerance), sign(slanting[3])*0.5*(slantingLowerHeight + cutTolerance)])
                        mb_slant_prism(3, slanting3, objectSizeXAdjusted * cutMultiplier, height - slantingLowerHeight + cutTolerance, slanting[3] < 0);
                }
            }
        }

        /*
        * Pit
        */
        if(pit){
            pitSizeX = objectSize[0] - (pitWallThickness[0] + pitWallThickness[1]) * baseSideLength;
            pitSizeY = objectSize[1] - (pitWallThickness[2] + pitWallThickness[3]) * baseSideLength;
            echo(pitSizeX = pitSizeX, pitSizeY = pitSizeY, pitDepth = pitDepth, pitWallThickness = pitWallThickness);

            translate([0.5 * (pitWallThickness[1] - pitWallThickness[0]) * baseSideLength, 0.5 * (pitWallThickness[3] - pitWallThickness[2]) * baseSideLength, 0.5 * (height - pitDepth) + 0.5 * cutOffset])
                mb_rounded_block(size = [pitSizeX, pitSizeY, pitDepth + cutOffset], radius=[0,0,pitRoundingRadius], resolution=roundingResolution, center = true);
        
            for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                gap = pitWallGaps[gapIndex];
                if(gap[0] < 2){
                    translate([sideX(gap[0]), -0.5 * (gap[2] - gap[1]), 0.5*(height - pitDepth + cutOffset)])
                        cube([2 * pitWallThickness[gap[0]] * baseSideLength * cutMultiplier, pitSizeY - gap[1] - gap[2], pitDepth + cutOffset], center = true);
                }  
                else{
                    translate([-0.5 * (gap[2] - gap[1]), sideY(gap[0] - 2), 0.5*(height - pitDepth + cutOffset)])
                        cube([pitSizeX - gap[1] - gap[2] , 2 * pitWallThickness[gap[0]] * baseSideLength * cutMultiplier, pitDepth + cutOffset], center = true);     
                } 
            }
        }
    }
}