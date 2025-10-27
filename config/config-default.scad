/**
* MachineBlocks
* https://machineblocks.com/
*
* Default Configuration
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

/*
 * Default configuration used by all example files.
 *
 * ⚠️  Note: It is not recommended to modify values in this file directly.
 * Instead, copy this file and reference the new version in config.scad.
 */

/* [Hidden] */

/*
* Global Settings
*/

// Unit Size MBU
unitMbu = 1.6; // mm

// Unit Grid, relative to mbu
unitGrid = [5, 2]; // mbu

// Scale of the bricks
scale = 1.0; // Float

/*
* Calibration
*/

// Adjustment of the height
baseHeightAdjustment = 0.0; // mm

// Adjustment of each side
baseSideAdjustment = -0.1; // mm

// Adjustment of base walls
baseWallThicknessAdjustment = -0.1; // mm

// Thickness of clamps
baseClampThickness = 0.1; // mm

// Adjustment of tube diameter
tubeXDiameterAdjustment = -0.1; // mm
tubeYDiameterAdjustment = -0.1; // mm
tubeZDiameterAdjustment = -0.1; // mm

// Adjustment of pin holes diameter and inset
holeXDiameterAdjustment = 0.3; // mm
holeXInsetThicknessAdjustment = 0.0; // mm
holeXInsetDepthAdjustment = 0.0; // mm

holeYDiameterAdjustment = 0.3; // mm
holeYInsetThicknessAdjustment = 0.0; // mm
holeYInsetDepthAdjustment = 0.0; // mm

holeZDiameterAdjustment = 0.3; // mm

// Adjustment of pin diameter
pinDiameterAdjustment = 0.0; // mm

// Adjustment of stud diameter and cutout
studDiameterAdjustment = 0.2; // mm
studHeightAdjustment = 0.0; // mm
studCutoutAdjustment = [0.2, 0.4]; // mm [diameter, height]
studHoleDiameterAdjustment = 0.3; // mm

/*
* Preview
*/

// Whether brick should be rendered in preview mode
// Only works with a latest nightly build of OpenSCAD
previewRender = true; //true or false

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // float, from 0.1 to 1.0

// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 64; // integer, from 32 to 512