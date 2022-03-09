echo(version=version());

include <../../lib/window_block.scad>;

translate([-30, 0, 0]){
    window_block(top=false, 
            grid=[3,4], 
            pcbY=19.7, 
            pcbX=17.1, 
            pins=[0,0,0]
    );
}