echo(version=version());

include <../../lib/window_block.scad>;

window_block(
    top=true, 
    brickHeight=2, 
    grid=[3,4], 
    logoText="\uf0b2",
    logoFont="Font Awesome 5 Free Solid"
);
