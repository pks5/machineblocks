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
// Grid Size Z
gridSizeZ = 3.2;
// Vertical plate height
verticalPlateHeight = 1.8;

connectorSize = 4;
connectorCoverHeight = 0.4;
connectorDepthTolerance = 0.2;
connectorSideTolerance = 0.2;

assembled = false;

module
prism(l, w, h)
{
  translate([ -0.5 * l, -0.5 * w, -0.5 * h ]) polyhedron(points =
                                                           [
                                                             [ 0, 0, 0 ],
                                                             [ l, 0, 0 ],
                                                             [ l, w, 0 ],
                                                             [ 0, w, 0 ],
                                                             [ 0, w, h ],
                                                             [ l, w, h ]
                                                           ],
                                                         faces = [
                                                           [ 0, 1, 2, 3 ],
                                                           [ 5, 4, 3, 2 ],
                                                           [ 0, 4, 5, 1 ],
                                                           [ 0, 3, 4 ],
                                                           [ 5, 2, 1 ]
                                                         ]);
}

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

  for (i = [0:1:brickSizeX - 1]) {
    color([ 0.945, 0.769, 0.059 ]) // f1c40f
      translate([
        -(0.5 * brickSizeX - 0.5) * gridSizeXY + i * gridSizeXY,
        0.5 * brickSizeY * gridSizeXY + verticalPlateHeight -
          (connectorCoverHeight - 0.5 * connectorSideTolerance),
        0.5 *
        gridSizeZ
      ]) rotate([ 90, 90, 225 ]) prism(gridSizeZ, connectorSize - connectorSideTolerance, connectorSize - connectorSideTolerance);
  }
}

translate(assembled ? [0,0.5*brickSizeY * gridSizeXY,0.25 * (brickSizeY + brickSizeVerticalY) * gridSizeXY] : [ 0, 0.5 * (brickSizeY + brickSizeVerticalY + 0.5) * gridSizeXY, 0 ])
  rotate(assembled ? [0,0,0] : [ 90, 0, 0 ])
// union()
{
  difference()
  {

    rotate([ -90, 0, 0 ]) block(grid = [ brickSizeX, brickSizeVerticalY ],
                                baseHeight = verticalPlateHeight,
                                baseCutoutType = baseCutoutType,
                                knobs = knobs,
                                knobType = knobType,

                                previewQuality = previewQuality,
                                baseRoundingResolution = roundingResolution,
                                holeRoundingResolution = roundingResolution,
                                knobRoundingResolution = roundingResolution,
                                pillarRoundingResolution = roundingResolution,

                                baseHeightAdjustment = baseHeightAdjustment,
                                baseSideAdjustment = [baseSideAdjustment,baseSideAdjustment,baseSideAdjustment,0],
                                knobSize = knobSize,
                                wallThickness = wallThickness,
                                tubeZSize = tubeZSize);

    for (i = [0:1:brickSizeX - 1]) {
      translate([
        -(0.5 * brickSizeX - 0.5) * gridSizeXY + i * gridSizeXY,
        verticalPlateHeight - connectorCoverHeight,
        -0.5 * brickSizeVerticalY * gridSizeXY + 0.5 *
        gridSizeZ
      ]) rotate([ 90, 90, 225 ])
        prism(gridSizeZ + 2 * connectorDepthTolerance, connectorSize, connectorSize);
    }
  }
}