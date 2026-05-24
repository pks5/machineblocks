use <utils.scad>;

/**
 * Native Gatters
 */

function mb_param_unitMbuToMm(config, settings, default = undef) = mb_param(config, settings, "unitMbuToMm", default != undef ? default : 1.6);
function mb_param_unitGridToMbu(config, settings, default = undef) = mb_param(config, settings, "unitGridToMbu", default != undef ? default : [5, 2]);
function mb_param_scale(config, settings, default = undef) = mb_param(config, settings, "scale", default != undef ? default : 1.0);

function mb_param_rotation(config, settings, default = undef) = mb_param(config, settings, "rotation", default != undef ? default : [0, 0, 0]);
function mb_param_rotationOffset(config, settings, default = undef) = mb_param(config, settings, "rotationOffset", default != undef ? default : [0, 0, 0]);
function mb_param_rotationOffsetRevert(config, settings, default = undef) = mb_param(config, settings, "rotationOffsetRevert", default != undef ? default : true);
function mb_param_direction(config, settings, default = undef) = mb_direction_to_int(mb_param(config, settings, "direction", default != undef ? default : "west"));

function mb_param_size(config, settings, default = undef) = mb_param(config, settings, "size", default != undef ? default : [1, 1, 1]);
function mb_param_sizeAdjustment(config, settings, default = undef) = mb_param(config, settings, "sizeAdjustment", default != undef ? default : [-0.1, 0]);
function mb_param_sizeMod(config, settings, default = undef) = mb_param(config, settings, "sizeMod", default != undef ? default : []);

function mb_param_offset(config, settings, default = undef) = mb_param(config, settings, "offset", default != undef ? default : [0, 0, 0]);

function mb_param_cutouts(config, settings, default = undef) = mb_param(config, settings, "cutouts", default != undef ? default : false);
function mb_param_ports(config, settings, default = undef) = mb_param(config, settings, "ports", default != undef ? default : false);

function mb_param_base(config, settings, default = undef) = mb_param(config, settings, "base", default != undef ? default : true);
function mb_param_baseColor(config, settings, default = undef) = mb_param(config, settings, "baseColor", default != undef ? default : "#EAC645");

function mb_param_baseTopPlateHeight(config, settings, default = undef) = mb_param(config, settings, "baseTopPlateHeight", default != undef ? default : 1);
function mb_param_baseTopPlateHeightAdjustment(config, settings, default = undef) = mb_param(config, settings, "baseTopPlateHeightAdjustment", default != undef ? default : -0.6);

function mb_param_baseCutoutType(config, settings, default = undef) = mb_param(config, settings, "baseCutoutType", default != undef ? default : "standard");
function mb_param_baseCutoutMaxDepth(config, settings, default = undef) = mb_param(config, settings, "baseCutoutMaxDepth", default != undef ? default : 5);

function mb_param_baseClampOffset(config, settings, default = undef) = mb_param(config, settings, "baseClampOffset", default != undef ? default : 0.25);
function mb_param_baseClampHeight(config, settings, default = undef) = mb_param(config, settings, "baseClampHeight", default != undef ? default : 0.5);
function mb_param_baseClampThickness(config, settings, default = undef) = mb_param(config, settings, "baseClampThickness", default != undef ? default : 0.1);
function mb_param_baseClampOuter(config, settings, default = undef) = mb_param(config, settings, "baseClampOuter", default != undef ? default : false);

function mb_param_baseRoundingRadius(config, settings, default = undef) = mb_param(config, settings, "baseRoundingRadius", default != undef ? default : 0.0);
function mb_param_baseCutoutRoundingRadius(config, settings, default = undef) = mb_param(config, settings, "baseCutoutRoundingRadius", default != undef ? default : "auto");

function mb_param_reliefCut(config, settings, default = undef) = mb_param(config, settings, "reliefCut", default != undef ? default : false);
function mb_param_reliefCutHeight(config, settings, default = undef) = mb_param(config, settings, "reliefCutHeight", default != undef ? default : 0.375);
function mb_param_reliefCutThickness(config, settings, default = undef) = mb_param(config, settings, "reliefCutThickness", default != undef ? default : 0.375);

function mb_param_baseAdjustment(config, settings, default = undef) = mb_param(config, settings, "baseAdjustment", default != undef ? default : undef);

