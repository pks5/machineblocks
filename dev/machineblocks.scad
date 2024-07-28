include <../lib/block.scad>;

translate([0, 50, 0])
block(
    baseLayers=3,
    grid=[8,2],
    text="machineblocks.com",
    textFont="RBNo3.1 Black"
);

//color([0.906, 0.298, 0.235])
block();