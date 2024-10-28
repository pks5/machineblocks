include <../../lib/block.scad>;

module calib_base(type, numberOfSamples, valueStart, valueStep, labelSize, font, fontSize, vOffset){
    block(
        grid = [2* numberOfSamples + 1, 1],
        baseCutoutType = "none",
        knobs = false,
        gridOffset=[0,vOffset,0],
        baseSideAdjustment = 0,
        baseHeight = 1.6
    );

    block(
        grid = [labelSize, 1],
        baseCutoutType = "none",
        knobs = false,
        gridOffset=[0,vOffset + 1,0],
        baseSideAdjustment = 0,
        baseHeight = 1.6,
        text=type,
        textFont = font,
        textSize=fontSize,
        textSide=5,
        textDepth=0.4
    );

    for(i = [0 : numberOfSamples-1]){

        block(
            grid = [1, 1],
            baseCutoutType = "none",
            knobs = false,
            gridOffset=[2* (i - floor(0.5 * numberOfSamples)),vOffset -1,0],
            baseSideAdjustment = 0,
            baseHeight = 1.6,
            text = str(valueStart + i * valueStep),
            textFont = font,
            textSize=fontSize,
            textSide=5,
            textDepth=0.4
        );
    }
}

module calib_knobSize(numberOfSamples, valueStart, valueStep, vOffset){
    for(i = [0 : numberOfSamples-1]){
        block(
            baseCutoutType = "none",
            baseHeight = 0.8,
            knobSize = valueStart + i * valueStep,
            gridOffset=[2* (i - floor(0.5 * numberOfSamples)),vOffset,0.5]
        );
    }
}

module calib_wallThickness(numberOfSamples, valueStart, valueStep, vOffset){
    for(i = [0 : numberOfSamples-1]){
        rotate([180,0,0])
            block(
                grid = [1, 1],
                knobs = false,
                gridOffset=[2* (i - floor(0.5 * numberOfSamples)),-vOffset,-1.5],
                wallThickness=valueStart + i * valueStep,
                topPlateHelpers=false
            );
    }
}

module calib_tubeZSize(numberOfSamples, valueStart, valueStep, vOffset){
    for(i = [0 : numberOfSamples-1]){
        rotate([180,0,0])
            block(
                grid=[2,2],
                tubeZSize = valueStart + i * valueStep,
                gridOffset=[2* (i - floor(0.5 * numberOfSamples)),-vOffset,-1.5],
                knobs=false,
                baseSideAdjustment=-4,
                stabilizerGrid=false,
                topPlateHelpers=false
            );
    }
}