function mb_param_baseWallThickness(config, settings, default = undef) = mb_param(config, settings, "baseWallThickness", default != undef ? default : "auto");
function mb_param_baseWallThicknessAdjustment(config, settings, default = undef) = mb_param(config, settings, "baseWallThicknessAdjustment", default != undef ? default : -0.1);
function mb_param_baseWallGaps(config, settings, default = undef) = mb_param(config, settings, "baseWallGaps", default != undef ? default : []);

function mb_param_topPlateHelpers(config, settings, default = undef) = mb_param(config, settings, "topPlateHelpers", default != undef ? default : true);
function mb_param_topPlateHelperHeight(config, settings, default = undef) = mb_param(config, settings, "topPlateHelperHeight", default != undef ? default : 0.2);
function mb_param_topPlateHelperThickness(config, settings, default = undef) = mb_param(config, settings, "topPlateHelperThickness", default != undef ? default : 0.4);

function mb_param_stabilizers(config, settings, default = undef) = mb_param(config, settings, "stabilizers", default != undef ? default : true);
function mb_param_stabilizerPrintOffset(config, settings, default = undef) = mb_param(config, settings, "stabilizerPrintOffset", default != undef ? default : 0.2);
function mb_param_stabilizerHeight(config, settings, default = undef) = mb_param(config, settings, "stabilizerHeight", default != undef ? default : 0.5);
function mb_param_stabilizerThickness(config, settings, default = undef) = mb_param(config, settings, "stabilizerThickness", default != undef ? default : 0.5);
function mb_param_stabilizerExpansion(config, settings, default = undef) = mb_param(config, settings, "stabilizerExpansion", default != undef ? default : 2);
function mb_param_stabilizerExpansionOffset(config, settings, default = undef) = mb_param(config, settings, "stabilizerExpansionOffset", default != undef ? default : 1);

function mb_param_pillars(config, settings, default = undef) = mb_param(config, settings, "pillars", default != undef ? default : true);
function mb_param_pillarGapCornerLength(config, settings, default = undef) = mb_param(config, settings, "pillarGapCornerLength", default != undef ? default : 2);
function mb_param_pillarGapMiddle(config, settings, default = undef) = mb_param(config, settings, "pillarGapMiddle", default != undef ? default : 10);

function mb_param_pinDiameter(config, settings, default = undef) = mb_param(config, settings, "pinDiameter", default != undef ? default : "auto");
function mb_param_pinDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "pinDiameterAdjustment", default != undef ? default : 0.0);

function mb_param_tubeWallThickness(config, settings, default = undef) = mb_param(config, settings, "tubeWallThickness", default != undef ? default : 0.53125);
function mb_param_tubeXDiameter(config, settings, default = undef) = mb_param(config, settings, "tubeXDiameter", default != undef ? default : "auto");
function mb_param_tubeXDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "tubeXDiameterAdjustment", default != undef ? default : -0.1);
function mb_param_tubeYDiameter(config, settings, default = undef) = mb_param(config, settings, "tubeYDiameter", default != undef ? default : "auto");
function mb_param_tubeYDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "tubeYDiameterAdjustment", default != undef ? default : -0.1);
function mb_param_tubeZDiameter(config, settings, default = undef) = mb_param(config, settings, "tubeZDiameter", default != undef ? default : "auto");
function mb_param_tubeZDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "tubeZDiameterAdjustment", default != undef ? default : -0.1);
function mb_param_tubeInnerClampThickness(config, settings, default = undef) = mb_param(config, settings, "tubeInnerClampThickness", default != undef ? default : 0.1);

function mb_param_slope(config, settings, default = undef) = mb_param(config, settings, "slope", default != undef ? default : false);
function mb_param_slopeBaseHeightBottom(config, settings, default = undef) = mb_param(config, settings, "slopeBaseHeightBottom", default != undef ? default : 1.333);
function mb_param_slopeBaseHeightInner(config, settings, default = undef) = mb_param(config, settings, "slopeBaseHeightLower", default != undef ? default : 1.125);
function mb_param_slopeBaseHeightTop(config, settings, default = undef) = mb_param(config, settings, "slopeBaseHeightTop", default != undef ? default : 1);

function mb_param_bevel(config, settings, default = undef) = mb_param(config, settings, "bevel", default != undef ? default : [[0,0], [0,0], [0,0], [0,0]]);

