use <./block.scad>;

module mb_duo(
    brick1GridX = 3,
    brick1GridY = 1,
    brick1OffsetY = 1,
    brick2GridX = 1,
    brick2GridY = 3,
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
            grid=[brick1GridX, brick1GridY], 
            gridOffset=[0, brick1OffsetY - 0.5*(brick2GridY-brick1GridY), 0],
            wallGapsX=[[brick2OffsetX, 2, brick2GridX]],
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
            grid=[brick2GridX, brick2GridY], 
            gridOffset=[brick2OffsetX - 0.5*(brick1GridX-brick2GridX), 0, 0],
            wallGapsY=[[brick1OffsetY, 2, brick1GridY]],
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