/**
 * MachineBlocks
 * https://machineblocks.com/examples/angle
 *
 * Angle 6x6x4
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Imports
use <../../lib/block.scad>;
include <../../config/presets.scad>;


/* [Size] */

// Both bricks' size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 6; // [1:32]
// First brick's size in Y-direction specified as multiple of an 1x1 brick.
brick1SizeY = 6; // [1:32]
// Second brick's size in Y-direction specified as multiple of an 1x1 brick.
brick2SizeY = 4; // [1:32]
// First brick's height specified as number of layers. Each layer has the height of one plate.
brick1BaseLayers = 3; // [1:24]
// Second brick's base height in mm
brick2BaseHeight = 1.8;

/* [Base] */

// Type of cut-out on the underside.
brick1BaseCutoutType = "classic"; // [none, classic]

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Knobs] */

// Whether first brick should have knobs.
brick1Knobs = true;
// Type of first brick's knobs
brick1KnobType = "solid"; // [solid, hollow]
// Whether second brick should have knobs.
brick2Knobs = true;
// Type of second brick's knobs
brick2KnobType = "hollow"; // [solid, hollow]

/* [Render] */

// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]

/* [Override Config] */
    overrideConfig=false;
    overrideUnitMbu = 1.6;
    overrideUnitGrid = [5, 2];
    overrideScale = 1.0;
    overrideBaseHeightAdjustment = 0.0;
    overrideBaseSideAdjustment = -0.1;
    overrideBaseWallThicknessAdjustment = -0.1;
    overrideBaseClampThickness = 0.1;
    overrideTubeXDiameterAdjustment = -0.1;
    overrideTubeYDiameterAdjustment = -0.1;
    overrideTubeZDiameterAdjustment = -0.1;
    overrideHoleXDiameterAdjustment = 0.3;
    overrideHoleYDiameterAdjustment = 0.3;
    overrideHoleZDiameterAdjustment = 0.3;
    overridePinDiameterAdjustment = 0.0;
    overrideStudDiameterAdjustment = 0.2;
    overrideStudCutoutAdjustment = [0, 0.2];
    overridePreviewRender = true;
    overridePreviewQuality = 0.5;
    overrideRoundingResolution = 64;


/* [Hidden] */

// Grid Size XY
gridSizeXY = 8.0;
// Grid Size Z
gridSizeZ = 3.2;

// Generate the block


  machineblock(size = [ brickSizeX, brick1SizeY,brick1BaseLayers ],
        baseCutoutType = brick1BaseCutoutType,
        baseColor = baseColor,

        connectors = assemblyMode == "merged" ? false : [[ 2, 0 ] ],
        connectorSideTolerance = assemblyMode == "merged" ? 0 : 0.1,
        studs = brick1Knobs,
        studType = brick1KnobType,

        baseSideAdjustment =
            [ baseSideAdjustment, baseSideAdjustment, assemblyMode == "merged" ? 0 : baseSideAdjustment, baseSideAdjustment ],
        
        unitMbu=overrideConfig ? overrideUnitMbu : unitMbu,
    unitGrid=overrideConfig ? overrideUnitGrid : unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
  ){

    machineblock(
          rotation = [assemblyMode == "unassembled" ? 0 : 90,0,0],
          offset = [assemblyMode == "unassembled" ? 2.5 : 0, 0,0],
    
          size = [ brickSizeX, brick2SizeY, 1 ],
          baseHeight = brick2BaseHeight,
          baseCutoutType = "none",
          baseColor = baseColor,

          studs = brick2Knobs,
          studType = brick2KnobType,
          connectors = assemblyMode == "merged" ? false : [ [ 2, 2 ] ],
          connectorHeight = brick1BaseLayers * gridSizeZ,
          

          baseSideAdjustment =
            [ baseSideAdjustment, baseSideAdjustment, 0, baseSideAdjustment ],

          unitMbu=overrideConfig ? overrideUnitMbu : unitMbu,
    unitGrid=overrideConfig ? overrideUnitGrid : unitGrid,
    scale=overrideConfig ? overrideScale : scale,
    baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
    baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
    baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,
    tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
    tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
    tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,
    holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
    holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
    holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,
    pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,
    studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
    studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,
    previewRender=overrideConfig ? overridePreviewRender : previewRender,
    previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,
    baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
    pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution
    );
  }




    
 