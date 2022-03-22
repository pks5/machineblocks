echo(version=version());

include <../lib/block-v2.scad>;

text="WOOD IS GOOD";
//text="\uf004";
textSize=6;
textFont="DINPro-Bold:style=Bold";
//textFont="Font Awesome 6 Free Regular";
textDepth=0.7;

color("blue")
block(baseLayers=3, grid=[8,2], withText=true, textSize=textSize, text=text, textFont=textFont, textDepth=textDepth, center=false); 

/*
translate([-20,0,0])
linear_extrude(0.9*textDepth)
    text(text, size = textSize, font = textFont,$fn = 64);
*/