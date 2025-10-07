/**
* Machine Blocks
* https://machineblocks.com/examples/boxes-enclosures
*
* Water Tank 8x12
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

/* [Appearance] */

//Grid Size X-direction
gridX = 8; 
//Grid Size Y-direction
gridY = 12; 
//Number of layers
baseLayers = 24;
//Floor layers
floorLayers = 3;

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

union(){
    machineblock(
        size = [gridX, gridY, floorLayers], 
        studs = false,
        align="ccs",

        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender
    );


    machineblock(
        size = [gridX, 1, baseLayers - floorLayers], 
        baseCutoutType = "none",
        offset = [0, -0.5 * (gridY - 1), floorLayers],
        align="ccs",

        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender
    ); 


    machineblock(
        size = [gridX, 1, baseLayers - floorLayers], 
        baseCutoutType = "none", 
        offset = [0, 0.5 * (gridY - 1), floorLayers],
        align="ccs",

        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender
    );


    machineblock(
        size = [1, gridY-2, baseLayers - floorLayers], 
        baseCutoutType = "none", 
        offset = [-0.5 * (gridX - 1), 0, floorLayers],
        align="ccs", 

        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = [baseSideAdjustment, baseSideAdjustment, -baseSideAdjustment, -baseSideAdjustment],
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender
    );


    machineblock(
        size = [1, gridY-2, baseLayers - floorLayers], 
        baseCutoutType = "none", 
        offset = [0.5 * (gridX - 1), 0, floorLayers],
        align="ccs", 

        scale = scale,
        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = [baseSideAdjustment, baseSideAdjustment, -baseSideAdjustment, -baseSideAdjustment],
        baseWallThicknessAdjustment = baseWallThicknessAdjustment,
        baseClampThickness = baseClampThickness,
        tubeXDiameterAdjustment = tubeXDiameterAdjustment,
        tubeYDiameterAdjustment = tubeYDiameterAdjustment,
        tubeZDiameterAdjustment = tubeZDiameterAdjustment,
        holeXDiameterAdjustment = holeXDiameterAdjustment,
        holeYDiameterAdjustment = holeYDiameterAdjustment,
        holeZDiameterAdjustment = holeZDiameterAdjustment,
        pinDiameterAdjustment = pinDiameterAdjustment,
        studDiameterAdjustment = studDiameterAdjustment,
        studCutoutAdjustment = studCutoutAdjustment,
        previewRender = previewRender
    ); 
}