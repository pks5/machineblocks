/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Raspberry Pi Case Lid with window
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

use <../../../lib/shapes.scad>;
use <../lib/pi_case_lid.scad>;

baseSideLength=8;
lidHeight = 3;
knobHeight = 1.9;
innerWallHeight=2;
totalLidHeight = lidHeight + knobHeight;
lidHoleRadius=4;

difference(){
    pi_case_lid(knobGaps = [[0,3,6,10]]);
    translate([-0.5*baseSideLength, baseSideLength, - 0.5*knobHeight])
        mb_roundedcube([6*baseSideLength, 8*baseSideLength, 1.1*totalLidHeight+innerWallHeight], true, lidHoleRadius, "z");
}