function mb_param_holeX(config, settings, default = undef) = mb_param(config, settings, "holeX", default != undef ? default : false);
function mb_param_holeXType(config, settings, default = undef) = mb_param(config, settings, "holeXType", default != undef ? default : "pin");
function mb_param_holeXShift(config, settings, default = undef) = mb_param(config, settings, "holeXShift", default != undef ? default : true);
function mb_param_holeXDiameter(config, settings, default = undef) = mb_param(config, settings, "holeXDiameter", default != undef ? default : "auto");
function mb_param_holeXDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeXDiameterAdjustment", default != undef ? default : 0.3);
function mb_param_holeXInsetThickness(config, settings, default = undef) = mb_param(config, settings, "holeXInsetThickness", default != undef ? default : 0.375);
function mb_param_holeXInsetThicknessAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeXInsetThicknessAdjustment", default != undef ? default : 0.0);
function mb_param_holeXInsetDepth(config, settings, default = undef) = mb_param(config, settings, "holeXInsetDepth", default != undef ? default : 0.5);
function mb_param_holeXInsetDepthAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeXInsetDepthAdjustment", default != undef ? default : 0.0);
function mb_param_holeXGridOffsetZ(config, settings, default = undef) = mb_param(config, settings, "holeXGridOffsetZ", default != undef ? default : 3.625);
function mb_param_holeXGridOffsetZAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeXGridOffsetZAdjustment", default != undef ? default : 0.0);
function mb_param_holeXGridSizeZ(config, settings, default = undef) = mb_param(config, settings, "holeXGridSizeZ", default != undef ? default : 6);
function mb_param_holeXGridSizeZAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeXGridSizeZAdjustment", default != undef ? default : 0.0);
function mb_param_holeXMinTopMargin(config, settings, default = undef) = mb_param(config, settings, "holeXMinTopMargin", default != undef ? default : 0.5);
function mb_param_holeXPartial(config, settings, default = undef) = mb_param(config, settings, "holeXPartial", default != undef ? default : "none");

function mb_param_holeY(config, settings, default = undef) = mb_param(config, settings, "holeY", default != undef ? default : false);
function mb_param_holeYType(config, settings, default = undef) = mb_param(config, settings, "holeYType", default != undef ? default : "pin");
function mb_param_holeYShift(config, settings, default = undef) = mb_param(config, settings, "holeYShift", default != undef ? default : true);
function mb_param_holeYDiameter(config, settings, default = undef) = mb_param(config, settings, "holeYDiameter", default != undef ? default : "auto");
function mb_param_holeYDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeYDiameterAdjustment", default != undef ? default : 0.3);
function mb_param_holeYInsetThickness(config, settings, default = undef) = mb_param(config, settings, "holeYInsetThickness", default != undef ? default : 0.375);
function mb_param_holeYInsetThicknessAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeYInsetThicknessAdjustment", default != undef ? default : 0.0);
function mb_param_holeYInsetDepth(config, settings, default = undef) = mb_param(config, settings, "holeYInsetDepth", default != undef ? default : 0.5);
function mb_param_holeYInsetDepthAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeYInsetDepthAdjustment", default != undef ? default : 0.0);
function mb_param_holeYGridOffsetZ(config, settings, default = undef) = mb_param(config, settings, "holeYGridOffsetZ", default != undef ? default : 3.625);
function mb_param_holeYGridOffsetZAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeYGridOffsetZAdjustment", default != undef ? default : 0.0);
function mb_param_holeYGridSizeZ(config, settings, default = undef) = mb_param(config, settings, "holeYGridSizeZ", default != undef ? default : 6);
function mb_param_holeYGridSizeZAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeYGridSizeZAdjustment", default != undef ? default : 0.0);
function mb_param_holeYMinTopMargin(config, settings, default = undef) = mb_param(config, settings, "holeYMinTopMargin", default != undef ? default : 0.5);
function mb_param_holeYPartial(config, settings, default = undef) = mb_param(config, settings, "holeYPartial", default != undef ? default : "none");

