echo(version=version());

include <../../lib/block-v2.scad>;

translate([10, -10, 0])
    block(baseLayers=3, grid=[8,2], withKnobs=false);
        
translate([10, -30, 0])
        block(baseLayers=3, grid=[10,2], withKnobs=false);

translate([10, -50, 0])
        block(baseLayers=3, grid=[12,2], withKnobs=false);

translate([10, -70, 0])
        block(baseLayers=3, grid=[16,2], withKnobs=false);

translate([10, -90, 0])
        block(baseLayers=3, grid=[20,2], withKnobs=false);
        
translate([10, 10, 0])
    block(baseLayers=3, grid=[8,1], withKnobs=false);
        
translate([10, 20, 0])
        block(baseLayers=3, grid=[10,1], withKnobs=false);

translate([10, 30, 0])
        block(baseLayers=3, grid=[12,1], withKnobs=false);

translate([10, 40, 0])
        block(baseLayers=3, grid=[16,1], withKnobs=false);

translate([10, 50, 0])
        block(baseLayers=3, grid=[20,1], withKnobs=false);        
