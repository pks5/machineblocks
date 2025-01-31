use <shapes.scad>;
use <connectors.scad>;


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
    gridSizeXY,
    baseHeight,
    baseSideAdjustment, 
    roundingRadius, 
    roundingResolution,
    wallThickness,
    topPlateHeight,
    baseClampHeight,
    baseClampThickness,
    baseClampOffset,
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

    objectSizeX = gridSizeXY * (grid[0] + (slanting != false ? slanting(slanting[0]) + slanting(slanting[1]) : 0)); //todo support slanting undef
    objectSizeY = gridSizeXY * (grid[1] + (slanting != false ? slanting(slanting[2]) + slanting(slanting[3]) : 0));
    objectSize=[objectSizeX, objectSizeY];

    offsetX =  0.5*(slanting != false ? -slanting(slanting[0]) + slanting(slanting[1]) : 0) * gridSizeXY;
    offsetY =  0.5*(slanting != false ? -slanting(slanting[2]) + slanting(slanting[3]) : 0) * gridSizeXY;

    echo(slanting=slanting, offsetX = offsetX, offsetY = offsetY, baseHeight=baseHeight, topPlateHeight = topPlateHeight, baseClampOffset=baseClampOffset);

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + baseSideAdjustment[0] + baseSideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + baseSideAdjustment[2] + baseSideAdjustment[3];

    function slantingSize(side) = (slanting[side] >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (gridSizeXY * slanting[side] + baseSideAdjustment[side])) + cutTolerance;
    function slanting(s) = s > 0 ? 0 : s;

    translate([offsetX, offsetY, 0]){ 
        difference(){
            union(){
                /*
                * Bottom Hole
                */
                color([0.953, 0.612, 0.071]) //f39c12
                translate([0, 0, 0.5*(baseClampOffset + baseClampHeight - (pit ? pitDepth : 0) - topPlateHeight) ])
                    mb_rounded_block(
                        size = [objectSize[0] - 2*wallThickness, objectSize[1] - 2*wallThickness, baseHeight - (pit ? pitDepth : 0) - topPlateHeight - baseClampHeight - baseClampOffset], 
                        center = true, 
                        radius=roundingRadius == 0 ? 0 : [0,0,roundingRadius], 
                        resolution=roundingResolution
                    );    

                /*
                * Clamp Skirt
                */
                color([0.902, 0.494, 0.133]) //e67e22
                translate([0, 0, baseClampOffset + 0.5*(baseClampHeight - baseHeight)])
                    mb_rounded_block(
                        size = [objectSize[0] - 2 * baseClampWallThickness, objectSize[1] - 2 * baseClampWallThickness, baseClampHeight * cutMultiplier], 
                        center = true, 
                        radius=roundingRadius == 0 ? 0 : [0,0,roundingRadius], 
                        resolution=roundingResolution
                    );

                /*
                * Clamp Offset
                */
                if(baseClampOffset > 0){
                    color([0.902, 0.494, 0.133]) //e67e22
                    translate([0, 0, 0.5*(baseClampOffset - baseHeight - cutOffset)])
                        mb_rounded_block(
                            size = [objectSize[0] - 2 * wallThickness, objectSize[1] - 2 * wallThickness, baseClampOffset + cutOffset], 
                            center = true, 
                            radius=roundingRadius == 0 ? 0 : [0,0,roundingRadius], 
                            resolution=roundingResolution
                        );
                }
            }

            /*
            * Slanting
            */
            if(slanting != false){
                
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
    } 

}

module mb_base(
    grid,
    gridSizeXY,
    objectSize, 
    height, 
    baseSideAdjustment, 
    roundingRadius, 
    roundingRadiusZ,
    roundingResolution,
    pit,
    pitRoundingRadius,
    pitWallThickness,
    pitDepth,
    pitWallGaps,
    slanting,
    slantingLowerHeight,
    connectors = [],
    connectorHeight,
    connectorDepth,
    connectorSize,
    connectorDepthTolerance,
    connectorSideTolerance
){
    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    //Object Size     
    objectSizeX = gridSizeXY * grid[0];
    objectSizeY = gridSizeXY * grid[1];

    //Object Size Adjusted      
    objectSizeXAdjusted = objectSize[0] + baseSideAdjustment[0] + baseSideAdjustment[1];
    objectSizeYAdjusted = objectSize[1] + baseSideAdjustment[2] + baseSideAdjustment[3];

    size = [objectSizeXAdjusted, objectSizeYAdjusted, height];

    function sideX(side) = 0.5 * (baseSideAdjustment[1] - baseSideAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (baseSideAdjustment[3] - baseSideAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;

    function slantingSize(side) = (abs(slanting[side]) >= grid[side < 2 ? 0 : 1] ? (side < 2 ? objectSizeXAdjusted : objectSizeYAdjusted) : (gridSizeXY * abs(slanting[side]) + baseSideAdjustment[side])) + cutTolerance;

    union(){
        difference(){
            translate([0.5*(baseSideAdjustment[1] - baseSideAdjustment[0]), 0.5*(baseSideAdjustment[3] - baseSideAdjustment[2]), 0]){
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
                    if(slanting != false){
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
            }

            /*
            * Pit
            */
            if(pit){
                pitSizeX = objectSize[0] - (pitWallThickness[0] + pitWallThickness[1]) * gridSizeXY;
                pitSizeY = objectSize[1] - (pitWallThickness[2] + pitWallThickness[3]) * gridSizeXY;
                echo(pitSizeX = pitSizeX, pitSizeY = pitSizeY, pitDepth = pitDepth, pitWallThickness = pitWallThickness);

                translate([0.5 * (pitWallThickness[0] - pitWallThickness[1]) * gridSizeXY, 0.5 * (pitWallThickness[2] - pitWallThickness[3]) * gridSizeXY, 0.5 * (height - pitDepth) + 0.5 * cutOffset])
                    mb_rounded_block(size = [pitSizeX, pitSizeY, pitDepth + cutOffset], radius=[0,0,pitRoundingRadius], resolution=roundingResolution, center = true);
            
                for (gapIndex = [ 0 : 1 : len(pitWallGaps)-1 ]){
                    gap = pitWallGaps[gapIndex];
                    if(gap[0] < 2){
                        translate([sideX(gap[0]), -0.5 * (gap[2] - gap[1]) * gridSizeXY, 0.5*(height - pitDepth + cutOffset)])
                            cube([2 * pitWallThickness[gap[0]] * gridSizeXY * cutMultiplier, pitSizeY - (gap[1] + gap[2]) * gridSizeXY, pitDepth + cutOffset], center = true);
                    }  
                    else{
                        translate([-0.5 * (gap[2] - gap[1]) * gridSizeXY, sideY(gap[0] - 2), 0.5*(height - pitDepth + cutOffset)])
                            cube([pitSizeX - (gap[1] + gap[2]) * gridSizeXY , 2 * pitWallThickness[gap[0]] * gridSizeXY * cutMultiplier, pitDepth + cutOffset], center = true);     
                    } 
                }
            }

            for (con = [ 0 : 1 : len(connectors)-1 ]){
                if(connectors[con][1] == 1){
                    mb_connectors(side = connectors[con][0],
                            grid = grid,
                            height = (connectorHeight == 0 ? height : connectorHeight) + connectorDepthTolerance,
                            baseHeight = height,
                            inverse=true,
                            size = connectorSize,
                            depth = connectorDepth,
                            gs = gridSizeXY);
                }
                else if(connectors[con][1] > 1){
                    mb_connector_grooves(side = connectors[con][0],
                        grid = grid,
                        depth = (connectorHeight == 0 ? height : connectorHeight) + connectorDepthTolerance,
                        baseHeight = height,
                        inverse=connectors[con][1]==3,
                        size = connectorSize,
                        height = connectorDepth,
                        gs = gridSizeXY);
                }
            }

            
        }

    /*
        * Connectors
        */
        

        for (con = [ 0 : 1 : len(connectors)-1 ]){
            if(connectors[con][1] == 0){
                mb_connectors(side = connectors[con][0],
                        grid = grid,
                        height = (connectorHeight == 0 ? height : connectorHeight),
                        baseHeight = height,
                        inverse=connectors[con][1]==1,
                        size = connectorSize - 2*connectorSideTolerance,
                        depth = connectorDepth - connectorSideTolerance,
                        gs = gridSizeXY);
            }
        }
    }
}