function mb_param_holeZ(config, settings, default = undef) = mb_param(config, settings, "holeZ", default != undef ? default : false);
function mb_param_holeZType(config, settings, default = undef) = mb_param(config, settings, "holeZType", default != undef ? default : "pin");
function mb_param_holeZShift(config, settings, default = undef) = mb_param(config, settings, "holeZShift", default != undef ? default : true);
function mb_param_holeZDiameter(config, settings, default = undef) = mb_param(config, settings, "holeZDiameter", default != undef ? default : "auto");
function mb_param_holeZDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "holeZDiameterAdjustment", default != undef ? default : 0.3);
function mb_param_holeZPartialX(config, settings, default = undef) = mb_param(config, settings, "holeZPartialX", default != undef ? default : "none");
function mb_param_holeZPartialY(config, settings, default = undef) = mb_param(config, settings, "holeZPartialY", default != undef ? default : "none");

function mb_param_holeAxleThickness(config, settings, default = undef) = mb_param(config, settings, "holeAxleThickness", default != undef ? default : 1);

function mb_param_studs(config, settings, default = undef) = mb_param(config, settings, "studs", default != undef ? default : true);
function mb_param_studType(config, settings, default = undef) = mb_param(config, settings, "studType", default != undef ? default : "solid");
function mb_param_studShift(config, settings, default = undef) = mb_param(config, settings, "studShift", default != undef ? default : false);
function mb_param_studMaxOverhang(config, settings, default = undef) = mb_param(config, settings, "studMaxOverhang", default != undef ? default : 0.3);
function mb_param_studPadding(config, settings, default = undef) = mb_param(config, settings, "studPadding", default != undef ? default : 0);

function mb_param_studClampHeight(config, settings, default = undef) = mb_param(config, settings, "studClampHeight", default != undef ? default : 0.5);
function mb_param_studClampThickness(config, settings, default = undef) = mb_param(config, settings, "studClampThickness", default != undef ? default : 0.0);

function mb_param_studHoleDiameter(config, settings, default = undef) = mb_param(config, settings, "studHoleDiameter", default != undef ? default : "auto");
function mb_param_studHoleDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "studHoleDiameterAdjustment", default != undef ? default : 0.3);
function mb_param_studHoleClampThickness(config, settings, default = undef) = mb_param(config, settings, "studHoleClampThickness", default != undef ? default : 0.1);

function mb_param_studRounding(config, settings, default = undef) = mb_param(config, settings, "studRounding", default != undef ? default : 0.0625);
function mb_param_studDiameter(config, settings, default = undef) = mb_param(config, settings, "studDiameter", default != undef ? default : 3);
function mb_param_studDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "studDiameterAdjustment", default != undef ? default : 0.2);
function mb_param_studHeight(config, settings, default = undef) = mb_param(config, settings, "studHeight", default != undef ? default : 1);
function mb_param_studHeightAdjustment(config, settings, default = undef) = mb_param(config, settings, "studHeightAdjustment", default != undef ? default : 0.0);
function mb_param_studSink(config, settings, default = undef) = mb_param(config, settings, "studSink", default != undef ? default : 0.25);
function mb_param_studCutoutDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "studCutoutDiameterAdjustment", default != undef ? default : 0.2);
function mb_param_studCutoutHeightAdjustment(config, settings, default = undef) = mb_param(config, settings, "studCutoutHeightAdjustment", default != undef ? default : 0.4);

function mb_param_studIcon(config, settings, default = undef) = mb_param(config, settings, "studIcon", default != undef ? default : "../../pattern/bolt-solid-full.svg");
function mb_param_studIconDimensions(config, settings, default = undef) = mb_param(config, settings, "studIconDimensions", default != undef ? default : [169.333, 169.333]);
function mb_param_studIconSize(config, settings, default = undef) = mb_param(config, settings, "studIconSize", default != undef ? default : [0.5, 0.5, -0.2]);

function mb_param_studIconScale(config, settings, default = undef) = mb_param(config, settings, "studIconScale", default != undef ? default : 0.024);
function mb_param_studIconDepth(config, settings, default = undef) = mb_param(config, settings, "studIconDepth", default != undef ? default : -0.2);
function mb_param_studIconColor(config, settings, default = undef) = mb_param(config, settings, "studIconColor", default != undef ? default : "inherit");

