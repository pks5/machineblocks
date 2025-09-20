/**
* MachineBlocks
* https://machineblocks.com/
*
* Calibration Presets
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

/*
* Set your calibration preset values here. Save the file after changing.
*
* ATTENTION: Changing values in this file affects ALL examples.
*/

/* [Hidden] */

// Adjustment of the height (mm)
// Amount will be added to/subtracted from the top side of the brick's base
baseHeightAdjustment = 0.0;

// Adjustment of each side (mm)
// Amount will be added to/subtracted from each side of the brick's base
baseSideAdjustment = -0.1;

// Effective diameter of all studs (mm)
// Original LEGO brick stud diameter is 4.8mm
knobSize = 5.0;

// Effective thickness of the walls (mm)
// Original LEGO brick wall thickness is 1.6mm
wallThickness = 1.5;

// Diameter of the Z-Tubes (mm)
tubeZSize = 6.4;

// Diameter of the Pins (mm)
pinSize = 3.2;

// Whether brick should be rendered in preview mode
// Only feasable when using a latest nightly build of OpenSCAD
previewRender = false; //true or false