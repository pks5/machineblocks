/**
 * MachineBlocks
 * https://machineblocks.com/examples/classic-bricks
 *
 * Centered Plate 4x4
 * Copyright (c) 2022 - 2024 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

// Include the library
use <../../lib/block.scad>;
use <../../lib/connectors.scad>;

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 3; // [1:32]
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeVerticalY = 2; // [1:32]

/* [Appearance] */

// Type of cut-out on the underside.
baseCutoutType = "none"; // [none, classic]
// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "technic"; // [classic, technic]

/* [Quality] */

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // [16:8:128]

/* [Calibration] */

// Adjustment of the height (mm)
baseHeightAdjustment = 0.0;
// Adjustment of each side (mm)
baseSideAdjustment = -0.1;
// Diameter of the knobs (mm)
knobSize = 5.0;
// Thickness of the walls (mm)
wallThickness = 1.5;
// Diameter of the Z-Tubes (mm)
tubeZSize = 6.4;

// GridXY Size
gridSizeXY = 8.0;

// Vertical plate height
connectorDepth = 1.4;

// Grid Size Z
connectorHeight = 3.2;
connectorSize = 4;
connectorDepthTolerance = 0.2;
connectorSideTolerance = 0.1;

assembled = false;

//translate([0,0,-8])
//rotate([90,0,0])
union()
{
  block(grid = [ brickSizeX, brickSizeY ],

        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        knobRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution,

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment = baseSideAdjustment,
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize);

  conSize = connectorSize - 2*connectorSideTolerance;
  conDepth = connectorDepth - connectorSideTolerance;

  mb_connectors(0,
                [ brickSizeX, brickSizeY ],
                connectorHeight,
                conSize,
                conDepth,
                gridSizeXY);

  mb_connectors(1,
                [ brickSizeX, brickSizeY ],
                connectorHeight,
                conSize,
                conDepth,
                gridSizeXY);

  mb_connectors(2,
                [ brickSizeX, brickSizeY ],
                connectorHeight,
                conSize,
                conDepth,
                gridSizeXY);

  mb_connectors(3,
                [ brickSizeX, brickSizeY ],
                connectorHeight,
                conSize,
                conDepth,
                gridSizeXY);
}

translate([ 30, 0, 0 ])
difference()
{

  block(grid = [ brickSizeX, brickSizeVerticalY ],
        baseLayers = 3,
        baseCutoutType = baseCutoutType,
        knobs = knobs,
        knobType = knobType,

        previewQuality = previewQuality,
        baseRoundingResolution = roundingResolution,
        holeRoundingResolution = roundingResolution,
        knobRoundingResolution = roundingResolution,
        pillarRoundingResolution = roundingResolution,

        baseHeightAdjustment = baseHeightAdjustment,
        baseSideAdjustment =
          [ baseSideAdjustment, baseSideAdjustment, baseSideAdjustment, 0 ],
        knobSize = knobSize,
        wallThickness = wallThickness,
        tubeZSize = tubeZSize);

  mb_connector_grooves(side = 2,
                       grid = [ brickSizeX, brickSizeVerticalY ],
                       depth = connectorHeight + connectorDepthTolerance,
                       baseHeight = 3*3.2,
                       up=false,
                       size = connectorSize,
                       height = connectorDepth,
                       gs = gridSizeXY);
}