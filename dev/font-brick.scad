include <../lib/block-v2.scad>;

text="TEXT";
//text="[";
//text="\uf1e2\ue4dc\uf714";

textFont="Segoe UI:style=Bold";
//textFont="Wingdings";
//textFont="Font Awesome 6 Free Solid";

textSize=6;
textDepth=0.7;
textSpacing=1.1;
grid=[4,2];

block(baseLayers=3, grid=grid, withText=true, textSize=textSize, text=text, textFont=textFont, textDepth=textDepth, textSpacing=textSpacing, center=false); 

/*
translate([-20,0,0])
linear_extrude(0.9*textDepth)
    text(text, size = textSize, font = textFont,$fn = 64);
*/