/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Base Plate
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/block.scad>;

block(grid=[30,24], baseCutoutType = "NONE");

