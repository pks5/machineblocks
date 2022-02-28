echo(version=version());

include <../../lib/window_block.scad>;

window_block(top=false, brickHeight=2, grid=[3,4], pcbY=20, pcbX=15.5, pins=[-1,0,0]);
