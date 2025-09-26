use <../lib/block.scad>;

block(
    baseLayers=3, 
    grid=[4,2]
);

translate([0, 24, 0])
block(
    rootUnit = 3.2,
    baseLayers=3, 
    grid=[4,2]
);

translate([0, 72, 0])
block(
    rootUnit = 4.8,
    baseLayers=3, 
    grid=[4,2]
);

translate([40, 0, 0])
block(
    baseLayers=3, 
    grid=[4,1]
);

translate([70, 24, 0])
block(
    rootUnit = 3.2,
    baseLayers=3, 
    grid=[3,1]
);

translate([100, 72, 0])
block(
    rootUnit = 4.8,
    baseLayers=3, 
    grid=[2,1]
);