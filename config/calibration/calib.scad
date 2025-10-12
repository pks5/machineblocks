include <../../lib/block.scad>;

calibBaseHeight = 1;

function mb_round1(x) = round(x*10)/10;

function mb_replace_zero_dot_all(s, i=0) =
    (i >= len(s)-1) ? s :
    (s[i] == "0" && s[i+1] == ".")
        ? str(mb_prefix_upto(s, i), ".", mb_replace_zero_dot_all(mb_suffix_from(s, i+2), 0))
        : mb_replace_zero_dot_all(s, i+1);

// Hilfsfunktion: s[0 .. k-1] als String
function mb_prefix_upto(s, k, i=0) =
    (i >= k) ? "" : str(s[i], mb_prefix_upto(s, k, i+1));

function mb_suffix_from(s, k, i=0) =
    (k+i >= len(s)) ? "" : str(s[k+i], mb_suffix_from(s, k, i+1));

module calib_base(type, numberOfSamples, valueStart, valueStep, labelSize, font, fontSize, vOffset){
    machineblock(
        align = "ccs",
        size = [2* numberOfSamples + 1, 1, 1],
        baseCutoutType = "none",
        studs = false,
        offset=[0,vOffset,0],
        baseSideAdjustment = 0,
        baseHeight = calibBaseHeight
    );

    machineblock(
        align = "ccs",
        size = [labelSize, 1, 1],
        baseCutoutType = "none",
        studs = false,
        offset=[0,vOffset + 1,0],
        baseSideAdjustment = 0,
        baseHeight = calibBaseHeight,
        text=type,
        textFont = font,
        textSize=fontSize,
        textSide=5,
        textDepth=0.2
    );

    for(i = [0 : numberOfSamples-1]){

        machineblock(
            align = "ccs",
            size = [1, 1,1],
            baseCutoutType = "none",
            studs = false,
            offset=[2* (i - floor(0.5 * numberOfSamples)),vOffset -1,0],
            baseSideAdjustment = 0,
            baseHeight = calibBaseHeight,
            text = mb_replace_zero_dot_all(str(mb_round1(valueStart + i * valueStep))),
            textFont = font,
            textSize=fontSize,
            textSide=5,
            textDepth=0.2
        );
    }
}

module calib_studDiameterAdjustment(numberOfSamples, valueStart, valueStep, vOffset){
    for(i = [0 : numberOfSamples-1]){
        machineblock(
            align = "ccs",
            baseCutoutType = "none",
            baseHeight = 0.8,
            studDiameterAdjustment = mb_round1(valueStart + i * valueStep),
            offset=[2* (i - floor(0.5 * numberOfSamples)),vOffset, calibBaseHeight / 3.2]
        );
    }
}

module calib_baseWallThicknessAdjustment(numberOfSamples, valueStart, valueStep, vOffset){
    for(i = [0 : numberOfSamples-1]){
        rotate([180,0,0])
            machineblock(
                align = "ccs",
                size = [1, 1, 1],
                studs = false,
                offset=[2* (i - floor(0.5 * numberOfSamples)),-vOffset,-1 - (calibBaseHeight / 3.2)],
                baseWallThicknessAdjustment=mb_round1(valueStart + i * valueStep),
                topPlateHelpers=false
            );
    }
}

module calib_tubeZDiameterAdjustment(numberOfSamples, valueStart, valueStep, vOffset){
    for(i = [0 : numberOfSamples-1]){
        rotate([180,0,0])
            machineblock(
                align = "ccs",
                size=[2,2,1],
                tubeZDiameterAdjustment = mb_round1(valueStart + i * valueStep),
                offset=[2* (i - floor(0.5 * numberOfSamples)),-vOffset,-1 - (calibBaseHeight / 3.2)],
                studs=false,
                baseSideAdjustment=-4,
                stabilizerGrid=false,
                topPlateHelpers=false
            );
    }
}

module calib_pinDiameterAdjustment(numberOfSamples, valueStart, valueStep, vOffset){
    for(i = [0 : numberOfSamples-1]){
        rotate([180,0,0])
            machineblock(
                align = "ccs",
                size=[2,1,1],
                pinDiameterAdjustment = mb_round1(valueStart + i * valueStep),
                offset=[2* (i - floor(0.5 * numberOfSamples)),-vOffset,-1 - (calibBaseHeight / 3.2)],
                studs=false,
                baseSideAdjustment=-2,
                stabilizerGrid=false,
                topPlateHelpers=false
            );
    }
}