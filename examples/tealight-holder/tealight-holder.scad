echo(version=version());

include <../../lib/pcb_block.scad>;

$fs=4;
$fn=50;
difference(){
    cylinder(h=16.4, r=22); 
    translate([0,0,2])
        cylinder(h=16.4, r=20); 
    translate([0,0,-1])
     block(grid=[2,2], knobHeight=4, knobSize=5, center=true);
}

translate([35,0,2.5])
block(grid=[2,2], center=true);