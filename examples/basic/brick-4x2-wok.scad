/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Brick 4x2 without knobs
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/block.scad>;

//4x2 Brick
translate([0,0,0])
    block(baseLayers=3, knobs=false);