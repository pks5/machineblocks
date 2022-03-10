echo(version=version());

include <../lib/pi-case-lid.scad>;

difference(){
    pi_case_lid(knobGaps = [[0,3,6,10]]);
    translate([-0.5*baseSideLength, baseSideLength, - 0.5*knobHeight])
        roundedcube([6*baseSideLength, 8*baseSideLength, totalLidHeight+innerWallHeight+cutSpace], true, lidHoleRadius, "z");
}