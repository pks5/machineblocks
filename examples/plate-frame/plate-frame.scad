echo(version=version());

include <../../lib/block.scad>;

outerWallX = false;
outerWallY = true;
outerWallHolesX = true;
outerWallHolesY = false;
grid = [18, 16];

//Back
machineblock(size=[grid[0] - 2, 1,3], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", holeX=outerWallHolesX, align="ccs");
machineblock(size=[1, 1,3], offset=[-(0.5 * (grid[0] - 1)), 0, 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", align="ccs");

if (outerWallX) {
  //Outer Wall
  machineblock(size=[grid[0] - 2, 1,4], offset=[0, 1, 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", holeX=outerWallHolesX, studs=false, align="ccs");
  machineblock(size=[2, 1,4], offset=[-(0.5 * grid[0]), 1, 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", studs=false, align="ccs");
  machineblock(size=[1, 1,4], offset=[(0.5 * (grid[0] - 1)), 1, 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", studs=false, align="ccs");
}

//Left
machineblock(size=[1, grid[1] - 2,3], offset=[-(0.5 * (grid[0] - 1)), -(0.5 * (grid[1] - 1)), 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", holeY=outerWallHolesY, align="ccs");
machineblock(size=[1, 1,3], offset=[-(0.5 * (grid[0] - 1)), -(grid[1] - 1), 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", align="ccs");

if (outerWallY) {
  //Outer Wall
  machineblock(size=[1, grid[1] - 2,4], offset=[-(0.5 * (grid[0] + 1)), -(0.5 * (grid[1] - 1)), 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", holeY=outerWallHolesY, studs=false, align="ccs");
  machineblock(size=[1, 1,4], offset=[-(0.5 * (grid[0] + 1)), 0, 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", studs=false, align="ccs");
  machineblock(size=[1, 1,4], offset=[-(0.5 * (grid[0] + 1)), -(grid[1] - 1), 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", studs=false, align="ccs");
}

//Front
machineblock(size=[grid[0] - 2, 1,3], offset=[0, -(grid[1] - 1), 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", holeX=true, align="ccs");
machineblock(size=[1, 1,3], offset=[(0.5 * (grid[0] - 1)), -(grid[1] - 1), 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", align="ccs");

//Right
machineblock(size=[1, grid[1] - 2,3], offset=[(0.5 * (grid[0] - 1)), -(0.5 * (grid[1] - 1)), 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", holeY=true, align="ccs");
machineblock(size=[1, 1,3], offset=[(0.5 * (grid[0] - 1)), 0, 0], baseSideAdjustment=[0, 0, 0, 0], baseCutoutType="none", align="ccs");
