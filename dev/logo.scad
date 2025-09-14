echo(version=version());

include <../lib/block.scad>;

// Quality of the preview in relation to the final rendering.
previewQuality = 0.5; // [0.1:0.1:1]
// Number of drawn fragments for roundings in the final rendering.
roundingResolution = 256; // [16:8:128]

/* [Text] */

// Text to write on the brick.
text = "\ue0b7";
// Side of the brick on which text is written.
textSide = 3; // [0:X0, 1:X1, 2:Y0, 3:Y1, 4:Z0, 5:Z1]
// Letter Depth
textDepth = -1.2; // [-3.2:0.2:3.2]
// Text Size
textSize = 8; // [1:32]
// Font
textFont = "Font Awesome 6 Free Solid"; // [Creato Display, RBNo3.1 Black, Font Awesome 6 Free Regular, Font Awesome 6 Free Solid]
// Text Style
textStyle = "Regular"; // [Black, Black Italic, Bold, Bold Italic, Book, Book Italic, ExtraBold, ExtraBold Italic, Light, Light Italic, Medium, Medium Italic, Regular, Regular Italic, Thin, Thin Italic, Ultra, Ultra Italic]
// Spacing of the letters
textSpacing = 1; // [0.1:0.1:4]

/* [Hidden] */

difference() {
block(
    baseLayers=2, 
    baseRoundingRadius=[0,0,4],
    baseCutoutType="none",
    grid=[6, 6],
    knobs=[true,[1,1,4,4,true]],

     previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
);

block(
    
    baseLayers=3, 
    baseCutoutType="none",
    baseRoundingRadius=[0,0,2],
    grid=[4, 4],
    knobs = false,

     previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
);
}

color("#438752")
block(
    gridOffset=[0,0,0],
    baseLayers=1, 
    baseCutoutType="none",
    grid=[4, 4],
    knobs = false,

     previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
);

block(
    gridOffset=[0,0,16],
    baseRoundingRadius=[0,0,4],
    baseCutoutType="none",
    knobCentered=true,
    baseLayers=7, 
    grid=[6, 6],

    textSide = textSide,
    textSize = textSize,
    text=text,
    textDepth=textDepth,
    textSpacing = textSpacing,
    textFont=str(textFont, (textStyle == "" ? "" : str(":style=", textStyle))),
    textColor = "#D65745",
    
     previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,
);
        