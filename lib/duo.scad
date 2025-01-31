use <./block.scad>;

//DEPRECATED: WILL BE REMOVED

module mb_duo(
    brick1Grid = [3,1],
    brick1OffsetY = 1,
    
    brick2Grid = [1, 3],
    brick2OffsetX = 1,
    
    knobs = true,
    knobType = "classic",
    knobSize = 5.0,

    baseLayers = 3,
    baseHeightAdjustment = 0.0,
    baseSideAdjustment = -0.1,
    
    wallThickness = 1.5,
    tubeZSize = 6.4
){
    //Duo
    union(){
        block(
            grid=brick1Grid, 
            gridOffset=[0, brick1OffsetY - 0.5*(brick2Grid[1]-brick1Grid[1]), 0],
            wallGapsX=[[brick2OffsetX, 2, brick2Grid[0]]],
            baseLayers = baseLayers,
            baseHeightAdjustment = baseHeightAdjustment,
            baseSideAdjustment = baseSideAdjustment,
            knobs = knobs,
            knobType = knobType,
            knobSize = knobSize,
            wallThickness = wallThickness,
            tubeZSize = tubeZSize
        );

        block(
            grid=brick2Grid, 
            gridOffset=[brick2OffsetX - 0.5*(brick1Grid[0]-brick2Grid[0]), 0, 0],
            wallGapsY=[[brick1OffsetY, 2, brick1Grid[1]]],
            baseLayers = baseLayers,
            baseHeightAdjustment = baseHeightAdjustment,
            baseSideAdjustment = baseSideAdjustment,
            knobs = knobs,
            knobType = knobType,
            knobSize = knobSize,
            wallThickness = wallThickness,
            tubeZSize = tubeZSize
        );    
    }
}