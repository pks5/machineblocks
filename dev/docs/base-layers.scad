/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Plate 1x1
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/block.scad>;

color([0.376, 0.768, 0.058])
block(grid=[1,1], knobType="NONE", baseHeight=9.6);


block(grid=[1,1], baseHeight=9.4, knobHeight=2.1);