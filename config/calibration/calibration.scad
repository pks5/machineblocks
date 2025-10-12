echo(version=version());

include <../../lib/block.scad>;
include <./calib.scad>;

numberOfSamples = 5;
font = "RBNo3.1";
fontSize = 3;
labelSize = 5;

//studDiameterAdjustment
studDiameterAdjustmentValueStart = 0;
studDiameterAdjustmentValueStep = 0.1;

calib_base("studDiaAdj", numberOfSamples, studDiameterAdjustmentValueStart, studDiameterAdjustmentValueStep, labelSize, font, fontSize, 0);

calib_studDiameterAdjustment(numberOfSamples, studDiameterAdjustmentValueStart, studDiameterAdjustmentValueStep, 0);

//baseWallThicknessAdjustment
baseWallThicknessAdjustmentValueStart = -0.3;
baseWallThicknessAdjustmentValueStep = 0.1;

calib_base("wallThickAdj", numberOfSamples, baseWallThicknessAdjustmentValueStart, baseWallThicknessAdjustmentValueStep, labelSize, font, fontSize, -3);

calib_baseWallThicknessAdjustment(numberOfSamples, baseWallThicknessAdjustmentValueStart, baseWallThicknessAdjustmentValueStep, -3);

//tubeZDiameterAdjustment
tubeZDiameterAdjustmentValueStart = -0.3;
tubeZDiameterAdjustmentValueStep = 0.1;

calib_base("tubeZDiaAdj", numberOfSamples, tubeZDiameterAdjustmentValueStart, tubeZDiameterAdjustmentValueStep, labelSize, font, fontSize, -6);

calib_tubeZDiameterAdjustment(numberOfSamples, tubeZDiameterAdjustmentValueStart, tubeZDiameterAdjustmentValueStep, -6);

//pinDiameterAdjustment
pinDiameterAdjustmentValueStart = -0.2;
pinDiameterAdjustmentValueStep = 0.1;

calib_base("pinDiaAdj", numberOfSamples, pinDiameterAdjustmentValueStart, pinDiameterAdjustmentValueStep, labelSize, font, fontSize, -9);

calib_pinDiameterAdjustment(numberOfSamples, pinDiameterAdjustmentValueStart, pinDiameterAdjustmentValueStep, -9);