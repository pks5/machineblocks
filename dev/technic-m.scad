include <../lib/block.scad>;

baseColor = "#EAC645";  // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]


machineblock(
    align="ccs",
    baseRoundingRadius = [0,4,0],
    baseCutoutRoundingRadius = 0,
    baseCutoutType = "none",
    baseColor = baseColor,
    holeX = true,
    holeXCentered = false,
    holeXGridOffsetZ = 2.5,
    size=[4, 0.5, 2.5], 
    studs = false
);

machineblock(
    align="ccs",
    offset=[1.5,0,0],
    baseRoundingRadius = [0,4,0],
    baseCutoutRoundingRadius = 0,
    baseCutoutType = "none",
    baseColor = baseColor,
    holeX = true,
    holeXCentered = false,
    holeXGridOffsetZ = 2.5,
    holeXGridSizeZ = 5,
    size=[1, 0.5, 10], 
    studs = false
);