function mb_param_tongue(config, settings, default = undef) = mb_param(config, settings, "tongue", default != undef ? default : false);
function mb_param_tongueHeight(config, settings, default = undef) = mb_param(config, settings, "tongueHeight", default != undef ? default : 1.25);
function mb_param_tongueGrooveDepth(config, settings, default = undef) = mb_param(config, settings, "tongueGrooveDepth", default != undef ? default : 1.5);
function mb_param_tongueRoundingRadius(config, settings, default = undef) = mb_param(config, settings, "tongueRoundingRadius", default != undef ? default : "auto");
function mb_param_tongueThickness(config, settings, default = undef) = mb_param(config, settings, "tongueThickness", default != undef ? default : 0.666);
function mb_param_tongueThicknessAdjustment(config, settings, default = undef) = mb_param(config, settings, "tongueThicknessAdjustment", default != undef ? default : 0);
function mb_param_tongueOffset(config, settings, default = undef) = mb_param(config, settings, "tongueOffset", default != undef ? default : 1);
function mb_param_tongueClampHeight(config, settings, default = undef) = mb_param(config, settings, "tongueClampHeight", default != undef ? default : 0.5);
function mb_param_tongueClampOffset(config, settings, default = undef) = mb_param(config, settings, "tongueClampOffset", default != undef ? default : 0.25);
function mb_param_tongueClampThickness(config, settings, default = undef) = mb_param(config, settings, "tongueClampThickness", default != undef ? default : 0.1);

function mb_param_grille(config, settings, default = undef) = mb_param(config, settings, "grille", default != undef ? default : "none");
function mb_param_grilleInverted(config, settings, default = undef) = mb_param(config, settings, "grilleInverted", default != undef ? default : false);
function mb_param_grilleDepth(config, settings, default = undef) = mb_param(config, settings, "grilleDepth", default != undef ? default : 1);
function mb_param_grilleCount(config, settings, default = undef) = mb_param(config, settings, "grilleCount", default != undef ? default : 5);

function mb_param_recess(config, settings, default = undef) = mb_param(config, settings, "recess", default != undef ? default : false);
function mb_param_recessRoundingRadius(config, settings, default = undef) = mb_param(config, settings, "recessRoundingRadius", default != undef ? default : "auto");
function mb_param_recessDepth(config, settings, default = undef) = mb_param(config, settings, "recessDepth", default != undef ? default : "auto");
function mb_param_recessWallThickness(config, settings, default = undef) = mb_param(config, settings, "recessWallThickness", default != undef ? default : 0.333);
function mb_param_recessStuds(config, settings, default = undef) = mb_param(config, settings, "recessStuds", default != undef ? default : true);
function mb_param_recessStudPadding(config, settings, default = undef) = mb_param(config, settings, "recessStudPadding", default != undef ? default : 0.2);
function mb_param_recessStudType(config, settings, default = undef) = mb_param(config, settings, "recessStudType", default != undef ? default : "solid");
function mb_param_recessStudShift(config, settings, default = undef) = mb_param(config, settings, "recessStudShift", default != undef ? default : false);
function mb_param_recessWallGaps(config, settings, default = undef) = mb_to_array(mb_param(config, settings, "recessWallGaps", default != undef ? default : []));

function mb_param_text(config, settings, default = undef) = mb_param(config, settings, "text", default != undef ? default : "");
function mb_param_textSide(config, settings, default = undef) = mb_param(config, settings, "textSide", default != undef ? default : 0);
function mb_param_textDepth(config, settings, default = undef) = mb_param(config, settings, "textDepth", default != undef ? default : -0.25);
function mb_param_textFont(config, settings, default = undef) = mb_param(config, settings, "textFont", default != undef ? default : "Liberation Sans");
function mb_param_textSize(config, settings, default = undef) = mb_param(config, settings, "textSize", default != undef ? default : 4);
function mb_param_textSpacing(config, settings, default = undef) = mb_param(config, settings, "textSpacing", default != undef ? default : 1);
function mb_param_textVerticalAlign(config, settings, default = undef) = mb_param(config, settings, "textVerticalAlign", default != undef ? default : "center");
function mb_param_textHorizontalAlign(config, settings, default = undef) = mb_param(config, settings, "textHorizontalAlign", default != undef ? default : "center");
function mb_param_textOffset(config, settings, default = undef) = mb_param(config, settings, "textOffset", default != undef ? default : [0, 0]);
function mb_param_textColor(config, settings, default = undef) = mb_param(config, settings, "textColor", default != undef ? default : "#2c3e50");

