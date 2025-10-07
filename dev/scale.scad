use <../lib/block.scad>;

machineblock(
    layers=3, 
    grid=[4,2],
    holeZ=true
);

translate([0, 24, 0])
machineblock(
    scale = 2,
    grid=[4,2],
    holeZ = true
);

translate([0, 72, 0])
machineblock(
    scale = 3,
    layers=2, 
    grid=[4,2],
    holeZ=true
);

translate([40, 0, 0])
machineblock(
    layers=3, 
    grid=[4,1],
    holeX=true
);

translate([80, 0, 0])
machineblock(
    layers=3, 
    grid=[1,2],
    holeY=true,
    studType="ring"
);

translate([70, 24, 0])
machineblock(
    scale = 2,
    layers=3, 
    grid=[3,1],
    holeX=true,
    studType="ring"
);

translate([120, 24, 0])
machineblock(
    scale = 2,
    layers=3, 
    grid=[1,2],
    holeY=true,
    studType="ring"
);

translate([100, 72, 0])
machineblock(
    scale = 3,
    layers=3, 
    grid=[2,1],
    holeX=true,
    studType="ring"
);

translate([150, 72, 0])
machineblock(
    scale = 3,
    layers=3, 
    grid=[1,2],
    holeY=true,
    studType="ring"
);