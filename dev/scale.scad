use <../lib/block.scad>;

block(
    baseLayers=3, 
    grid=[4,2],
    holeZ=true
);

translate([0, 24, 0])
block(
    rootUnit = 3.2,
    baseLayers=3, 
    grid=[4,2],
    holeZ = true
);

translate([0, 72, 0])
block(
    rootUnit = 4.8,
    baseLayers=3, 
    grid=[4,2],
    holeZ=true
);

translate([40, 0, 0])
block(
    baseLayers=3, 
    grid=[4,1],
    holeX=true
);

translate([80, 0, 0])
block(
    baseLayers=3, 
    grid=[1,2],
    holeY=true
);

translate([70, 24, 0])
block(
    rootUnit = 3.2,
    baseLayers=3, 
    grid=[3,1],
    holeX=true
);

translate([120, 24, 0])
block(
    rootUnit = 3.2,
    baseLayers=3, 
    grid=[1,2],
    holeY=true
);

translate([100, 72, 0])
block(
    rootUnit = 4.8,
    baseLayers=3, 
    grid=[2,1],
    holeX=true
);

translate([150, 72, 0])
block(
    rootUnit = 4.8,
    baseLayers=3, 
    grid=[1,2],
    holeY=true
);