function mb_param_surfacePattern(config, settings, default = undef) = mb_param(config, settings, "surfacePattern", default != undef ? default : "none");
function mb_param_surfacePatternDimensions(config, settings, default = undef) = mb_param(config, settings, "surfacePatternDimensions", default != undef ? default : [451.556, 451.556]);
function mb_param_surfacePatternOffset(config, settings, default = undef) = mb_param(config, settings, "surfacePatternOffset", default != undef ? default : [0, 0]);
function mb_param_surfacePatternScale(config, settings, default = undef) = mb_param(config, settings, "surfacePatternScale", default != undef ? default : 0.25);
function mb_param_surfacePatternDepth(config, settings, default = undef) = mb_param(config, settings, "surfacePatternDepth", default != undef ? default : -0.2);
function mb_param_surfacePatternColor(config, settings, default = undef) = mb_param(config, settings, "surfacePatternColor", default != undef ? default : "inherit");

function mb_param_svg(config, settings, default = undef) = mb_param(config, settings, "svg", default != undef ? default : "");
function mb_param_svgSide(config, settings, default = undef) = mb_param(config, settings, "svgSide", default != undef ? default : 5);
function mb_param_svgDepth(config, settings, default = undef) = mb_param(config, settings, "svgDepth", default != undef ? default : 0.4);
function mb_param_svgDimensions(config, settings, default = undef) = mb_param(config, settings, "svgDimensions", default != undef ? default : [100, 100]);
function mb_param_svgScale(config, settings, default = undef) = mb_param(config, settings, "svgScale", default != undef ? default : 1.0);
function mb_param_svgOffset(config, settings, default = undef) = mb_param(config, settings, "svgOffset", default != undef ? default : [0, 0]);
function mb_param_svgColor(config, settings, default = undef) = mb_param(config, settings, "svgColor", default != undef ? default : "#2c3e50");

function mb_param_connectors(config, settings, default = undef) = mb_param(config, settings, "connectors", default != undef ? default : false);
function mb_param_connectorPadding(config, settings, default = undef) = mb_param(config, settings, "connectorPadding", default != undef ? default : [0, 0]);
function mb_param_connectorHeight(config, settings, default = undef) = mb_param(config, settings, "connectorHeight", default != undef ? default : "auto");
function mb_param_connectorDepth(config, settings, default = undef) = mb_param(config, settings, "connectorDepth", default != undef ? default : 0.75);
function mb_param_connectorWidth(config, settings, default = undef) = mb_param(config, settings, "connectorWidth", default != undef ? default : 2.5);
function mb_param_connectorDepthTolerance(config, settings, default = undef) = mb_param(config, settings, "connectorDepthTolerance", default != undef ? default : 0.2);
function mb_param_connectorSideTolerance(config, settings, default = undef) = mb_param(config, settings, "connectorSideTolerance", default != undef ? default : 0.1);

function mb_param_screwHolesZ(config, settings, default = undef) = mb_param(config, settings, "screwHolesZ", default != undef ? default : []);
function mb_param_screwHoleZSize(config, settings, default = undef) = mb_param(config, settings, "screwHoleZSize", default != undef ? default : 2.3);
function mb_param_screwHoleZHelperThickness(config, settings, default = undef) = mb_param(config, settings, "screwHoleZHelperThickness", default != undef ? default : 0.8);
function mb_param_screwHoleZHelperOffset(config, settings, default = undef) = mb_param(config, settings, "screwHoleZHelperOffset", default != undef ? default : 0.2);
function mb_param_screwHoleZHelperHeight(config, settings, default = undef) = mb_param(config, settings, "screwHoleZHelperHeight", default != undef ? default : 0.2);

function mb_param_screwHolesX(config, settings, default = undef) = mb_param(config, settings, "screwHolesX", default != undef ? default : []);
function mb_param_screwHoleXSize(config, settings, default = undef) = mb_param(config, settings, "screwHoleXSize", default != undef ? default : 2.1);
function mb_param_screwHoleXDepth(config, settings, default = undef) = mb_param(config, settings, "screwHoleXDepth", default != undef ? default : 4);

function mb_param_screwHolesY(config, settings, default = undef) = mb_param(config, settings, "screwHolesY", default != undef ? default : []);
function mb_param_screwHoleYSize(config, settings, default = undef) = mb_param(config, settings, "screwHoleYSize", default != undef ? default : 2.1);
function mb_param_screwHoleYDepth(config, settings, default = undef) = mb_param(config, settings, "screwHoleYDepth", default != undef ? default : 4);

