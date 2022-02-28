echo(version=version());

include <../../lib/window_block.scad>;

withTop=false;
withBottom=true;


if(withBottom){
    translate([-30, 0, 0]){
        window_block(top=false, brickHeight=2, grid=[3,4], pcbY=19.5, pcbX=15.5, pins=[-1,0,0]);
    }
}

if(withTop){
    translate([30, 0, 0]){
        window_block(top=true, brickHeight=2, grid=[3,4]);
    }
}