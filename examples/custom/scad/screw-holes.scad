echo(version=version());

use <../../../lib/block.scad>;

machineblock(
    size=[4,2,3],
    screwHolesX=[[0,0], [0,1], [0,2]]
);
  

machineblock(
    size=[6,6,1],
    offset=[0,3,0],
    screwHolesZ=[[0,0], [0,1], [0,2]],
    pillars = true
);