function mb_param_pcb(config, settings, default = undef) = mb_param(config, settings, "pcb", default != undef ? default : false);
function mb_param_pcbMountingType(config, settings, default = undef) = mb_param(config, settings, "pcbMountingType", default != undef ? default : "clips");
function mb_param_pcbDimensions(config, settings, default = undef) = mb_param(config, settings, "pcbDimensions", default != undef ? default : [20, 30, 3]);
function mb_param_pcbOffset(config, settings, default = undef) = mb_param(config, settings, "pcbOffset", default != undef ? default : [0, 0]);
function mb_param_pcbScrewSocketSize(config, settings, default = undef) = mb_param(config, settings, "pcbScrewSocketSize", default != undef ? default : 5);
function mb_param_pcbScrewSocketHoleSize(config, settings, default = undef) = mb_param(config, settings, "pcbScrewSocketHoleSize", default != undef ? default : 2.2);
function mb_param_pcbScrewSocketHeight(config, settings, default = undef) = mb_param(config, settings, "pcbScrewSocketHeight", default != undef ? default : 3);
function mb_param_pcbScrewSockets(config, settings, default = undef) = mb_param(config, settings, "pcbScrewSockets", default != undef ? default : []);

function mb_param_align(config, settings, default = undef) = mb_align_resolve(mb_param(config, settings, "align", default != undef ? default : "start"));
function mb_param_alignChildren(config, settings, default = undef) = mb_align_resolve(mb_param(config, settings, "alignChildren", default != undef ? default : "start"));

function mb_param_qualitySegBase(config, settings, default = undef) = mb_param(config, settings, "qualitySegBase", default != undef ? default : 1.2);
function mb_param_qualityResolutionMax(config, settings, default = undef) = mb_param(config, settings, "qualityResolutionMax", default != undef ? default : 220);
function mb_param_qualityFactor(config, settings, default = undef) = mb_param(config, settings, "qualityFactor", default != undef ? default : [0.6, 1.0, 1.6, 2.5]);
function mb_param_qualityResolutionMin(config, settings, default = undef) = mb_param(config, settings, "qualityResolutionMin", default != undef ? default : [24, 18, 12, 8]);
function mb_param_qualityResolutionMultiplier(config, settings, default = undef) = mb_param(config, settings, "qualityResolutionMultiplier", default != undef ? default : 0.25);

function mb_param_previewQuality(config, settings, default = undef) = mb_param(config, settings, "previewQuality", default != undef ? default : 0.5);
function mb_param_previewRender(config, settings, default = undef) = mb_param(config, settings, "previewRender", default != undef ? default : true);
function mb_param_previewRenderConvexity(config, settings, default = undef) = mb_param(config, settings, "previewRenderConvexity", default != undef ? default : 25);

function mb_param_id(config, settings, default = undef) = mb_param(config, settings, "id", default != undef ? default : "[Block]");
function mb_param_debug(config, settings, default = undef) = mb_param(config, settings, "debug", default != undef ? default : false);
function mb_param_render(config, settings, default = undef) = mb_param(config, settings, "render", default != undef ? default : true);

/*
* Composite Blocks Only Parameters
*/
function mb_param_assembly(config, settings, default = undef) = let (ass = mb_param(config, settings, "assembly", default != undef ? default : "assembled")) is_list(ass) ? ass : [ass];
function mb_param_renderGroups(config, settings, default = undef) = let (parts = mb_param(config, settings, "renderGroups", default != undef ? default : "all")) is_list(parts) ? parts : [parts];

/*
* Parameter Helpers
*/

function mb_param(config, settings, key, default=undef) =
    let(
        s = _mb_params_valid(settings) ? mb_map_get(settings, key, undef) : undef,
        c = _mb_params_valid(config)   ? mb_map_get(config, key, undef)   : undef
    )
    s != undef ? s :
    c != undef ? c :
    default;

function _mb_params_valid(p) =
    p != undef && is_list(p) && len(p) > 0;  

function mb_params_get(params, key, default=undef) = mb_map_get(params, key, default);

function mb_params_merge(a, b) = mb_map_merge(a, b);

