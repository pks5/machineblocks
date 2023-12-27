/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Plate 6x6
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

include <../../lib/block-v2.scad>;

block(grid=[6,6], withBaseHoleGaps=true);