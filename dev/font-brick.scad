echo(version=version());

include <../lib/block-v2.scad>;

text="Hello";
textSize=5;
textFont="DINPro-Bold";
textDepth=0.5;

color("blue")
block(baseLayers=3, grid=[4,2], withKnobsFilled=true, withText=true, textSize=textSize, text=text, textFont=textFont); 

/*
translate([-20,0,0])
linear_extrude(0.9*textDepth)
    text(text, size = textSize, font = textFont,$fn = 64);
*/