function mb_params_filter(a, ns, b = undef) =
    let(r = mb_array_filter_ns(a, ns))
        b == undef ? r : mb_map_merge(r, b);

/*
* Render Helpers
*/

function mb_group_render(renderGroups, g, solo = false) =
    solo ? (len(renderGroups) == 1 && renderGroups[0] == g) :
    (mb_in_array(renderGroups, "all") || mb_in_array(renderGroups, g));

/*
* Assembly Helpers
*/

function mb_assembly(config, settings, size, direction) = 
    let(dirInt = mb_direction_to_int(direction),
        assembly = mb_param_assembly(config, settings),
        assemblySize = assembly[1] != undef ? assembly[1] : mb_size_resolve(size, dirInt),
        assemblyDirection = assembly[2] != undef ? mb_direction_resolve(assembly[2], dirInt) : dirInt)
        [assembly[0], assemblySize, assemblyDirection];

function mb_assembly_tongue(assembly, renderGroups, g) = 
    mb_group_render(renderGroups, g, true) ? true :
    assembly[0] != "merged";

function mb_assembly_groove(assembly, renderGroups, g) = 
    mb_group_render(renderGroups, g, true) ? "groove" :
    assembly[0] == "merged" ? "none" : "groove"; 

function mb_assembly_offset(offset, assembly, renderGroups, g) = 
    let(size = assembly[1],
        globalDir = assembly[2],
        oX = assembly != undef && size[1] > size[0] ? 0.5 + size[0] : 0,
        oY = assembly != undef && size[0] >= size[1] ? 0.5 + size[1] : 0)
        
        mb_group_render(renderGroups, g, true) ? [0, 0, 0] :
       (assembly == undef || assembly[0] != "unassembled" ? 
         offset : 
        mb_offset_global_to_local([oX, oY, 0], globalDir));

/*
* General Helpers
*/

function mb_block_id(blockId, part) = str(blockId, "/", part);

function mb_offset_global_to_local(offset, direction) = 
    (direction == 1 || direction == 3) ? [(direction == 1 ? -1 : 1) * offset[1], (direction == 3 ? -1 : 1) * offset[0], offset[2]] : [(direction == 2 ? -1 : 1) * offset[0], (direction == 2 ? -1 : 1) * offset[1], offset[2]];

function mb_size_resolve(size, direction) = direction % 2 == 1 ? [size[1], size[0], size[2]] : size;
function mb_direction_resolve(dir1, dir2) = (dir1 + dir2) % 4;

/*
* Composite Block Helpers
*/

function _mb_vec3_min(a, b) = [
    min(a[0], b[0]),
    min(a[1], b[1]),
    min(a[2], b[2])
];

function _mb_vec3_max(a, b) = [
    max(a[0], b[0]),
    max(a[1], b[1]),
    max(a[2], b[2])
];

// entry = [size, direction, offset]
function _mb_part_min(entry) =
    let(
        offset = entry[2]
    )
    offset;

function _mb_part_max(entry) =
    let(
        size = entry[0],
        direction = entry[1],
        offset = entry[2],
        size_resolved = mb_size_resolve(size, mb_direction_to_int(direction))
    )
    [
        offset[0] + size_resolved[0],
        offset[1] + size_resolved[1],
        offset[2] + size_resolved[2]
    ];

function mb_parts_total_size(parts, i = 0, min_v = undef, max_v = undef) =
    i >= len(parts)
        ? [
            max_v[0] - min_v[0],
            max_v[1] - min_v[1],
            max_v[2] - min_v[2]
          ]
        : let(
            part = parts[i],
            part_min = _mb_part_min(part),
            part_max = _mb_part_max(part),
            next_min = (i == 0) ? part_min : _mb_vec3_min(min_v, part_min),
            next_max = (i == 0) ? part_max : _mb_vec3_max(max_v, part_max)
          )
          mb_parts_total_size(parts, i + 1, next_min, next_max);


function mb_set_step_print_position(assembly, steps, step) = 
    let(size = steps[step - 1][1],
        apply_assembly = steps[step - 1][2])
    step == 0 ? [0, 0, 0] : [((assembly == "unassembled" || assembly[0] == "unassembled") && apply_assembly && (size[0] < size[1]) ? 2 : 1) * (size[0] + 0.5) + mb_set_step_print_position(assembly, steps, step - 1)[0], 0, 0];
