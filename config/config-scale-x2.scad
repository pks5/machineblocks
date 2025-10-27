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
scale = 2.0; // Float

/*
* Calibration
*/

// Adjustment of the height
// Amount will be added to/subtracted from the top side of the brick's base
baseHeightAdjustment = 0.0; // mm

// Adjustment of each side
// Amount will be added to/subtracted from each side of the brick's base
baseSideAdjustment = -0.1; // mm

// Adjustment of base walls
baseWallThicknessAdjustment = -0.1; // mm

// Thickness of clamps
baseClampThickness = 0.1; // mm

// Adjustment of tube diameter
// Amount will be added to/subtracted from tube diameter
tubeXDiameterAdjustment = -0.1; // mm
tubeYDiameterAdjustment = -0.1; // mm
tubeZDiameterAdjustment = -0.1; // mm

// Adjustment of hole diameter
// Amount will be added to/subtracted from hole diameter
holeXDiameterAdjustment = 0.3; // mm
holeYDiameterAdjustment = 0.3; // mm
holeZDiameterAdjustment = 0.3; // mm

// Adjustment of pin diameter
// Amount will be added to/subtracted from pin diameter
pinDiameterAdjustment = 0.0; // mm

// Adjustment of stud diameter and cutout
// Amount will be added to/subtracted from stud diameter
studDiameterAdjustment = 0.2; // mm
studCutoutAdjustment = [0.2, 0.4]; // mm [diameter, height]

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