use <../../lib/block.scad>;

block(
    grid=[6,6],
    baseLayers=8,
    knobs=false,
    tongue=true,
    tongueHeight=1.8,
    tongueClampThickness=0,
    tongueRoundingRadius=1,
    pit=true,
    baseCutoutType="none",
    baseRoundingRadius=[0,0,4]
);

translate([0, 50, 0])
    block(
        grid=[6,6],
        baseCutoutType="groove",
        tongueClampThickness=0,
        tongueRoundingRadius=1,
        tongueOuterAdjustment=0.1,
        tongueThickness = 1.2,
        knobs=false,
        textSide=5,
        textSize=10,
        textFont="OldSansBlack",
        textDepth=0.8,
        text="MEDS",
        baseRoundingRadius=[0,0,4]
    );
