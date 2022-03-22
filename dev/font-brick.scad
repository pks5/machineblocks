echo(version=version());

include <../lib/block-v2.scad>;

//text="WOOD IS GOOD";
text="\uf1e2\ue4dc\uf714";
textSize=6;
//textFont="DINPro-Bold:style=Bold";
textFont="Font Awesome 6 Free Solid";
textDepth=0.7;

block(baseLayers=3, grid=[4,2], withText=true, textSize=textSize, text=text, textFont=textFont, textDepth=textDepth, textSpacing=1.1, center=false); 

/*
translate([-20,0,0])
linear_extrude(0.9*textDepth)
    text(text, size = textSize, font = textFont,$fn = 64);
*/