/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Long Bricks without knobs
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/block.scad>;

translate([10, -10, 0])
    block(baseLayers=3, grid=[8,2], knobs=false);
        
translate([10, -30, 0])
        block(baseLayers=3, grid=[10,2], knobs=false);

translate([10, -50, 0])
        block(baseLayers=3, grid=[12,2], knobs=false);

translate([10, -70, 0])
        block(baseLayers=3, grid=[16,2], knobs=false);

translate([10, -90, 0])
        block(baseLayers=3, grid=[20,2], knobs=false);
        
translate([10, 10, 0])
    block(baseLayers=3, grid=[8,1], knobs=false);
        
translate([10, 20, 0])
        block(baseLayers=3, grid=[10,1], knobs=false);

translate([10, 30, 0])
        block(baseLayers=3, grid=[12,1], knobs=false);

translate([10, 40, 0])
        block(baseLayers=3, grid=[16,1], knobs=false);

translate([10, 50, 0])
        block(baseLayers=3, grid=[20,1], knobs=false);        
