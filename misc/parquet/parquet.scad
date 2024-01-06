include <../../lib/block-v2.scad>;

block(
    grid=[6,1],
    withKnobs=false
);

translate([0,10,0])
block(
    grid=[6,1],
    withKnobs=false
);

translate([0,20,0])
block(
    grid=[6,1],
    withKnobs=false
);

translate([0,30,0])
block(
    grid=[6,1],
    withKnobs=false
);

translate([0,40,0])
    block(
        grid=[4,1],
        withKnobs=false
    );

translate([0,50,0])
    block(
        grid=[2,1],
        withKnobs=false
    );