use <../lib/block.scad>;

machineblock(
    size=[4, 2, 3],
    holeZ=true
);

translate([0, 24, 0])
machineblock(
    scale = 2,
    size=[4, 2, 1],
    holeZ = true
);

translate([0, 72, 0])
machineblock(
    scale = 3,
    size=[4, 2, 2],
    holeZ=true
);

translate([40, 0, 0])
machineblock(
    size=[4, 1, 3],
    holeX=true
);

translate([80, 0, 0])
machineblock(
    size=[1, 2, 3],
    holeY=true,
    studType="ring"
);

translate([70, 24, 0])
machineblock(
    scale = 2,
    size=[3, 1, 3],
    holeX=true,
    studType="ring"
);

translate([120, 24, 0])
machineblock(
    scale = 2,
    size=[1, 2, 3],
    holeY=true,
    studType="ring"
);

translate([100, 72, 0])
machineblock(
    scale = 3,
    size=[2, 1, 3],
    holeX=true,
    studType="ring"
);

translate([150, 72, 0])
machineblock(
    scale = 3,
    size=[1, 2, 3],
    holeY=true,
    studType="ring"
);