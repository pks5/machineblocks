echo(version=version());

include <../lib/block-v2.scad>;

translate([10, -20, 0])
    block(grid=[4,2], withZHoles = true);

translate([10, -40, 0])
    block(grid=[6,2], withZHoles = true);
 
translate([10, -60, 0])
    block(grid=[8,2], withZHoles = true);

translate([10, -80, 0])
    block(grid=[10,2], withZHoles = true);
  
translate([10, -100, 0])
    block(grid=[12,2], withZHoles = true);
    
translate([10, -120, 0])
    block(grid=[16,2], withZHoles = true);

translate([10, -140, 0])
    block(grid=[20,2], withZHoles = true);
