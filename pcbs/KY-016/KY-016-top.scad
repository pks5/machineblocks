echo(version=version());

include <../../lib/window_block.scad>;

translate([30, 0, 0]){
    window_block(top=true, grid=[3,4], brickHeight=2, logoText="\uf0eb",
    logoFont="Font Awesome 5 Free Solid");
}