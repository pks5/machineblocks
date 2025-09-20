/**
* MachineBlocks
* https://machineblocks.com/examples/text
*
* Text Tile Rot 3x2
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
use <../../../lib/block.scad>;
include <../../../config/presets.scad>;


/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 3; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]

/* [Base] */

// Type of cut-out on the underside.
baseCutoutType = "classic"; // [none, classic]

// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Knobs] */

// Whether to draw knobs
knobs = false;
// Whether knobs should be centered.
knobCentered = false;
// Type of the knobs
knobType = "classic"; // [classic, technic]
// Whether to draw pillars.
pillars = true;

/* [Text] */

// Text to write on the brick.
text = "Rot";
// Side of the brick on which text is written.
textSide = 5; // [0:X0, 1:X1, 2:Y0, 3:Y1, 4:Z0, 5:Z1]
// Letter Depth
textDepth = 1.2; // [-3.2:0.2:3.2]
// Text Size
textSize = 8; // [1:32]
// Font
textFont = "RBNo3.1 Black"; // [Creato Display, RBNo3.1 Black, Font Awesome 6 Free Regular, Font Awesome 6 Free Solid]
// Text Style
textStyle = "Regular"; // [Black, Black Italic, Bold, Bold Italic, Book, Book Italic, ExtraBold, ExtraBold Italic, Light, Light Italic, Medium, Medium Italic, Regular, Regular Italic, Thin, Thin Italic, Ultra, Ultra Italic]
// Spacing of the letters
textSpacing = 1; // [0.1:0.1:4]
// Color of the text
textColor = "#303D4E"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]

/* [Render] */

// Quality of the preview in relation to the final rendering.
    previewQuality = 0.5; // [0.1:0.1:1]
    // Number of drawn fragments for roundings in the final rendering.
    roundingResolution = 64; // [16:8:128]

// Generate the block
block(
    grid = [brickSizeX, brickSizeY],
    baseLayers = baseLayers,
    
    baseCutoutType = baseCutoutType,
    baseColor = baseColor,

    knobs = knobs,
    knobCentered = knobCentered,
    knobType = knobType,
    pillars = pillars,

    textSide = textSide,
    textSize = textSize,
    text=text,
    textDepth=textDepth,
    textSpacing = textSpacing,
    textFont=str(textFont, (textStyle == "" ? "" : str(":style=", textStyle))),
    textColor = textColor,

    previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,

    baseSideAdjustment = baseSideAdjustment,
    
    previewRender = previewRender,
    baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize
);