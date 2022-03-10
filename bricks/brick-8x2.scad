/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Brick 8x2
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../lib/block-v2.scad>;

block(baseLayers=3, grid=[8,2]);