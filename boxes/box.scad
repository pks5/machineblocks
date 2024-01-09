include <../lib/block.scad>;

block(
    grid=[6,6],
    baseLayers=8,
    withPit=true,
    withText=true,
    textSize=10,
    textFont="OldSansBlack",
    textDepth=-0.8,
    text="ANNA"
);

translate([0, 50, 0])
    block(
        grid=[6,6]
    );
