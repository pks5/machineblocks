use <../../lib/block.scad>;

block(
    grid=[6,6],
    baseLayers=8,
    knobs=false,
    tongue=true,
    withPit=true,
    baseCutoutType="NONE",
    baseRounding=true,
    baseRoundingRadius=[0,0,4]
);

translate([0, 50, 0])
    block(
        grid=[6,6],
        baseCutoutType="GROOVE",
        knobs=false,
        withText=true,
        textSide=5,
        textSize=10,
        textFont="OldSansBlack",
        textDepth=0.8,
        text="MEDS",
        baseRounding=true,
        baseRoundingRadius=[0,0,4]
    );
