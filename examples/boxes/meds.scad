use <../../lib/block.scad>;

block(
    grid=[6,6],
    baseLayers=8,
    knobs=false,
    tongue=true,
    tongueHeight=1.8,
    tongueClampThickness=0,
    tongueOuterAdjustment=-0.2,
    pit=true,
    baseCutoutType="none",
    baseRoundingRadius=[0,0,4]
);

translate([0, 50, 0])
    block(
        grid=[6,6],
        baseCutoutType="groove",
        knobs=false,
        textSide=5,
        textSize=10,
        textFont="OldSansBlack",
        textDepth=0.8,
        text="MEDS",
        baseRoundingRadius=[0,0,4]
    );
