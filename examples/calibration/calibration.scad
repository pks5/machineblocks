echo(version=version());

include <../../lib/block.scad>;
include <calib.scad>;

numberOfSamples = 5;
font = "Arial Black";
fontSize = 3;
labelSize = 5;

//knobSize
knobSizeValueStart = 4.8;
knobSizeValueStep = 0.1;

calib_base("knobSize", numberOfSamples, knobSizeValueStart, knobSizeValueStep, labelSize, font, fontSize, 0);

calib_knobSize(numberOfSamples, knobSizeValueStart, knobSizeValueStep, 0);

//wallThickness
wallThicknessValueStart = 1.3;
wallThicknessValueStep = 0.1;

calib_base("wallThickness", numberOfSamples, wallThicknessValueStart, wallThicknessValueStep, labelSize, font, fontSize, -3);

calib_wallThickness(numberOfSamples, wallThicknessValueStart, wallThicknessValueStep, -3);

//tubeZSize
tubeZSizeValueStart = 6.1;
tubeZSizeValueStep = 0.1;

calib_base("tubeZSize", numberOfSamples, tubeZSizeValueStart, tubeZSizeValueStep, labelSize, font, fontSize, -6);

calib_tubeZSize(numberOfSamples, tubeZSizeValueStart, tubeZSizeValueStep, -6);