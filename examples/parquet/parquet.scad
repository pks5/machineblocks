include <../../lib/block.scad>;

/*
block(
    grid=[6,1],
    knobType="NONE"
);

translate([0,10,0])
block(
    grid=[6,1],
    knobType="NONE"
);

translate([0,20,0])
block(
    grid=[6,1],
    knobType="NONE"
);

translate([0,30,0])
block(
    grid=[6,1],
    knobType="NONE"
);
*/
translate([0,40,0])
    block(
        grid=[3,2],
        knobType="NONE", 
        wallThickness = 1.4
    );
/*
translate([0,50,0])
    block(
        grid=[2,1],
        knobType="NONE"
    );
    */