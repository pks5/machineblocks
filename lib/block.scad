/**
* MachineBlocks Block module to create STL models of LEGO compatible bricks and enclosures optimized for 3D printing
* https://machineblocks.com 
*
* Copyright (c) 2022 Jan P. Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

use <shapes.scad>;
use <base.scad>;
use <text3d.scad>;
use <svg3d.scad>;
use <pcb.scad>;
use <axis.scad>;
use <utils.scad>;
use <bevel.scad>;
use <rounded.scad>;
use <quad.scad>;
use <polygon.scad>;
use <tongue.scad>;
use <stud.scad>;
use <quality.scad>;

/**
 * @module machineblock
 * @brief Generates 3D-printable models of LEGO® compatible building blocks.
 *
 * The machineblock() module can generate 3D models of various types of LEGO®-compatible building blocks, such as classic bricks, plates, round bricks, wedges, slopes, liftarms, and many more.
 * The different output forms can be controlled through a wide range of parameters. For more complex parts, multiple modules can be nested to create a new custom brick.
 * The module is pre-calibrated to ensure good fitting accuracy on most 3D printers. For optimal precision, calibration settings can be adjusted individually.*
 *
 * @requires OpenSCAD 2021.01 or newer
 *
 * @note Units: “mbu” and “grid” refer to the internal coordinate system, while mm represents real-world measurements. By default, 1 mbu = 1.6 mm. The “grid” unit is three-dimensional (x, y, z) and corresponds to 5 mbu in the x and y directions and 2 mbu in the z direction.
 * @note Most parameters are restricted to a single data type. However, certain parameters can accept multiple data types.
 * @note Some parameters support the keyword “auto”, which automatically derives appropriate default values.
 *
 * @example Minimal (1x1 Plate)
 * machineblock();
 *
 * @example 2x4 Brick
 * machineblock(size = [2, 4, 3]);
 *
 * @example 2x2 Plate
 * machineblock(size = [2, 2, 1]);
 *
 * @example 8x2 Plate with Pin Holes and Hollow Studs
 * machineblock(size = [8, 2, 1], holeZ = true, studType = "hollow");
 *
 * @examples Custom composite Brick
 * machineblock(size = [6, 2, 3]){
 *      machineblock(size = [2, 2, 3], offset = [2, 0, 3]);
 * }
 */

function mb_param_assembly(config, settings, default = undef) = mb_param(config, settings, "assembly", default != undef ? default : "assembled");

function mb_param_unitMbu(config, settings, default = undef) = mb_param(config, settings, "unitMbu", default != undef ? default : 1.6);
function mb_param_unitGrid(config, settings, default = undef) = mb_param(config, settings, "unitGrid", default != undef ? default : [5, 2]);
function mb_param_scale(config, settings, default = undef) = mb_param(config, settings, "scale", default != undef ? default : 1.0);

function mb_param_rotation(config, settings, default = undef) = mb_param(config, settings, "rotation", default != undef ? default : [0, 0, 0]);
function mb_param_rotationOffset(config, settings, default = undef) = mb_param(config, settings, "rotationOffset", default != undef ? default : [0, 0, 0]);
function mb_param_rotationOffsetRevert(config, settings, default = undef) = mb_param(config, settings, "rotationOffsetRevert", default != undef ? default : true);
function mb_param_direction(config, settings, default = undef) = mb_param(config, settings, "direction", default != undef ? default : "west");

function mb_param_size(config, settings, default = undef) = mb_param(config, settings, "size", default != undef ? default : [1, 1, 1]);
function mb_param_offset(config, settings, default = undef) = mb_param(config, settings, "offset", default != undef ? default : [0, 0, 0]);
function mb_param_crop(config, settings, default = undef) = mb_param(config, settings, "crop", default != undef ? default : [0, 0, 0, 0]);

function mb_param_cutout(config, settings, default = undef) = mb_param(config, settings, "cutout", default != undef ? default : false);
function mb_param_cutoutOffset(config, settings, default = undef) = mb_param(config, settings, "cutoutOffset", default != undef ? default : [0, 0]);

function mb_param_base(config, settings, default = undef) = mb_param(config, settings, "base", default != undef ? default : true);
function mb_param_baseColor(config, settings, default = undef) = mb_param(config, settings, "baseColor", default != undef ? default : "#EAC645");
function mb_param_baseHeight(config, settings, default = undef) = mb_param(config, settings, "baseHeight", default != undef ? default : "auto");

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
function mb_param_baseRoundingResolution(config, settings, default = undef) = mb_param(config, settings, "baseRoundingResolution", default != undef ? default : 64);

function mb_param_baseReliefCut(config, settings, default = undef) = mb_param(config, settings, "baseReliefCut", default != undef ? default : false);
function mb_param_baseReliefCutHeight(config, settings, default = undef) = mb_param(config, settings, "baseReliefCutHeight", default != undef ? default : 0.375);
function mb_param_baseReliefCutThickness(config, settings, default = undef) = mb_param(config, settings, "baseReliefCutThickness", default != undef ? default : 0.375);

function mb_param_baseSideAdjustment(config, settings, default = undef) = mb_resolve_side_quad(mb_param(config, settings, "baseSideAdjustment", default != undef ? default : -0.1));
function mb_param_baseHeightAdjustment(config, settings, default = undef) = mb_param(config, settings, "baseHeightAdjustment", default != undef ? default : 0.0);

function mb_param_baseWallThickness(config, settings, default = undef) = mb_param(config, settings, "baseWallThickness", default != undef ? default : "auto");
function mb_param_baseWallThicknessAdjustment(config, settings, default = undef) = mb_param(config, settings, "baseWallThicknessAdjustment", default != undef ? default : -0.1);
function mb_param_baseWallGapsX(config, settings, default = undef) = mb_param(config, settings, "baseWallGapsX", default != undef ? default : []);
function mb_param_baseWallGapsY(config, settings, default = undef) = mb_param(config, settings, "baseWallGapsY", default != undef ? default : []);

function mb_param_topPlateHelpers(config, settings, default = undef) = mb_param(config, settings, "topPlateHelpers", default != undef ? default : true);
function mb_param_topPlateHelperHeight(config, settings, default = undef) = mb_param(config, settings, "topPlateHelperHeight", default != undef ? default : 0.2);
function mb_param_topPlateHelperThickness(config, settings, default = undef) = mb_param(config, settings, "topPlateHelperThickness", default != undef ? default : 0.4);

function mb_param_stabilizerGrid(config, settings, default = undef) = mb_param(config, settings, "stabilizerGrid", default != undef ? default : true);
function mb_param_stabilizerGridOffset(config, settings, default = undef) = mb_param(config, settings, "stabilizerGridOffset", default != undef ? default : 0.2);
function mb_param_stabilizerGridHeight(config, settings, default = undef) = mb_param(config, settings, "stabilizerGridHeight", default != undef ? default : 0.5);
function mb_param_stabilizerGridThickness(config, settings, default = undef) = mb_param(config, settings, "stabilizerGridThickness", default != undef ? default : 0.5);
function mb_param_stabilizerExpansion(config, settings, default = undef) = mb_param(config, settings, "stabilizerExpansion", default != undef ? default : 2);
function mb_param_stabilizerExpansionOffset(config, settings, default = undef) = mb_param(config, settings, "stabilizerExpansionOffset", default != undef ? default : 1);

function mb_param_pillars(config, settings, default = undef) = mb_param(config, settings, "pillars", default != undef ? default : true);
function mb_param_pillarRoundingResolution(config, settings, default = undef) = mb_param(config, settings, "pillarRoundingResolution", default != undef ? default : 64);
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
function mb_param_slopeBaseHeightLower(config, settings, default = undef) = mb_param(config, settings, "slopeBaseHeightLower", default != undef ? default : 1.333);
function mb_param_slopeBaseHeightLowerInner(config, settings, default = undef) = mb_param(config, settings, "slopeBaseHeightLowerInner", default != undef ? default : 1.125);
function mb_param_slopeBaseHeightUpper(config, settings, default = undef) = mb_param(config, settings, "slopeBaseHeightUpper", default != undef ? default : 1);

function mb_param_bevel(config, settings, default = undef) = mb_param(config, settings, "bevel", default != undef ? default : [[0, 0], [0, 0], [0, 0], [0, 0]]);

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
function mb_param_holeRoundingResolution(config, settings, default = undef) = mb_param(config, settings, "holeRoundingResolution", default != undef ? default : 64);
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
function mb_param_studRoundingResolution(config, settings, default = undef) = mb_param(config, settings, "studRoundingResolution", default != undef ? default : 64);

function mb_param_studDiameter(config, settings, default = undef) = mb_param(config, settings, "studDiameter", default != undef ? default : 3);
function mb_param_studDiameterAdjustment(config, settings, default = undef) = mb_param(config, settings, "studDiameterAdjustment", default != undef ? default : 0.2);

function mb_param_studHeight(config, settings, default = undef) = mb_param(config, settings, "studHeight", default != undef ? default : 1);
function mb_param_studHeightAdjustment(config, settings, default = undef) = mb_param(config, settings, "studHeightAdjustment", default != undef ? default : 0.0);

function mb_param_studSink(config, settings, default = undef) = mb_param(config, settings, "studSink", default != undef ? default : 0.25);

function mb_param_studCutoutAdjustment(config, settings, default = undef) = mb_param(config, settings, "studCutoutAdjustment", default != undef ? default : [0.2, 0.4]);

function mb_param_studIcon(config, settings, default = undef) = mb_param(config, settings, "studIcon", default != undef ? default : "../pattern/bolt-solid-full.svg");
function mb_param_studIconDimensions(config, settings, default = undef) = mb_param(config, settings, "studIconDimensions", default != undef ? default : [169.333, 169.333]);
function mb_param_studIconScale(config, settings, default = undef) = mb_param(config, settings, "studIconScale", default != undef ? default : 0.024);
function mb_param_studIconDepth(config, settings, default = undef) = mb_param(config, settings, "studIconDepth", default != undef ? default : -0.2);
function mb_param_studIconColor(config, settings, default = undef) = mb_param(config, settings, "studIconColor", default != undef ? default : "inherit");

function mb_param_tongue(config, settings, default = undef) = mb_param(config, settings, "tongue", default != undef ? default : false);
function mb_param_tongueHeight(config, settings, default = undef) = mb_param(config, settings, "tongueHeight", default != undef ? default : 1.25);
function mb_param_tongueGrooveDepth(config, settings, default = undef) = mb_param(config, settings, "tongueGrooveDepth", default != undef ? default : 1.5);
function mb_param_tongueRoundingRadius(config, settings, default = undef) = mb_param(config, settings, "tongueRoundingRadius", default != undef ? default : "auto");
function mb_param_tongueInnerRoundingRadius(config, settings, default = undef) = mb_param(config, settings, "tongueInnerRoundingRadius", default != undef ? default : "auto");
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
function mb_param_recessWallGaps(config, settings, default = undef) = mb_param(config, settings, "recessWallGaps", default != undef ? default : []);

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

function mb_param_align(config, settings, default = undef) = mb_param(config, settings, "align", default != undef ? default : "start");
function mb_param_alignChildren(config, settings, default = undef) = mb_param(config, settings, "alignChildren", default != undef ? default : "start");

function mb_param_qualitySegBase(config, settings, default = undef) = mb_param(config, settings, "qualitySegBase", default != undef ? default : 1.2);
function mb_param_qualityResolutionMax(config, settings, default = undef) = mb_param(config, settings, "qualityResolutionMax", default != undef ? default : 220);
function mb_param_qualityFactor(config, settings, default = undef) = mb_param(config, settings, "qualityFactor", default != undef ? default : [0.6, 1.0, 1.6, 2.5]);
function mb_param_qualityResolutionMin(config, settings, default = undef) = mb_param(config, settings, "qualityResolutionMin", default != undef ? default : [24, 18, 12, 8]);
function mb_param_qualityResolutionMultiplier(config, settings, default = undef) = mb_param(config, settings, "qualityResolutionMultiplier", default != undef ? default : 0.25);

function mb_param_previewQuality(config, settings, default = undef) = mb_param(config, settings, "previewQuality", default != undef ? default : 0.5);
function mb_param_previewRender(config, settings, default = undef) = mb_param(config, settings, "previewRender", default != undef ? default : true);
function mb_param_previewRenderConvexity(config, settings, default = undef) = mb_param(config, settings, "previewRenderConvexity", default != undef ? default : 25);

function mb_param(config, settings, key, default=undef) =
    let(
        s = _mb_params_valid(settings) ? mb_params_get(settings, key, undef) : undef,
        c = _mb_params_valid(config)   ? mb_params_get(config, key, undef)   : undef
    )
    s != undef ? s :
    c != undef ? c :
    default;

function _mb_params_valid(p) =
    p != undef && is_list(p) && len(p) > 0;  

function _mb_params_has_key(params, key) =
    len([
        for (p = params)
            if (p[0] == key)
                1
    ]) > 0;

function mb_params_get(params, key, default=undef) =
    let(found = [for (p = params) if (p[0] == key) p[1]])
    len(found) > 0 ? found[0] : default;

function mb_params_merge(a, b) =
    concat(
        // alle aus a, die NICHT in b überschrieben werden
        [
            for (pa = a)
                if (!_mb_params_has_key(b, pa[0]))
                    pa
        ],
        // alle aus b (haben Vorrang)
        b
    );

function mb_params_resolve(config, settings, key, default=undef) = mb_param(config, settings, key, default);

function mb_assembly_offset(size, dir, parentSize = undef) = 
    let(oX = size[1] > size[0] ? (dir == "north" || dir == "east" ? -1 : 1) * (0.5 + size[0]) : 0,
        oY = size[0] >= size[1] ? (dir == "south" || dir == "east" ? -1 : 1) * (0.5 + size[1]) : 0,
        p = parentSize != undef ? mb_assembly_offset(parentSize, dir) : undef)
        p != undef ? mb_resolve_assembly_position(dir, p) : [oX, oY, 0];

function mb_resolve_assembly_position(dir, p) = [dir == "north" || dir == "south" ? p[1] : p[0], dir == "north" || dir == "south" ? -p[0] : p[1], p[2]];

function mb_base_side_adjustment_override(baseSideAdjustment, overrides, i = 0) =
    (overrides == undef) || (i >= len(overrides))
        ? baseSideAdjustment
        : let(
            r = overrides[i],
            index = r[0],
            newValue = len(r) > 1 ? r[1] : 0,
            nextValues =
                !is_num(index) || index < 0 || index >= len(baseSideAdjustment)
                    ? baseSideAdjustment
                    : [
                        for (j = [0 : len(baseSideAdjustment) - 1])
                            j == index ? newValue : baseSideAdjustment[j]
                    ]
        )
        mb_base_side_adjustment_override(nextValues, overrides, i + 1);

module mb_block(
    config,
    settings
){

    //START convert
    assembly = mb_param_assembly(config, settings);

    unitMbu = mb_param_unitMbu(config, settings);
    unitGrid = mb_param_unitGrid(config, settings);

    scale = mb_param_scale(config, settings);

    rotation = mb_param_rotation(config, settings);
    rotationOffset = mb_param_rotationOffset(config, settings);
    rotationOffsetRevert = mb_param_rotationOffsetRevert(config, settings);
    direction = mb_direction_to_int(mb_param_direction(config, settings));

    size = mb_param_size(config, settings);
    offset = mb_param_offset(config, settings);
    crop = mb_param_crop(config, settings);

    cutout = mb_param_cutout(config, settings);
    cutoutOffset = mb_param_cutoutOffset(config, settings);

    base = mb_param_base(config, settings);
    baseColor = mb_param_baseColor(config, settings);
    baseHeight = mb_param_baseHeight(config, settings);

    baseTopPlateHeight = mb_param_baseTopPlateHeight(config, settings);
    baseTopPlateHeightAdjustment = mb_param_baseTopPlateHeightAdjustment(config, settings);

    baseCutoutType = mb_param_baseCutoutType(config, settings);
    baseCutoutMaxDepth = mb_param_baseCutoutMaxDepth(config, settings);

    baseClampOffset = mb_param_baseClampOffset(config, settings);
    baseClampHeight = mb_param_baseClampHeight(config, settings);
    baseClampThickness = mb_param_baseClampThickness(config, settings);
    baseClampOuter = mb_param_baseClampOuter(config, settings);

    baseRoundingRadius = mb_param_baseRoundingRadius(config, settings);
    baseCutoutRoundingRadius = mb_param_baseCutoutRoundingRadius(config, settings);
    baseRoundingResolution = mb_param_baseRoundingResolution(config, settings);

    baseReliefCut = mb_param_baseReliefCut(config, settings);
    baseReliefCutHeight = mb_param_baseReliefCutHeight(config, settings);
    baseReliefCutThickness = mb_param_baseReliefCutThickness(config, settings);

    baseSideAdjustment = mb_param_baseSideAdjustment(config, settings);
    baseHeightAdjustment = mb_param_baseHeightAdjustment(config, settings);

    baseWallThickness = mb_param_baseWallThickness(config, settings);
    baseWallThicknessAdjustment = mb_param_baseWallThicknessAdjustment(config, settings);
    baseWallGapsX = mb_param_baseWallGapsX(config, settings);
    baseWallGapsY = mb_param_baseWallGapsY(config, settings);

    topPlateHelpers = mb_param_topPlateHelpers(config, settings);
    topPlateHelperHeight = mb_param_topPlateHelperHeight(config, settings);
    topPlateHelperThickness = mb_param_topPlateHelperThickness(config, settings);

    stabilizerGrid = mb_param_stabilizerGrid(config, settings);
    stabilizerGridOffset = mb_param_stabilizerGridOffset(config, settings);
    stabilizerGridHeight = mb_param_stabilizerGridHeight(config, settings);
    stabilizerGridThickness = mb_param_stabilizerGridThickness(config, settings);
    stabilizerExpansion = mb_param_stabilizerExpansion(config, settings);
    stabilizerExpansionOffset = mb_param_stabilizerExpansionOffset(config, settings);

    pillars = mb_param_pillars(config, settings);
    pillarRoundingResolution = mb_param_pillarRoundingResolution(config, settings);
    pillarGapCornerLength = mb_param_pillarGapCornerLength(config, settings);
    pillarGapMiddle = mb_param_pillarGapMiddle(config, settings);

    pinDiameter = mb_param_pinDiameter(config, settings);
    pinDiameterAdjustment = mb_param_pinDiameterAdjustment(config, settings);

    tubeWallThickness = mb_param_tubeWallThickness(config, settings);
    tubeXDiameter = mb_param_tubeXDiameter(config, settings);
    tubeXDiameterAdjustment = mb_param_tubeXDiameterAdjustment(config, settings);
    tubeYDiameter = mb_param_tubeYDiameter(config, settings);
    tubeYDiameterAdjustment = mb_param_tubeYDiameterAdjustment(config, settings);
    tubeZDiameter = mb_param_tubeZDiameter(config, settings);
    tubeZDiameterAdjustment = mb_param_tubeZDiameterAdjustment(config, settings);
    tubeInnerClampThickness = mb_param_tubeInnerClampThickness(config, settings);

    slope = mb_param_slope(config, settings);
    slopeBaseHeightLower = mb_param_slopeBaseHeightLower(config, settings);
    slopeBaseHeightLowerInner = mb_param_slopeBaseHeightLowerInner(config, settings);
    slopeBaseHeightUpper = mb_param_slopeBaseHeightUpper(config, settings);

    bevel = mb_param_bevel(config, settings);

    holeX = mb_param_holeX(config, settings);
    holeXType = mb_param_holeXType(config, settings);
    holeXShift = mb_param_holeXShift(config, settings);
    holeXDiameter = mb_param_holeXDiameter(config, settings);
    holeXDiameterAdjustment = mb_param_holeXDiameterAdjustment(config, settings);
    holeXInsetThickness = mb_param_holeXInsetThickness(config, settings);
    holeXInsetThicknessAdjustment = mb_param_holeXInsetThicknessAdjustment(config, settings);
    holeXInsetDepth = mb_param_holeXInsetDepth(config, settings);
    holeXInsetDepthAdjustment = mb_param_holeXInsetDepthAdjustment(config, settings);
    holeXGridOffsetZ = mb_param_holeXGridOffsetZ(config, settings);
    holeXGridOffsetZAdjustment = mb_param_holeXGridOffsetZAdjustment(config, settings);
    holeXGridSizeZ = mb_param_holeXGridSizeZ(config, settings);
    holeXGridSizeZAdjustment = mb_param_holeXGridSizeZAdjustment(config, settings);
    holeXMinTopMargin = mb_param_holeXMinTopMargin(config, settings);
    holeXPartial = mb_param_holeXPartial(config, settings);

    holeY = mb_param_holeY(config, settings);
    holeYType = mb_param_holeYType(config, settings);
    holeYShift = mb_param_holeYShift(config, settings);
    holeYDiameter = mb_param_holeYDiameter(config, settings);
    holeYDiameterAdjustment = mb_param_holeYDiameterAdjustment(config, settings);
    holeYInsetThickness = mb_param_holeYInsetThickness(config, settings);
    holeYInsetThicknessAdjustment = mb_param_holeYInsetThicknessAdjustment(config, settings);
    holeYInsetDepth = mb_param_holeYInsetDepth(config, settings);
    holeYInsetDepthAdjustment = mb_param_holeYInsetDepthAdjustment(config, settings);
    holeYGridOffsetZ = mb_param_holeYGridOffsetZ(config, settings);
    holeYGridOffsetZAdjustment = mb_param_holeYGridOffsetZAdjustment(config, settings);
    holeYGridSizeZ = mb_param_holeYGridSizeZ(config, settings);
    holeYGridSizeZAdjustment = mb_param_holeYGridSizeZAdjustment(config, settings);
    holeYMinTopMargin = mb_param_holeYMinTopMargin(config, settings);
    holeYPartial = mb_param_holeYPartial(config, settings);

    holeZ = mb_param_holeZ(config, settings);
    holeZType = mb_param_holeZType(config, settings);
    holeZShift = mb_param_holeZShift(config, settings);
    holeZDiameter = mb_param_holeZDiameter(config, settings);
    holeZDiameterAdjustment = mb_param_holeZDiameterAdjustment(config, settings);
    holeRoundingResolution = mb_param_holeRoundingResolution(config, settings);
    holeZPartialX = mb_param_holeZPartialX(config, settings);
    holeZPartialY = mb_param_holeZPartialY(config, settings);

    holeAxleThickness = mb_param_holeAxleThickness(config, settings);

    studs = mb_param_studs(config, settings);
    studType = mb_param_studType(config, settings);
    studShift = mb_param_studShift(config, settings);
    studMaxOverhang = mb_param_studMaxOverhang(config, settings);
    studPadding = mb_param_studPadding(config, settings);

    studClampHeight = mb_param_studClampHeight(config, settings);
    studClampThickness = mb_param_studClampThickness(config, settings);

    studHoleDiameter = mb_param_studHoleDiameter(config, settings);
    studHoleDiameterAdjustment = mb_param_studHoleDiameterAdjustment(config, settings);
    studHoleClampThickness = mb_param_studHoleClampThickness(config, settings);

    studRounding = mb_param_studRounding(config, settings);
    studRoundingResolution = mb_param_studRoundingResolution(config, settings);

    studDiameter = mb_param_studDiameter(config, settings);
    studDiameterAdjustment = mb_param_studDiameterAdjustment(config, settings);

    studHeight = mb_param_studHeight(config, settings);
    studHeightAdjustment = mb_param_studHeightAdjustment(config, settings);

    studSink = mb_param_studSink(config, settings);

    studCutoutAdjustment = mb_param_studCutoutAdjustment(config, settings);

    studIcon = mb_param_studIcon(config, settings);
    studIconDimensions = mb_param_studIconDimensions(config, settings);
    studIconScale = mb_param_studIconScale(config, settings);
    studIconDepth = mb_param_studIconDepth(config, settings);
    studIconColor = mb_param_studIconColor(config, settings);

    tongue = mb_param_tongue(config, settings);
    tongueHeight = mb_param_tongueHeight(config, settings);
    tongueGrooveDepth = mb_param_tongueGrooveDepth(config, settings);
    tongueRoundingRadius = mb_param_tongueRoundingRadius(config, settings);
    tongueInnerRoundingRadius = mb_param_tongueInnerRoundingRadius(config, settings);
    tongueThickness = mb_param_tongueThickness(config, settings);
    tongueThicknessAdjustment = mb_param_tongueThicknessAdjustment(config, settings);
    tongueOffset = mb_param_tongueOffset(config, settings);
    tongueClampHeight = mb_param_tongueClampHeight(config, settings);
    tongueClampOffset = mb_param_tongueClampOffset(config, settings);
    tongueClampThickness = mb_param_tongueClampThickness(config, settings);

    grille = mb_param_grille(config, settings);
    grilleInverted = mb_param_grilleInverted(config, settings);
    grilleDepth = mb_param_grilleDepth(config, settings);
    grilleCount = mb_param_grilleCount(config, settings);

    recess = mb_param_recess(config, settings);
    recessRoundingRadius = mb_param_recessRoundingRadius(config, settings);
    recessDepth = mb_param_recessDepth(config, settings);
    recessWallThickness = mb_param_recessWallThickness(config, settings);
    recessStuds = mb_param_recessStuds(config, settings);
    recessStudPadding = mb_param_recessStudPadding(config, settings);
    recessStudType = mb_param_recessStudType(config, settings);
    recessStudShift = mb_param_recessStudShift(config, settings);
    recessWallGaps = mb_param_recessWallGaps(config, settings);

    text = mb_param_text(config, settings);
    textSide = mb_param_textSide(config, settings);
    textDepth = mb_param_textDepth(config, settings);
    textFont = mb_param_textFont(config, settings);
    textSize = mb_param_textSize(config, settings);
    textSpacing = mb_param_textSpacing(config, settings);
    textVerticalAlign = mb_param_textVerticalAlign(config, settings);
    textHorizontalAlign = mb_param_textHorizontalAlign(config, settings);
    textOffset = mb_param_textOffset(config, settings);
    textColor = mb_param_textColor(config, settings);

    surfacePattern = mb_param_surfacePattern(config, settings);
    surfacePatternDimensions = mb_param_surfacePatternDimensions(config, settings);
    surfacePatternOffset = mb_param_surfacePatternOffset(config, settings);
    surfacePatternScale = mb_param_surfacePatternScale(config, settings);
    surfacePatternDepth = mb_param_surfacePatternDepth(config, settings);
    surfacePatternColor = mb_param_surfacePatternColor(config, settings);

    svg = mb_param_svg(config, settings);
    svgSide = mb_param_svgSide(config, settings);
    svgDepth = mb_param_svgDepth(config, settings);
    svgDimensions = mb_param_svgDimensions(config, settings);
    svgScale = mb_param_svgScale(config, settings);
    svgOffset = mb_param_svgOffset(config, settings);
    svgColor = mb_param_svgColor(config, settings);

    connectors = mb_param_connectors(config, settings);
    connectorPadding = mb_param_connectorPadding(config, settings);
    connectorHeight = mb_param_connectorHeight(config, settings);
    connectorDepth = mb_param_connectorDepth(config, settings);
    connectorWidth = mb_param_connectorWidth(config, settings);
    connectorDepthTolerance = mb_param_connectorDepthTolerance(config, settings);
    connectorSideTolerance = mb_param_connectorSideTolerance(config, settings);

    screwHolesZ = mb_param_screwHolesZ(config, settings);
    screwHoleZSize = mb_param_screwHoleZSize(config, settings);
    screwHoleZHelperThickness = mb_param_screwHoleZHelperThickness(config, settings);
    screwHoleZHelperOffset = mb_param_screwHoleZHelperOffset(config, settings);
    screwHoleZHelperHeight = mb_param_screwHoleZHelperHeight(config, settings);

    screwHolesX = mb_param_screwHolesX(config, settings);
    screwHoleXSize = mb_param_screwHoleXSize(config, settings);
    screwHoleXDepth = mb_param_screwHoleXDepth(config, settings);

    screwHolesY = mb_param_screwHolesY(config, settings);
    screwHoleYSize = mb_param_screwHoleYSize(config, settings);
    screwHoleYDepth = mb_param_screwHoleYDepth(config, settings);

    pcb = mb_param_pcb(config, settings);
    pcbMountingType = mb_param_pcbMountingType(config, settings);
    pcbDimensions = mb_param_pcbDimensions(config, settings);
    pcbOffset = mb_param_pcbOffset(config, settings);
    pcbScrewSocketSize = mb_param_pcbScrewSocketSize(config, settings);
    pcbScrewSocketHoleSize = mb_param_pcbScrewSocketHoleSize(config, settings);
    pcbScrewSocketHeight = mb_param_pcbScrewSocketHeight(config, settings);
    pcbScrewSockets = mb_param_pcbScrewSockets(config, settings);

    align = mb_param_align(config, settings);
    alignChildren = mb_param_alignChildren(config, settings);

    qualitySegBase = mb_param_qualitySegBase(config, settings);
    qualityResolutionMax = mb_param_qualityResolutionMax(config, settings);
    qualityFactor = mb_param_qualityFactor(config, settings);
    qualityResolutionMin = mb_param_qualityResolutionMin(config, settings);
    qualityResolutionMultiplier = mb_param_qualityResolutionMultiplier(config, settings);

    previewQuality = mb_param_previewQuality(config, settings);
    previewRender = mb_param_previewRender(config, settings);
    previewRenderConvexity = mb_param_previewRenderConvexity(config, settings);

    //END convert

    //Variables for cutouts        
    cutOffset = 0.2;
    cutMultiplier = 1.1;
    cutTolerance = 0.01;

    mbuToMm = scale * unitMbu;

    gridSizeXY = unitGrid[0] * mbuToMm;
    gridSizeZ = unitGrid[1] * mbuToMm;

    grid = [size[0], size[1]];

    //Side Adjustment
    cropResolved = mb_resolve_side_quad(crop, gridSizeXY);
    sAdj = mb_resolve_side_quad(baseSideAdjustment);
    sAdjustment = mb_calc_side_adjusmtent(sAdj, cropResolved);

    //Object Size     
    objectSizeX = gridSizeXY * grid[0];
    objectSizeY = gridSizeXY * grid[1];
    
    //Object Size Adjusted      
    objectSizeXAdj = objectSizeX + sAdj[0] + sAdj[1];
    objectSizeYAdj = objectSizeY + sAdj[2] + sAdj[3];

    objectSizeXAdjusted = objectSizeX + sAdjustment[0] + sAdjustment[1];
    objectSizeYAdjusted = objectSizeY + sAdjustment[2] + sAdjustment[3];
    minObjectSide = min(objectSizeXAdjusted, objectSizeYAdjusted);

    //Base Height
    baseHeightResolved = baseHeight == "auto" ? size[2] * gridSizeZ : baseHeight;
    resultingBaseHeight = baseHeightResolved + baseHeightAdjustment;

    adjustedSizeRelation = [objectSizeXAdj / objectSizeX, objectSizeYAdj / objectSizeY, resultingBaseHeight / baseHeightResolved];

    gridSizeX = mb_grid_size_x(grid, slope);
    gridSizeY = mb_grid_size_y(grid, slope);

    //Calculate Brick Align and Offset
    alignment = is_string(align) ? [align, align, align] : align;
    alignX = (alignment[0] == "center" || alignment[0] == "ccs") ? 0 : ((alignment[0] == "start" ? 1 : -1) * 0.5*objectSizeX);
    alignY = (alignment[1] == "center" || alignment[1] == "ccs") ? 0 : ((alignment[1] == "start" ? 1 : -1) * 0.5*objectSizeY);
    alignZ = alignment[2] == "center" ? 0 : ((alignment[2] == "start" || alignment[2] == "ccs") ? 0.5*resultingBaseHeight : 0.5*baseHeightAdjustment - 0.5*baseHeightResolved);
    
    
    directionRotationZ = direction * -90;

    //Rotation Offset
    rotationOffsetX = rotationOffset[0] * gridSizeXY;
    rotationOffsetY = rotationOffset[1] * gridSizeXY;
    rotationOffsetZ = rotationOffset[2] * gridSizeZ;

    preRotationOffset = [rotationOffsetX + (direction % 2 == 0 ? alignX : alignY), rotationOffsetY + (direction % 2 == 0 ? alignY : alignX), rotationOffsetZ + alignZ];

    //Grid offset
    gridOffsetX = offset[0] * gridSizeXY - (rotationOffsetRevert ? rotationOffsetX : 0);
    gridOffsetY = offset[1] * gridSizeXY - (rotationOffsetRevert ? rotationOffsetY : 0);
    gridOffsetZ = offset[2] * gridSizeZ - (rotationOffsetRevert ? rotationOffsetZ : 0); 

    //Children alignment
    alignmentChildren = is_string(alignChildren) ? [alignChildren, alignChildren, alignChildren] : alignChildren;
    translateXChildren = ((alignmentChildren[0] == "center" || alignmentChildren[0] == "ccs") ? 0 : ((alignmentChildren[0] == "start" ? -1 : 1) * 0.5*objectSizeX));
    translateYChildren = ((alignmentChildren[1] == "center" || alignmentChildren[0] == "ccs") ? 0 : ((alignmentChildren[1] == "start" ? -1 : 1) * 0.5*objectSizeY));
    translateZChildren = (alignmentChildren[2] == "center" ? 0 : ((alignmentChildren[2] == "start" || alignmentChildren[2] == "ccs")  ? -0.5*resultingBaseHeight : -0.5*baseHeightAdjustment + 0.5*baseHeightResolved));
    
    //Base Cutout and Pit Depth
    topPlateHeight = baseTopPlateHeight * mbuToMm + baseTopPlateHeightAdjustment;
    baseCutoutMinDepth = unitGrid[1] * mbuToMm - topPlateHeight; // mm -- 1 plate minus topPlateHeight
    maxBaseCutoutDepth = baseCutoutMaxDepth * mbuToMm;  
    
    resultingPitDepth = recess ? (recessDepth != "auto" ? recessDepth : (resultingBaseHeight - topPlateHeight - (baseCutoutType == "none" ? 0 : baseCutoutMinDepth))) : 0;
    
    pWallThickness = mb_resolve_side_quad(recessWallThickness, 1);
    recWallThickness = mb_resolve_side_quad(recessWallThickness, gridSizeXY);
    recStudPaddingResolved = mb_resolve_side_quad(recessStudPadding, gridSizeXY);

    pitSizeX = objectSizeX - (recWallThickness[0] + recWallThickness[1]);
    pitSizeY = objectSizeY - (recWallThickness[2] + recWallThickness[3]);

    calculatedBaseCutoutDepth = resultingBaseHeight - topPlateHeight - resultingPitDepth;  
    resultingTopPlateHeight = topPlateHeight + ((maxBaseCutoutDepth > 0 && (calculatedBaseCutoutDepth > maxBaseCutoutDepth)) ? (calculatedBaseCutoutDepth - maxBaseCutoutDepth) : 0);
    baseCutoutDepth = baseCutoutType == "none" ? 0 : ((maxBaseCutoutDepth > 0 && (calculatedBaseCutoutDepth > maxBaseCutoutDepth)) ? maxBaseCutoutDepth : calculatedBaseCutoutDepth);
    
    //Default diameter of pins and stud holes
    //Default thickness of a base wall multiplied by 2
    pDiameter = unitGrid[0] - studDiameter;

    wallThicknessOrg = (baseWallThickness == "auto" ? 0.5 * pDiameter : baseWallThickness) * mbuToMm;
    wallThickness = wallThicknessOrg + baseWallThicknessAdjustment;
    baseClampWallThickness = wallThickness + baseClampThickness;

    baseRoundingRadiusResolved = mb_base_rounding_radius(baseRoundingRadius, gridSizeXY * min(adjustedSizeRelation[0], adjustedSizeRelation[1]), gridSizeZ * adjustedSizeRelation[2]);
    baseRoundingRadiusZ = baseRoundingRadiusResolved[2];
    
    textureRoundingRadius = mb_base_cutout_radius(-0.5 * wallThickness, baseRoundingRadiusZ, minObjectSide);
    cutoutRoundingRadius = mb_base_cutout_radius(baseCutoutRoundingRadius == "auto" ? -wallThickness : mb_rounding_radius(baseCutoutRoundingRadius, gridSizeXY), baseRoundingRadiusZ, minObjectSide);
    
    minCutoutSide = min(objectSizeX - 2*wallThickness, objectSizeY - 2*wallThickness);
    cutoutClampRoundingRadius = baseClampThickness > 0 ? mb_base_cutout_radius(-baseClampThickness, cutoutRoundingRadius, minCutoutSide) : cutoutRoundingRadius;

    baseClampThicknessOuter = baseClampOuter ? baseClampThickness : 0;
    bClampOffset = baseClampOffset * mbuToMm;
    bClampHeight = baseClampHeight * mbuToMm;
                                    
    //Calculate Z Positions
    baseCutoutZ = -0.5 * (resultingBaseHeight - baseCutoutDepth);        
    topPlateZ = baseCutoutZ + 0.5 * (resultingBaseHeight - resultingPitDepth);
    xyScrewHolesZ = -0.5 * resultingBaseHeight + 0.5 * gridSizeZ;
    pitFloorZ = 0.5 * resultingBaseHeight - resultingPitDepth;

    
    //Bevel
    beveled = bevel != [[0, 0], [0, 0], [0, 0], [0, 0]];
    bevelOuter = mb_resolve_bevel_horizontal(bevel, grid, gridSizeXY);
    bevelCrop = mb_inset_quad_lrfh(bevelOuter, cropResolved);
    bevelOuterAdjusted = mb_inset_quad_lrfh(bevelOuter, [-sAdjustment[0], -sAdjustment[1], -sAdjustment[2], -sAdjustment[3]]);
    bevelInner = mb_inset_quad_lrfh(bevelOuter, wallThickness);
    bevelInnerOrg = mb_inset_quad_lrfh(bevelOuter, wallThicknessOrg);
    bevelTexture = mb_inset_quad_lrfh(bevelOuter, 0.5*wallThickness);
    
    corners = mb_resolve_bevel_horizontal([[0,0],[0,0],[0,0],[0,0]], grid, gridSizeXY);
    cornersInner = mb_inset_quad_lrfh(corners, wallThickness);
    cornersInnerOrg = mb_inset_quad_lrfh(corners, wallThicknessOrg);

    //cornersCutout = mb_resolve_bevel_horizontal([[0,0],[0,0],[0,0],[0,0]], cutout, gridSizeXY);

    // Pit
    pBevelPad =  [(recWallThickness[0] + recStudPaddingResolved[0]), (recWallThickness[1] + recStudPaddingResolved[1]), (recWallThickness[2] + recStudPaddingResolved[2]), (recWallThickness[3] + recStudPaddingResolved[3])];
    pitBevel = mb_inset_quad_lrfh(bevelOuter, [recWallThickness[0]+studMaxOverhang, recWallThickness[1]+studMaxOverhang, recWallThickness[2]+studMaxOverhang, recWallThickness[3]+studMaxOverhang]);
    pitBevelPadding = mb_inset_quad_lrfh(bevelOuter, pBevelPad);
    cornersPitPadding = mb_inset_quad_lrfh(corners, pBevelPad);
    
    pMinThickness = [
        -min(recWallThickness[2], recWallThickness[0]), 
        -min(recWallThickness[0], recWallThickness[3]), 
        -min(recWallThickness[3], recWallThickness[1]), 
        -min(recWallThickness[1], recWallThickness[2])
    ];
    pitRadius = mb_base_cutout_radius(recessRoundingRadius == "auto" ? pMinThickness : mb_rounding_radius(recessRoundingRadius, gridSizeXY), baseRoundingRadiusZ, minObjectSide);            
    
    // Studs
    knobSizeOrg = studDiameter * mbuToMm;
    knobSize = knobSizeOrg + studDiameterAdjustment;
    knobHeightOrg = studHeight * mbuToMm;
    knobHeight = knobHeightOrg + studHeightAdjustment;

    knobCutSize = knobSizeOrg + studCutoutAdjustment[0];
    knobCutHeight = knobHeightOrg + studCutoutAdjustment[1];
    knobHoleSize = (studHoleDiameter == "auto" ? pDiameter : studHoleDiameter) * mbuToMm + studHoleDiameterAdjustment;

    knobRounding = studRounding * mbuToMm;
    knobSink = studSink * mbuToMm;
    knobPartsOverlap = 0.01;

    //Knob Padding
    knobPaddingResolved = mb_resolve_side_quad(studPadding, gridSizeXY);
    bevelKnobPadding = mb_inset_quad_lrfh(bevelCrop, knobPaddingResolved);
    cornersKnobPadding = mb_inset_quad_lrfh(corners, knobPaddingResolved);
    knobPaddingRadiusInv = [
        -min(knobPaddingResolved[2], knobPaddingResolved[0]), 
        -min(knobPaddingResolved[0], knobPaddingResolved[3]), 
        -min(knobPaddingResolved[3], knobPaddingResolved[1]),
        -min(knobPaddingResolved[1], knobPaddingResolved[2])
    ];
    knobPaddingRoundingRadius = mb_base_rel_radius(knobPaddingRadiusInv, baseRoundingRadiusZ, minObjectSide, true);

    // Tubes XYZ
    tubeDiameter = studDiameter + 2 * tubeWallThickness;
    tubeXSize = (tubeXDiameter == "auto" ? tubeDiameter : tubeXDiameter) * mbuToMm + tubeXDiameterAdjustment;
    tubeYSize = (tubeYDiameter == "auto" ? tubeDiameter : tubeYDiameter) * mbuToMm + tubeYDiameterAdjustment;
    tubeZSize = (tubeZDiameter == "auto" ? tubeDiameter : tubeZDiameter) * mbuToMm + tubeZDiameterAdjustment;
    
    // Pin
    pinSize = (pinDiameter == "auto" ? pDiameter : pinDiameter) * mbuToMm + pinDiameterAdjustment;
    
    //Holes XYZ
    holeXDiameterResolved = (holeXDiameter == "auto" ? studDiameter : holeXDiameter) * mbuToMm;
    holeXSize = holeXDiameterResolved + holeXDiameterAdjustment;

    holeXInsetThicknessFinal = holeXInsetThickness * mbuToMm + holeXInsetThicknessAdjustment;
    holeXMaxRows = mb_vertical_hole_count(
        rect_height = baseHeightResolved,
        first_hole_center_from_bottom = holeXGridOffsetZ * mbuToMm,
        hole_diameter = holeXDiameterResolved + holeXInsetThickness * mbuToMm,
        hole_center_spacing = holeXGridSizeZ * mbuToMm,
        min_top_margin = holeXMinTopMargin * mbuToMm
    );

    holeYDiameterResolved = (holeYDiameter == "auto" ? studDiameter : holeYDiameter) * mbuToMm;
    holeYSize = holeYDiameterResolved + holeYDiameterAdjustment;

    holeYInsetThicknessFinal = holeYInsetThickness * mbuToMm + holeYInsetThicknessAdjustment;
    holeYMaxRows = mb_vertical_hole_count(
        rect_height = baseHeightResolved,
        first_hole_center_from_bottom = holeYGridOffsetZ * mbuToMm,
        hole_diameter = holeYDiameterResolved + holeYInsetThickness * mbuToMm,
        hole_center_spacing = holeYGridSizeZ * mbuToMm,
        min_top_margin = holeYMinTopMargin * mbuToMm
    );

    holeZDiameterResolved = (holeZDiameter == "auto" ? studDiameter : holeZDiameter) * mbuToMm;
    holeZSize = holeZDiameterResolved + holeZDiameterAdjustment;

    holeZCenteredX = (holeZShift == true || holeZShift == "x" || holeZShift == "xy");
    holeZCenteredY = (holeZShift == true || holeZShift == "y" || holeZShift == "xy");
    
    //Stabilizer
    sGridThickness = stabilizerGridThickness * mbuToMm;
    sGridHeight = stabilizerGridHeight * mbuToMm;
    
    //Tongue
    tonHeightCalc = tongueHeight * mbuToMm;
    tonThicknessCalc = tongueThickness * mbuToMm;
    tonOffsetCalc = tongueOffset * mbuToMm;
    tonClampHeightCalc = tongueClampHeight * mbuToMm;
    tonClampOffsetCalc = tongueClampOffset * mbuToMm;
    tonGrooveDepthCalc = tongueGrooveDepth * mbuToMm;

    txtDepth = textDepth * mbuToMm;

    grilleSmall = grilleDepth * mbuToMm < resultingTopPlateHeight;

    //Decorator Rotations
    decoratorRotations = [[90, 0, -90], [90, 0, 90], [90, 0, 0], [90, 0, 180], [0, 180, 180], [0, 0, 0]];

    //Surface Pattern
    surfacePatternSide = 5;
    
    //Grid
    startX = 0;
    midX = floor(0.5 * grid[0] - 1);
    endX = grid[0] - 1;
    
    startY = 0;
    midY = floor(0.5 * grid[1] - 1);
    endY = grid[1] - 1;
            
    mid = [midX, midY];
    
    offsetX = 0.5 * (grid[0] - 1);
    offsetY = 0.5 * (grid[1] - 1);

    holeXStart = holeXShift ? (holeXPartial == "start" || holeXPartial == "all" ? -1 : startX) : startX;
    holeXEnd = holeXShift ? (holeXPartial == "end" || holeXPartial == "all" ? floor(endX) : round(endX) - 1) : (holeXPartial == "end" || holeXPartial == "all" ? floor(endX) + 1 : floor(endX));

    holeYStart = holeYShift ? (holeYPartial == "start" || holeYPartial == "all" ? -1 : startY) : startY;
    holeYEnd = holeYShift ? (holeYPartial == "end" || holeYPartial == "all" ? floor(endY) : round(endY) - 1) : (holeYPartial == "end" || holeYPartial == "all" ? floor(endY) + 1 : floor(endY));

    holeZStartX = holeZCenteredX ? (holeZPartialX == "start" || holeZPartialX == "all" ? -1 : startX) : startX;
    holeZEndX = holeZCenteredX ? (holeZPartialX == "end" || holeZPartialX == "all" ? floor(endX) : round(endX) - 1) : (holeZPartialX == "end" || holeZPartialX == "all" ? floor(endX) + 1 : floor(endX));

    holeZStartY = holeZCenteredY ? (holeZPartialY == "start" || holeZPartialY == "all" ? -1 : startY) : startY;
    holeZEndY = holeZCenteredY ? (holeZPartialY == "end" || holeZPartialY == "all" ? floor(endY) : round(endY) - 1) : (holeZPartialY == "end" || holeZPartialY == "all" ? floor(endY) + 1 : floor(endY));

    pillarStartX = min(holeZStartX, startX);
    pillarEndX = max(holeZEndX, ceil(endX) - 1);

    pillarStartY = min(holeZStartY, startY);
    pillarEndY = max(holeZEndY, ceil(endY) - 1);

    /*
    * START Functions
    */
    

    function posX(a) = (a - offsetX) * gridSizeXY;
    function posY(b) = (b - offsetY) * gridSizeXY;

    function sideX(side) = 0.5 * (sAdjustment[1] - sAdjustment[0]) + (side - 0.5) * objectSizeXAdjusted;
    function sideY(side) = 0.5 * (sAdjustment[3] - sAdjustment[2]) + (side - 0.5) * objectSizeYAdjusted;
    function sideZ(side) = (side - 0.5) * resultingBaseHeight;

    /*
    * Grid
    */
    function inGridArea(a, b, rect) = (a >= rect[0]) && (b >= rect[1]) && (a <= rect[2]) && (b <= rect[3]); //[x0, y0, x1, y1]
    function getGridItem(items, defaultValue, a, b, i, prev) = (is_bool(items) ? (items == false ? false : defaultValue) : ((i >= len(items)) ? prev : getGridItem(items, defaultValue, a, b, i+1, is_bool(items[i]) ? (items[i] == false ? false : defaultValue) : (inGridArea(a, b, items[i]) ? (items[i][4] == undef ? defaultValue : items[i][4]) : prev))));
    
    /*
    * Slope
    */
    function smx(s, inv=false) = max(inv ? -s : s, 0);
    function onSlope(a, b, inv, qx, qy) = (slope != false) && (slope != [0, 0, 0, 0]) && !inGridArea(a, b, [smx(slope[0], inv), smx(slope[2], inv), ceil(grid[0]) - smx(slope[1], inv) - (inv ? qx : 1), ceil(grid[1]) - smx(slope[3], inv) - (inv ? qy : 1)]);

    
    /*
    * Pillars / Pins
    */
    function isCornerZone(value, i) = (value < pillarGapCornerLength) || (value >= grid[i] - (pillarGapCornerLength + 1)); 
    function isMiddleZone(value, i) = (grid[i] >= pillarGapMiddle) && (value>=mid[i]-1) && (value<=mid[i]+1);
    function isMiddle(value, i) = (grid[i] >= pillarGapMiddle) && (value == mid[i]);
    
    function drawCornerPillar(a, b) = isCornerZone(a, 0) && isCornerZone(b, 1);
    
    function drawMiddlePillar(a, b) = (isMiddle(a, 0) && (isMiddleZone(b, 1) || isCornerZone(b, 1)))
                                        || (isMiddle(b, 1) && (isMiddleZone(a, 0) || isCornerZone(a, 0)));
    
    function drawPillarAuto(a, b) = ((a % 2==0) && (b % 2 == 0)) || drawCornerPillar(a, b) || drawMiddlePillar(a, b); 
    
    function drawPillar(a, b) = //(drawHoleZ(a, b) == false)
                                //&& 
                                !onSlope(a, b, true, 2, 2) 
                                && ((pillars == "auto" && drawPillarAuto(a, b)) || (pillars != "auto" && getGridItem(pillars, true, a, b, 0, false)));

    function drawPin(a, b, isX) = !onSlope(a, b, true, isX ? 2 : 0, isX ? 0 : 2) 
                                && ((pillars == "auto" && drawPillarAuto(a, b)) || (pillars != "auto" && getGridItem(pillars, true, a, b, 0, false)));

    
    /*
    * Pit
    */
    function onPitBorder(a, b) = mb_circle_in_convex_quad(bevelOuter, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)
                                && !mb_circle_in_convex_quad(pitBevel, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, touch=true, overhang=0);
    
    function inPit(a, b) = mb_circle_in_convex_quad(pitBevelPadding, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)
                        && mb_circle_in_rounded_rect(cornersPitPadding, pitRadius, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang);
    
    function inPitWallGaps(a, b, mx, i) = (i < len(recessWallGaps)) && (inPitWallGap(a, b, recessWallGaps[i], mx) || inPitWallGaps(a, b, mx, i+1));
    
    function mxRound(v, mx) = mx ? floor(v) : ceil(v);
    function inPitWallGap(a, b, gap, mx) = ((gap[0] == 0) && inPitWallGap0(a, b, gap, mx)) || ((gap[0] == 1) && inPitWallGap1(a, b, gap, mx)) || ((gap[0] == 2) && inPitWallGap2(a, b, gap, mx)) || ((gap[0] == 3) && inPitWallGap3(a, b, gap, mx));
    function inPitWallGap0(a, b, gap, mx) = (floor(a) >= 0) && (ceil(a) < floor(pWallThickness[0])) && (floor(b) >= mxRound(pWallThickness[2] + gap[1], mx)) && (ceil(b) < grid[1] - mxRound(pWallThickness[3] + gap[2], mx));                                
    function inPitWallGap1(a, b, gap, mx) = (floor(a) >= grid[0] - ceil(pWallThickness[1])) && (ceil(a) < grid[0]) && (floor(b) >= mxRound(pWallThickness[2] + gap[1], mx)) && (ceil(b) < grid[1] - mxRound(pWallThickness[3] + gap[2], mx));                                
    function inPitWallGap2(a, b, gap, mx) = (floor(b) >= 0) && (ceil(b) < floor(pWallThickness[2])) && (floor(a) >= mxRound(pWallThickness[0] + gap[1], mx)) && (ceil(a) < grid[0] - mxRound(pWallThickness[1] + gap[2], mx));                                
    function inPitWallGap3(a, b, gap, mx) = (floor(b) >= grid[1] - ceil(pWallThickness[3])) && (ceil(b) < grid[1]) && (floor(a) >= mxRound(pWallThickness[0] + gap[1], mx)) && (ceil(a) < grid[0] - mxRound(pWallThickness[1] + gap[2], mx));                                
    
    /*
    * Knobs
    */ 
    function drawStud(a, b) = 
            let(sType = getGridItem(studs, studType, a, b, 0, false))
            (sType != false
            && !onSlope(a, b, false, 2)
            && mb_circle_in_rounded_rect(cornersKnobPadding, knobPaddingRoundingRadius, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)
            && mb_circle_in_convex_quad(bevelKnobPadding, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang))
            ? sType : false;

    function knobZ(a, b) = (recess && inPit(a, b) ? pitFloorZ : 0.5 * resultingBaseHeight) - knobSink;
    function studType(ovStudType, a, b) = is_string(ovStudType) ? ovStudType : (recess && inPit(a, b) ? recessStudType : studType);

    /*
    * XYZ Holes
    */
    function drawHoleX(a, b) = getGridItem(holeX, holeXType, a, b, 0, false);
    function drawHoleY(a, b) = getGridItem(holeY, holeYType, a, b, 0, false);
    function drawHoleZ(a, b) = getGridItem(holeZ, holeZType, a, b, 0, false);

    /*
    * Wall Gaps
    */
    function drawWallGapX(a, side, i) = (i < len(baseWallGapsX)) ? ((baseWallGapsX[i][0] == a && (side == baseWallGapsX[i][1] || baseWallGapsX[i][1] == 2)) ? (baseWallGapsX[i][2] == undef ? 1 : baseWallGapsX[i][2]) : drawWallGapX(a, side, i+1)) : 0; 
    function drawWallGapY(a, side, i) = (i < len(baseWallGapsY)) ? ((baseWallGapsY[i][0] == a && (side == baseWallGapsY[i][1] || baseWallGapsY[i][1] == 2)) ? (baseWallGapsY[i][2] == undef ? 1 : baseWallGapsY[i][2]) : drawWallGapY(a, side, i+1)) : 0; 
    
    /*
    * Stabilizer Grid
    */
    function stabilizersXHeight(a) = sGridHeight + stabilizerGridOffset + (stabilizerExpansion > 0 && (holeX == false) && (((grid[0] > stabilizerExpansion + 1) && ((a % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[1] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * mbuToMm) - sGridHeight - stabilizerGridOffset, 0) : 0);
    function stabilizersYHeight(b) = sGridHeight + (stabilizerExpansion > 0 && (holeY == false) && (((grid[1] > stabilizerExpansion + 1) && ((b % stabilizerExpansion) == (stabilizerExpansion - 1))) || (grid[0] == 1)) ? max(baseCutoutDepth - (stabilizerExpansionOffset * mbuToMm) - sGridHeight, 0) : 0);
    
    /*
    * Screw Holes
    */
    function drawScrewHoleZ(a, b, i) = screwHolesZ == "all" || ((i < len(screwHolesZ)) && ( (a == screwHolesZ[i][0] && b == screwHolesZ[i][1]) || drawScrewHoleZ(a, b, i+1)));

    /*
    * Decorators
    */
    function decoratorX(side, depth, offsetHorizontal) = side < 2 ? ((depth > 0 ? (side - 0.5) * depth : 0) + sideX(side)) : offsetHorizontal * gridSizeXY;
    function decoratorY(side, depth, offsetVertical) = (side > 1 && side < 4) ? ((depth > 0 ? (side - 2 - 0.5) * depth : 0) + sideY(side - 2)) : (side > 3 && side < 6 ? offsetVertical*gridSizeXY : 0);
    function decoratorZ(side, depth, offsetVertical) = (side > 3 && side < 6) ? ((depth > 0 ? (side - 4 - 0.5) * depth : 0) + sideZ(side - 4)) : offsetVertical * gridSizeZ;
    
    /*
    * END Functions
    */

    echo(
        preview= $preview,
        previewQuality = previewQuality,
        grid=grid,
        baseHeight = resultingBaseHeight, 
        heightWithKnobs = resultingBaseHeight + knobHeight,
        size = [objectSizeX, objectSizeY],
        sizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
        topPlateHeight = topPlateHeight,
        resultingTopPlateHeight = resultingTopPlateHeight, 
        baseCutoutDepth = baseCutoutDepth,
        baseCutoutMinDepth = baseCutoutMinDepth,
        slopeBaseHeightLower = slopeBaseHeightLower * mbuToMm,
        recessDepth = resultingPitDepth, 
        knobSize = knobSize,
        knobHeight = knobHeight,
        wallThickness = wallThickness,
        baseClampWallThickness = baseClampWallThickness,
        baseCutoutZ = baseCutoutZ, 
        topPlateZ = topPlateZ, 
        tubeDiameter = tubeDiameter,
        tubeXSize = tubeXSize,
        tubeYSize = tubeYSize,
        tubeZSize = tubeZSize,
        xyScrewHolesZ = xyScrewHolesZ,
        pitFloorZ = pitFloorZ,
        beveled = beveled,
        bevel = bevel,
        bevelOuterAdjusted = bevelOuterAdjusted,
        baseRoundingRadiusZ = baseRoundingRadiusZ,
        adjustedSizeRelation = adjustedSizeRelation,
        direction = direction,
        directionRotationZ = directionRotationZ
    );

    /*
    * START BLOCK
    */
    
    translate([gridOffsetX, gridOffsetY, gridOffsetZ]){
        rotate(rotation){
            translate(preRotationOffset){
                rotate([0, 0, directionRotationZ]){
                    union(){ // Final union
                        mb_pre_render(previewRender, previewRenderConvexity){
                            
                            if(base){
                                difference(){
                                    color(baseColor){
                                        union(){
                                            if(baseCutoutType == "standard"){
                                                difference() {
                                                    /*
                                                    * Base Block
                                                    */
                                                    mb_base(
                                                        grid = grid,
                                                        gridSizeXY = gridSizeXY,
                                                        gridSizeZ = gridSizeZ,
                                                        objectSize = [objectSizeX, objectSizeY],
                                                        height = resultingBaseHeight,
                                                        baseSideAdjustment = sAdjustment,
                                                        baseReliefCut = baseReliefCut,
                                                        baseReliefCutHeight = baseReliefCutHeight * mbuToMm,
                                                        baseReliefCutThickness = baseReliefCutThickness * mbuToMm,
                                                        baseClampHeight = bClampHeight,
                                                        baseClampThicknessOuter = baseClampThicknessOuter,
                                                        baseClampOffset = bClampOffset,
                                                        baseRoundingRadius = baseRoundingRadiusResolved,

                                                        pit = recess,
                                                        pitRoundingRadius = recessRoundingRadius,
                                                        pitDepth = resultingPitDepth,
                                                        pitWallThickness = recWallThickness,
                                                        pitWallGaps = recessWallGaps,
                                                        
                                                        slope = slope,
                                                        slopeBaseHeightLower = slopeBaseHeightLower * mbuToMm,
                                                        slopeBaseHeightUpper = slopeBaseHeightUpper * mbuToMm,
                                                        
                                                        beveled = beveled,
                                                        bevelOuter = bevelOuter,
                                                        bevelOuterAdjusted = bevelOuterAdjusted,
                                                        
                                                        connectors = connectors,
                                                        connectorPadding = connectorPadding,
                                                        connectorHeight = connectorHeight == "auto" ? "auto" : connectorHeight * mbuToMm,
                                                        connectorDepth = connectorDepth * mbuToMm,
                                                        connectorSize = connectorWidth * mbuToMm,
                                                        connectorDepthTolerance = connectorDepthTolerance,
                                                        connectorSideTolerance = connectorSideTolerance,

                                                        qualitySegBase = qualitySegBase,
                                                        qualityFactor = qualityFactor,
                                                        qualityResolutionMin = qualityResolutionMin,
                                                        qualityResolutionMax = qualityResolutionMax,
                                                        qualityResolutionMultiplier = qualityResolutionMultiplier,
                                                        previewQuality = previewQuality
                                                    );

                                                    /*
                                                    * Subtract base cutout
                                                    */
                                                    difference(){
                                                        union(){
                                                            mb_base_cutout(
                                                                grid = grid,
                                                                gridSizeXY = gridSizeXY,
                                                                
                                                                baseHeight = resultingBaseHeight,
                                                                baseSideAdjustment = sAdjustment,
                                                                baseRoundingRadiusZ = baseRoundingRadiusZ,
                                                                baseCutoutDepth = baseCutoutDepth,
                                                                baseClampHeight = bClampHeight,
                                                                baseClampThickness = baseClampThickness,
                                                                baseClampOffset = bClampOffset,
                                                                
                                                                cutoutRoundingRadius = cutoutRoundingRadius,
                                                                cutoutClampRoundingRadius = cutoutClampRoundingRadius,
                                                                
                                                                wallThickness = wallThickness,
                                                                
                                                                topPlateZ = topPlateZ,
                                                                topPlateHeight = resultingTopPlateHeight,
                                                                topPlateHelpers = topPlateHelpers,
                                                                topPlateHelperHeight = topPlateHelperHeight,
                                                                topPlateHelperThickness = topPlateHelperThickness,
                                                                
                                                                pit = recess,
                                                                pitDepth = resultingPitDepth,
                                                                
                                                                slope = slope,
                                                                slopeBaseHeightLowerInner = slopeBaseHeightLowerInner * mbuToMm,
                                                                
                                                                beveled = beveled,
                                                                bevelOuter = bevelOuter,
                                                                bevelInner = bevelInner,

                                                                qualitySegBase = qualitySegBase,
                                                                qualityFactor = qualityFactor,
                                                                qualityResolutionMin = qualityResolutionMin,
                                                                qualityResolutionMax = qualityResolutionMax,
                                                                qualityResolutionMultiplier = qualityResolutionMultiplier,
                                                                previewQuality = previewQuality
                                                            );

                                                            /*
                                                            * Grille
                                                            */
                                                            if(grille != "none"){
                                                                grilleHeight = grilleDepth * mbuToMm + cutOffset;
                                                                color(baseColor){
                                                                    if(grille == "x"){
                                                                        grilleWidthY = size[1] * unitGrid[0] * mbuToMm / grilleCount;
                                                                        for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                                            if(g % 2 == (grilleInverted ? 0 : 1)){
                                                                                translate([0, sideY(0) + (0.5 + g) * grilleWidthY, 0.5 * (resultingBaseHeight - grilleHeight + cutOffset)])
                                                                                    cube(size=[objectSizeXAdjusted*cutMultiplier, grilleWidthY, grilleHeight+ cutOffset], center=true);
                                                                            }
                                                                        }
                                                                    }
                                                                    else if(grille == "y"){
                                                                        grilleWidthX = size[0] * unitGrid[0] * mbuToMm / grilleCount;
                                                                        for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                                            if(g % 2 == (grilleInverted ? 0 : 1)){
                                                                                translate([sideX(0) + (0.5 + g) * grilleWidthX, 0, 0.5 * (resultingBaseHeight - grilleHeight + cutOffset)])
                                                                                    cube(size=[grilleWidthX, objectSizeYAdjusted*cutMultiplier, grilleHeight+ cutOffset], center=true);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                            /*
                                                            * Wall Gaps X
                                                            */
                                                            for (a = [ startX : 1 : endX ]){
                                                                for (side = [ 0 : 1 : 1 ]){
                                                                    gapLength = drawWallGapX(a, side, 0);
                                                                    if(gapLength > 0){
                                                                        translate([posX(a + 0.5*(gapLength-1)), sideY(side), baseCutoutZ]){
                                                                            difference(){
                                                                                translate([0, 0, -0.5 * cutOffset])
                                                                                    cube([gapLength*gridSizeXY - 2*wallThickness + cutTolerance, 2 * (baseClampWallThickness + sAdjustment[2 + side] + cutTolerance), baseCutoutDepth + cutOffset], center=true); 
                                                                                
                                                                                translate([-0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight) ]) 
                                                                                    cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                            
                                                                            
                                                                                translate([0.5 * (gapLength*gridSizeXY - 2*wallThickness), 0, (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight) ]) 
                                                                                    cube([2*baseClampThickness, 2*(baseClampWallThickness + sAdjustment[2 + side]) * cutMultiplier, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                            }  
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                            }
                                                            
                                                            /*
                                                            * Wall Gaps Y
                                                            */
                                                            for (b = [ startY : 1 : endY ]){
                                                                for (side = [ 0 : 1 : 1 ]){
                                                                    gapLength = drawWallGapY(b, side, 0);
                                                                    if(gapLength > 0){
                                                                        translate([sideX(side), posY(b + 0.5*(gapLength-1)), baseCutoutZ]){
                                                                            difference(){
                                                                                translate([0, 0, -0.5 * cutOffset])
                                                                                    cube([2 * (baseClampWallThickness + sAdjustment[side] + cutTolerance), gapLength*gridSizeXY - 2 * wallThickness + cutTolerance, baseCutoutDepth + cutOffset], center=true);   
                                                                                
                                                                                translate([0, -0.5 * (gapLength*gridSizeXY - 2 * wallThickness), (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight)]) 
                                                                                    cube([2*(baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                            
                                                                                translate([0, 0.5 * (gapLength*gridSizeXY - 2 * wallThickness), (bClampOffset > 0 ? bClampOffset : - 0.5 * cutOffset) - 0.5 * (baseCutoutDepth - bClampHeight)]) 
                                                                                    cube([2 * (baseClampWallThickness + sAdjustment[side]) * cutMultiplier, 2 * baseClampThickness, bClampHeight + (bClampOffset > 0 ? 0 : cutOffset) + cutTolerance], center=true);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } // End union cutout

                                                        /*
                                                        * Plate Helpers
                                                        */
                                                        if(topPlateHelpers && (grille == "none" || grilleSmall)){
                                                            bevelTopPlateHelper = mb_inset_quad_lrfh(bevelOuter, wallThickness + topPlateHelperThickness);
                                                            topPlateHelperRoundingRadius = mb_base_cutout_radius(- wallThickness - topPlateHelperThickness, baseRoundingRadiusZ, minObjectSide);
                                                            
                                                            topPlateHelperRoundingRadiusQuality = mb_fn_even_for_radius(
                                                                topPlateHelperRoundingRadius, 
                                                                2, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            translate([0, 0, topPlateZ - 0.5 * (resultingTopPlateHeight + topPlateHelperHeight) + 0.5 * cutOffset]){
                                                                difference(){
                                                                    cube(
                                                                        size = [objectSizeX, objectSizeY, topPlateHelperHeight + cutOffset], 
                                                                        center=true
                                                                    );

                                                                    mb_beveled_rounded_block(
                                                                        bevel = beveled ? bevelTopPlateHelper : false,
                                                                        sizeX = objectSizeX - 2*wallThickness - 2*topPlateHelperThickness,
                                                                        sizeY = objectSizeY - 2*wallThickness - 2*topPlateHelperThickness,
                                                                        height = cutMultiplier * (topPlateHelperHeight + cutOffset),
                                                                        roundingRadius = topPlateHelperRoundingRadius == 0 ? 0 : [0, 0, topPlateHelperRoundingRadius],
                                                                        roundingResolution = topPlateHelperRoundingRadiusQuality
                                                                    );

                                                                    for (a = [ startX : 1 : endX ]){
                                                                        for (side = [ 0 : 1 : 1 ]){
                                                                            gapLength = drawWallGapX(a, side, 0);
                                                                            if(gapLength > 0){
                                                                                translate([posX(a + 0.5*(gapLength-1)), sideY(side), 0]){
                                                                                    cube([
                                                                                        gapLength*gridSizeXY - 2*wallThickness - 2*topPlateHelperThickness + cutTolerance, 
                                                                                        2*(wallThickness + topPlateHelperThickness) + cutTolerance, 
                                                                                        cutMultiplier * (topPlateHelperHeight + cutOffset)
                                                                                    ], center=true); 
                                                                                }
                                                                            }
                                                                        }
                                                                    }

                                                                    for (b = [ startY : 1 : endY ]){
                                                                        for (side = [ 0 : 1 : 1 ]){
                                                                            gapLength = drawWallGapY(b, side, 0);
                                                                            if(gapLength > 0){
                                                                                translate([sideX(side), posY(b + 0.5*(gapLength-1)), 0]){
                                                                                    cube([
                                                                                        2*(wallThickness + topPlateHelperThickness) + cutTolerance, 
                                                                                        gapLength*gridSizeXY - 2*wallThickness - 2*topPlateHelperThickness + cutTolerance, 
                                                                                        cutMultiplier * (topPlateHelperHeight + cutOffset)
                                                                                    ], center=true);   
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } // End if topPlateHelpers

                                                        if(stabilizerGrid){
                                                            
                                                            difference(){
                                                                /*
                                                                * Stabilizer Grid
                                                                */
                                                                union(){
                                                                    if(grille == "none" || grille == "x" || grilleSmall){
                                                                        //Helpers X
                                                                        for (a = [ 0 : 1 : grid[0] - 2 ]){
                                                                            translate([posX(a + 0.5), 0, topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersXHeight(a)) + 0.5 * cutOffset]){ 
                                                                                cube([sGridThickness, objectSizeY, stabilizersXHeight(a) + cutOffset], center = true);
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                    if(grille == "none" || grille == "y" || grilleSmall){
                                                                        //Helpers Y
                                                                        for (b = [ 0 : 1 : grid[1] - 2 ]){
                                                                        translate([0, posY(b + 0.5), topPlateZ - 0.5 * (resultingTopPlateHeight + stabilizersYHeight(b)) + 0.5 * cutOffset]){
                                                                                cube([objectSizeX, sGridThickness, stabilizersYHeight(b) + cutOffset], center = true);
                                                                            };
                                                                        }
                                                                    }

                                                                    if(grille == "none" || grilleSmall){
                                                                        /*
                                                                        * Screw Hole Helpers
                                                                        */
                                                                        for (a = [ startX : 1 : endX ]){
                                                                            for (b = [ startY : 1 : endY ]){
                                                                                if(drawScrewHoleZ(a, b, 0)){
                                                                                    translate([posX(a), posY(b)-0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                                                        cube([gridSizeXY - sGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);
                                                                                    translate([posX(a), posY(b)+0.5*(screwHoleZSize + screwHoleZHelperThickness), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight + screwHoleZHelperOffset)])
                                                                                        cube([gridSizeXY - sGridThickness, screwHoleZHelperThickness, screwHoleZHelperHeight + screwHoleZHelperOffset], center = true);    
                                                                                    translate([posX(a)-0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                                                        cube([screwHoleZHelperThickness, gridSizeXY - sGridThickness, screwHoleZHelperHeight], center = true);
                                                                                    translate([posX(a)+0.5*(screwHoleZSize + screwHoleZHelperThickness), posY(b), topPlateZ - 0.5 * (resultingTopPlateHeight + screwHoleZHelperHeight)])
                                                                                        cube([screwHoleZHelperThickness, gridSizeXY - sGridThickness, screwHoleZHelperHeight], center = true);    
                                                                                } 
                                                                            }
                                                                        }
                                                                    }
                                                                } // End union stabilizer grid

                                                                /*
                                                                * Pillar cutouts from stabilizer grid
                                                                */
                                                                if(pillars != false){
                                                                    cutoutHoleZRoundingRes = mb_fn_even_for_radius(
                                                                        0.5 * holeZSize, 
                                                                        2, 
                                                                        qualitySegBase,
                                                                        qualityFactor,
                                                                        qualityResolutionMin,
                                                                        qualityResolutionMax,
                                                                        qualityResolutionMultiplier,
                                                                        previewQuality
                                                                    );
                                                                    /*
                                                                    * Cut TubeZ area
                                                                    */
                                                                    
                                                                    for (a = [ pillarStartX : 1 : pillarEndX ]){
                                                                        for (b = [ pillarStartY : 1 : pillarEndY ]){
                                                                            if(drawPillar(a, b)){
                                                                                    translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ + cutTolerance]){
                                                                                        cylinder(h=baseCutoutDepth + 2 * cutOffset, r=0.5 * holeZSize, center=true, $fn=cutoutHoleZRoundingRes);
                                                                                    };
                                                                            }
                                                                        }   
                                                                    }

                                                                    for (a = [ startX : 1 : endX ]){
                                                                        for (side = [ 0 : 1 : 1 ]){
                                                                            gapLength = drawWallGapX(a, side, 0);

                                                                            if(gapLength > 1){
                                                                                for (p = [ 0 : 1 : gapLength - 2 ]){
                                                                                    if(side == 0 || side == 2){
                                                                                        translate([posX(a + p + 0.5), posY(-0.5), baseCutoutZ + cutTolerance]){
                                                                                            cylinder(h=baseCutoutDepth + 2 * cutOffset, r=0.5 * holeZSize, center=true, $fn=cutoutHoleZRoundingRes);
                                                                                        };
                                                                                    }
                                                                                    if(side == 1 || side == 2){
                                                                                        translate([posX(a + p + 0.5), posY(endY + 0.5), baseCutoutZ + cutTolerance]){
                                                                                            cylinder(h=baseCutoutDepth + 2 * cutOffset, r=0.5 * holeZSize, center=true, $fn=cutoutHoleZRoundingRes);
                                                                                        };
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }

                                                                    for (b = [ startY : 1 : endY ]){
                                                                        for (side = [ 0 : 1 : 1 ]){
                                                                            gapLength = drawWallGapY(b, side, 0);

                                                                            if(gapLength > 1){
                                                                                for (p = [ 0 : 1 : gapLength - 2 ]){
                                                                                    if(side == 0 || side == 2){
                                                                                        translate([posX(-0.5), posY(b + p + 0.5), baseCutoutZ + cutTolerance]){
                                                                                            cylinder(h=baseCutoutDepth + 2 * cutOffset, r=0.5 * holeZSize, center=true, $fn=cutoutHoleZRoundingRes);
                                                                                        };
                                                                                    }
                                                                                    if(side == 1 || side == 2){
                                                                                        translate([posX(endX + 0.5), posY(b + p + 0.5), baseCutoutZ + cutTolerance]){
                                                                                            cylinder(h=baseCutoutDepth + 2 * cutOffset, r=0.5 * holeZSize, center=true, $fn=cutoutHoleZRoundingRes);
                                                                                        };
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                } // End Pillars Cutouts from stabilizer grid
                                                            } // End difference stabilizer Grid

                                                            
                                                        } // End stabilizer grid

                                                        if(pillars != false){
                                                            pilRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * tubeZSize + baseClampThickness, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            holeZRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * holeZSize, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            //Tubes with holes
                                                            for (a = [ pillarStartX : 1 : pillarEndX ]){
                                                                for (b = [ pillarStartY : 1 : pillarEndY ]){
                                                                    if(drawPillar(a, b)){
                                                                        translate([posX(a + 0.5), posY(b + 0.5), baseCutoutZ]){
                                                                            difference(){
                                                                                union(){
                                                                                    cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * tubeZSize, center=true, $fn=pilRoundingRes);
                                                                                    
                                                                                    //Clamp
                                                                                    translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                                        cylinder(h=bClampHeight, r=0.5 * tubeZSize + baseClampThickness, center=true, $fn=pilRoundingRes);
                                                                                }

                                                                                // Hollow only if there is no z-hole here
                                                                                if(drawHoleZ(a, b) == false || a > holeZEndX || b > holeZEndY){
                                                                                    intersection(){
                                                                                        cylinder(h=baseCutoutDepth*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=holeZRoundingRes);
                                                                                        cube([holeZSize-2*tubeInnerClampThickness, holeZSize-2*tubeInnerClampThickness, baseCutoutDepth *cutMultiplier], center=true);
                                                                                    };
                                                                                }
                                                                            }
                                                                        };
                                                                    }
                                                                }
                                                            }
                                                        } // End if pillars

                                                        if(pillars != false){
                                                            pinRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * pinSize + baseClampThickness, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            /*
                                                            * Middle Pins
                                                            */
                                                            //Middle Pin X
                                                            if(gridSizeX > 1 && gridSizeY == 1){
                                                                for (b = [ startY : 1 : ceil(endY) ]){
                                                                    for (a = [ startX : 1 : ceil(endX) - 1 ]){
                                                                        if(drawPin(a, b, true)){
                                                                            translate([posX(a + 0.5), posY(b), baseCutoutZ]){
                                                                                cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * pinSize, center=true, $fn=pinRoundingRes);
                                                                                translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                                    cylinder(h=bClampHeight, r=0.5 * pinSize + baseClampThickness, center=true, $fn=pinRoundingRes);
                                                                            };
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                            //Middle Pin Y
                                                            if(gridSizeX == 1 && gridSizeY > 1){
                                                                for (a = [ startX : 1 : ceil(endX)]){
                                                                    for (b = [ startY : 1 : ceil(endY) - 1 ]){
                                                                        if(drawPin(a, b, false)){
                                                                            translate([posX(a), posY(b + 0.5), baseCutoutZ]){
                                                                                cylinder(h=baseCutoutDepth * cutMultiplier, r=0.5 * pinSize, center=true, $fn=pinRoundingRes);
                                                                                translate([0, 0, bClampOffset + 0.5 * (bClampHeight - baseCutoutDepth)])
                                                                                    cylinder(h=bClampHeight, r=0.5 * pinSize + baseClampThickness, center=true, $fn=pinRoundingRes);
                                                                            };
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } // End if pillars
                                                        
                                                        //X-Holes Outer
                                                        if(holeX != false){
                                                            holeXRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * tubeXSize, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            for(r = [ 0 : 1 : holeXMaxRows-1]){
                                                                for (a = [ holeXStart : 1 : holeXEnd ]){
                                                                    if(drawHoleX(a, r) != false){
                                                                        translate([posX(a + (holeXShift ? 0.5 : 0)), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*mbuToMm + holeXGridOffsetZAdjustment + r * (holeXGridSizeZ*mbuToMm + holeXGridSizeZAdjustment)]){
                                                                            rotate([90, 0, 0]){ 
                                                                                cylinder(h=objectSizeY - 2*wallThickness, r=0.5 * tubeXSize, center=true, $fn=holeXRoundingRes);
                                                                            }
                                                                        };
                                                                    }
                                                                }
                                                            }
                                                        } // End if holeX
                                                        
                                                        //Y-Holes Outer
                                                        if(holeY != false){
                                                            holeYRoundingRes = mb_fn_even_for_radius(
                                                                0.5 * tubeYSize, 
                                                                0, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            for(r = [ 0 : 1 : holeYMaxRows-1]){
                                                                for (b = [ holeYStart : 1 : holeYEnd ]){
                                                                    if(drawHoleY(b, r) != false){
                                                                        translate([0, posY(b + (holeYShift ? 0.5 : 0)), -0.5*resultingBaseHeight + holeYGridOffsetZ*mbuToMm + holeYGridOffsetZAdjustment + r * (holeYGridSizeZ*mbuToMm + holeYGridSizeZAdjustment)]){
                                                                            rotate([0, 90, 0]){ 
                                                                                cylinder(h=objectSizeX - 2*wallThickness, r=0.5 * tubeYSize, center=true, $fn=holeYRoundingRes);
                                                                            };
                                                                        };
                                                                    }
                                                                }
                                                            }
                                                        } // End if holeY
                                                        
                                                    } // End Difference (subtract from cutout)
                                                } // End difference (subtract cutout from base)
                                            }
                                            else{
                                                /*
                                                * Solid Base Block
                                                */
                                                
                                                mb_base(
                                                    grid = grid,
                                                    gridSizeXY = gridSizeXY,
                                                    gridSizeZ = gridSizeZ,
                                                    objectSize = [objectSizeX, objectSizeY],
                                                    height = resultingBaseHeight,
                                                    baseSideAdjustment = sAdjustment,
                                                    baseReliefCut = baseReliefCut,
                                                    baseReliefCutHeight = baseReliefCutHeight * mbuToMm,
                                                    baseReliefCutThickness = baseReliefCutThickness * mbuToMm,
                                                    baseClampHeight = bClampHeight,
                                                    baseClampThicknessOuter = baseClampThicknessOuter,
                                                    baseClampOffset = bClampOffset,
                                                    baseRoundingRadius = baseRoundingRadiusResolved,

                                                    pit = recess,
                                                    pitRoundingRadius = recessRoundingRadius,
                                                    pitDepth = resultingPitDepth,
                                                    pitWallThickness = recWallThickness,
                                                    pitWallGaps = recessWallGaps,
                                                    
                                                    slope = slope,
                                                    slopeBaseHeightLower = slopeBaseHeightLower * mbuToMm,
                                                    slopeBaseHeightUpper = slopeBaseHeightUpper * mbuToMm,

                                                    beveled = beveled,
                                                    bevelOuter = bevelOuter,
                                                    bevelOuterAdjusted = bevelOuterAdjusted,
                                                    connectors = connectors,
                                                    connectorPadding = connectorPadding,
                                                    connectorHeight = connectorHeight == "auto" ? "auto" : connectorHeight * mbuToMm,
                                                    connectorDepth = connectorDepth * mbuToMm,
                                                    connectorSize = connectorWidth * mbuToMm,
                                                    connectorDepthTolerance = connectorDepthTolerance,
                                                    connectorSideTolerance = connectorSideTolerance,

                                                    qualitySegBase = qualitySegBase,
                                                    qualityFactor = qualityFactor,
                                                    qualityResolutionMin = qualityResolutionMin,
                                                    qualityResolutionMax = qualityResolutionMax,
                                                    qualityResolutionMultiplier = qualityResolutionMultiplier,
                                                    previewQuality = previewQuality
                                                );
                                            } //End baseCutoutType
                                            /*
                                            if(cutout != false && cutout != [0, 0]){
                                                translate([-rotationOffsetX - alignX, -rotationOffsetY - alignY, -rotationOffsetZ - alignZ]){
                                                    machineblock(
                                                        size = [cutout[0], cutout[1], size[2]],
                                                        studs = false,
                                                        crop = -0.2,
                                                        baseClampOuter=true,
                                                        baseCutoutType = "none"
                                                    );
                                                }
                                            }*/

                                        } //End base union
                                    } //End base color
                                    
                                    /*
                                    * Final Subtraction
                                    * Starting from here, everything applies to the final block
                                    *
                                    */

                                    if(baseCutoutType != "none" && baseCutoutType != "groove"){
                                        studRoundingRes = mb_fn_even_for_radius(
                                            0.5 * knobCutSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            /*
                                            * Knob subtraction from base
                                            */
                                            translate([0, 0, -0.5 * resultingBaseHeight + 0.5 * knobCutHeight - 0.5*cutOffset]){
                                                difference(){
                                                    union(){
                                                        for (a = [ startX : 1 : ceil(endX) ]){
                                                            for (b = [ startY : 1 : ceil(endY) ]){
                                                                if(baseCutoutType == "studs" || !mb_circle_in_rounded_rect(cornersInnerOrg, baseRoundingRadiusZ, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)
                                                                    || !mb_circle_in_convex_quad(bevelInnerOrg, [mb_grid_pos_x(a, grid, gridSizeXY), mb_grid_pos_y(b, grid, gridSizeXY)], 0.5*knobSizeOrg, overhang = studMaxOverhang)){
                                                                    translate([posX(a), posY(b), 0]){
                                                                        if(bClampOffset > 0){
                                                                            translate([0,0, -0.5 * (knobCutHeight - bClampOffset)])
                                                                                cylinder(h=bClampOffset + cutOffset, r=0.5 * knobCutSize, center=true, $fn=studRoundingRes);
                                                                        }
                                                                        //color("red")
                                                                        cylinder(h=knobCutHeight + cutOffset, r=0.5 * (knobCutSize - 2*baseClampThickness), center=true, $fn=studRoundingRes);
                                                                        
                                                                        //color("green")
                                                                        translate([0,0, 0.5*(knobCutHeight + cutOffset) - 0.5*(knobCutHeight - bClampOffset - bClampHeight)])
                                                                            cylinder(h=knobCutHeight - bClampOffset - bClampHeight, r=0.5 * knobCutSize, center=true, $fn=studRoundingRes);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } // End union

                                                    if(baseCutoutType != "studs"){
                                                        union(){
                                                            cutoutClampRoundingRadiusQuality = mb_fn_even_for_radius(
                                                                cutoutClampRoundingRadius, 
                                                                1, 
                                                                qualitySegBase,
                                                                qualityFactor,
                                                                qualityResolutionMin,
                                                                qualityResolutionMax,
                                                                qualityResolutionMultiplier,
                                                                previewQuality
                                                            );

                                                            mb_beveled_rounded_block(
                                                                bevel = beveled ? mb_inset_quad_lrfh(bevelOuter, baseClampWallThickness+cutTolerance) : false,
                                                                sizeX = objectSizeX - 2 * (baseClampWallThickness+cutTolerance),
                                                                sizeY = objectSizeY - 2 * (baseClampWallThickness+cutTolerance),
                                                                height = cutMultiplier * (knobCutHeight + cutOffset),
                                                                roundingRadius = cutoutClampRoundingRadius == 0 ? 0 : [0, 0, cutoutClampRoundingRadius],
                                                                roundingResolution = cutoutClampRoundingRadiusQuality
                                                            );
                                                        }
                                                    }
                                                } //End difference final cutout elements
                                            } // End translate
                                        }
                                    }

                                    //Cut X-Holes
                                    if(holeX != false){
                                        holeXRoundingRes = mb_fn_even_for_radius(
                                            0.5 * (holeXSize + 2 * holeXInsetThicknessFinal), 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            for(r = [ 0 : 1 : holeXMaxRows-1]){
                                                for (a = [ holeXStart : 1 : holeXEnd ]){
                                                    xHole = drawHoleX(a, r);
                                                    if(xHole != false){
                                                        translate([posX(a + (holeXShift ? 0.5 : 0)), 0, -0.5*resultingBaseHeight + holeXGridOffsetZ*mbuToMm + holeXGridOffsetZAdjustment + r * (holeXGridSizeZ*mbuToMm + holeXGridSizeZAdjustment)]){
                                                            rotate([90, 0, 0]){ 
                                                                if(xHole == true || xHole == "pin"){
                                                                    cylinder(h=objectSizeY*cutMultiplier, r=0.5 * holeXSize, center=true, $fn=holeXRoundingRes);
                                                                
                                                                    translate([0, 0, 0.5 * objectSizeY])
                                                                        cylinder(h=2 * (holeXInsetDepth * mbuToMm + holeXInsetDepthAdjustment), r=0.5 * (holeXSize + 2 * holeXInsetThicknessFinal), center=true, $fn=holeXRoundingRes);
                                                                    translate([0, 0, -0.5 * objectSizeY])
                                                                        cylinder(h=2 * (holeXInsetDepth * mbuToMm + holeXInsetDepthAdjustment), r=0.5 * (holeXSize + 2 * holeXInsetThicknessFinal), center=true, $fn=holeXRoundingRes);
                                                                
                                                                }
                                                                else if(xHole == "axle"){
                                                                    mb_axis(
                                                                        height = resultingBaseHeight * cutMultiplier, 
                                                                        capHeight=0, 
                                                                        size = holeXSize, 
                                                                        thickness = holeAxleThickness * mbuToMm,
                                                                        center=true, 
                                                                        alignBottom=false, 
                                                                        roundingResolution=holeXRoundingRes
                                                                    );
                                                                }
                                                            };
                                                        };
                                                    }
                                                }
                                            }
                                        } // End color
                                    } // End if holeX
                                    
                                    //Cut Y-Holes
                                    if(holeY != false){
                                        holeYRoundingRes = mb_fn_even_for_radius(
                                            0.5 * (holeYSize + 2 * holeYInsetThicknessFinal), 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            for(r = [ 0 : 1 : holeYMaxRows-1]){
                                                for (b = [ holeYStart : 1 : holeYEnd ]){
                                                    yHole = drawHoleY(b, r);
                                                    if(yHole != false){
                                                        translate([0, posY(b + (holeYShift ? 0.5 : 0)), -0.5*resultingBaseHeight + holeYGridOffsetZ*mbuToMm + holeYGridOffsetZAdjustment + r * (holeYGridSizeZ*mbuToMm + holeYGridSizeZAdjustment)]){
                                                            rotate([0, 90, 0]){ 
                                                                if(yHole == true || yHole == "pin"){
                                                                    cylinder(h=objectSizeX*cutMultiplier, r=0.5 * holeYSize, center=true, $fn=holeYRoundingRes);
                                                                
                                                                    translate([0, 0, 0.5 * objectSizeX])
                                                                        cylinder(h=2 * (holeYInsetDepth * mbuToMm + holeYInsetDepthAdjustment), r=0.5 * (holeYSize + 2 * holeYInsetThicknessFinal), center=true, $fn=holeYRoundingRes);
                                                                    translate([0, 0, -0.5 * objectSizeX])
                                                                        cylinder(h=2 * (holeYInsetDepth * mbuToMm + holeYInsetDepthAdjustment), r=0.5 * (holeYSize + 2 * holeYInsetThicknessFinal), center=true, $fn=holeYRoundingRes);
                                                                }
                                                                else if(yHole == "axle"){
                                                                    mb_axis(
                                                                        height = resultingBaseHeight * cutMultiplier, 
                                                                        capHeight=0, 
                                                                        size = holeYSize, 
                                                                        thickness = holeAxleThickness * mbuToMm,
                                                                        center=true, 
                                                                        alignBottom=false, 
                                                                        roundingResolution=holeYRoundingRes
                                                                    );
                                                                }
                                                            };
                                                        };
                                                    }
                                                }
                                            }
                                        } // End color
                                    } // End if holeY
                                    
                                    if(holeZ != false){
                                        holeZRoundingRes = mb_fn_even_for_radius(
                                            0.5 * holeZSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(baseColor){
                                            //Cut Z-Holes
                                            for (a = [ holeZStartX : 1 :  holeZEndX ]){
                                                for (b = [ holeZStartY : 1 : holeZEndY ]){
                                                    zHole = drawHoleZ(a, b);
                                                    if(zHole != false){
                                                        translate([posX(a + (holeZCenteredX ? 0.5 : 0)), posY(b+(holeZCenteredY ? 0.5 : 0)), 0]){
                                                            if(zHole == true || zHole == "pin"){
                                                                cylinder(h=resultingBaseHeight*cutMultiplier, r=0.5 * holeZSize, center=true, $fn=holeZRoundingRes);
                                                            }
                                                            else if(zHole == "axle"){
                                                                mb_axis(
                                                                    height = resultingBaseHeight * cutMultiplier, 
                                                                    capHeight=0, 
                                                                    size = holeZSize, 
                                                                    thickness = holeAxleThickness * mbuToMm,
                                                                    center = true, 
                                                                    alignBottom = false, 
                                                                    roundingResolution = holeZRoundingRes
                                                                );
                                                            }
                                                        };
                                                    }
                                                }
                                            }
                                        } // End color
                                    } // End if holeZ

                                    /*
                                    * Text Cutout
                                    */
                                    if(text != false && !mb_is_empty_string(text) && txtDepth < 0){
                                        color(textColor == "inherit" ? baseColor : textColor){
                                            translate([decoratorX(textSide, txtDepth, textOffset[0]), decoratorY(textSide, txtDepth, textOffset[1]), decoratorZ(textSide, txtDepth, textOffset[1])])
                                                rotate(decoratorRotations[textSide])
                                                    mb_text3d(
                                                        text = text,
                                                        textDepth = 2 * abs(txtDepth),
                                                        textSize = scale * textSize,
                                                        textFont = textFont,
                                                        textSpacing = textSpacing,
                                                        textVerticalAlign = textVerticalAlign,
                                                        textHorizontalAlign = textHorizontalAlign,
                                                        center = true
                                                    );
                                        } // End color
                                    } // End if text

                                    /*
                                    * SVG Cutout
                                    */
                                    if(!mb_is_empty_string(svg) && svgDepth < 0){
                                        color(svgColor == "inherit" ? baseColor : svgColor){
                                            translate([decoratorX(svgSide, svgDepth, svgOffset[0]), decoratorY(svgSide, svgDepth, svgOffset[1]), decoratorZ(svgSide, svgDepth, svgOffset[1])])
                                                rotate(decoratorRotations[svgSide])
                                                    mb_svg3d(
                                                        file = svg,
                                                        orgWidth = svgDimensions[0],
                                                        orgHeight = svgDimensions[1],
                                                        depth = 2 * abs(svgDepth),
                                                        size = scale * svgScale,
                                                        center = true
                                                    );
                                        } // End color
                                    } // End if svg

                                    /*
                                    * Surface Pattern Cutout
                                    */
                                    if(!mb_is_empty_string(surfacePattern) && surfacePattern != "none" && surfacePatternDepth < 0){
                                        textureRoundingRadiusQuality = mb_fn_even_for_radius(
                                            textureRoundingRadius, 
                                            2, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );

                                        color(surfacePatternColor == "inherit" ? baseColor : surfacePatternColor){
                                            translate([decoratorX(surfacePatternSide, surfacePatternDepth, surfacePatternOffset[0]), decoratorY(surfacePatternSide, surfacePatternDepth, surfacePatternOffset[1]), decoratorZ(surfacePatternSide, surfacePatternDepth, surfacePatternOffset[1])])
                                                rotate(decoratorRotations[surfacePatternSide])
                                                    intersection(){
                                                        mb_svg3d(
                                                            file = surfacePattern,
                                                            orgWidth = surfacePatternDimensions[0],
                                                            orgHeight = surfacePatternDimensions[1],
                                                            depth = 2 * abs(surfacePatternDepth),
                                                            size = scale * surfacePatternScale,
                                                            center = true
                                                        );
                                                        mb_beveled_rounded_block(
                                                            bevel = beveled ? bevelTexture : false,
                                                            sizeX = objectSizeX - wallThickness,
                                                            sizeY = objectSizeY - wallThickness,
                                                            height = (2 + 0.1) * abs(surfacePatternDepth),
                                                            roundingRadius = textureRoundingRadius == 0 ? 0 : [0, 0, textureRoundingRadius],
                                                            roundingResolution = textureRoundingRadiusQuality
                                                        );
                                                    }
                                        } // End color
                                    } // End if surface pattern

                                    /*
                                    * Grille
                                    */
                                    if(grille != "none" && baseCutoutType != "standard"){
                                        grilleHeight = grilleDepth * mbuToMm + cutOffset;
                                        color(baseColor){
                                            if(grille == "x"){
                                                
                                                grilleWidthY = size[1] * unitGrid[0] * mbuToMm / grilleCount;
                                                for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                    if(g % 2 == (grilleInverted ? 0 : 1)){
                                                        translate([0, sideY(0) + (0.5 + g) * grilleWidthY, 0.5 * (resultingBaseHeight - grilleHeight + cutOffset)])
                                                            cube(size=[objectSizeXAdjusted*cutMultiplier, grilleWidthY, grilleHeight+ cutOffset], center=true);
                                                    }
                                                }
                                            }
                                            else if(grille == "y"){
                                                grilleWidthX = size[0] * unitGrid[0] * mbuToMm / grilleCount;
                                                for (g = [ 0 : 1 : grilleCount - 1 ]){
                                                    if(g % 2 == (grilleInverted ? 0 : 1)){
                                                        translate([sideX(0) + (0.5 + g) * grilleWidthX, 0, 0.5 * (resultingBaseHeight - grilleHeight + cutOffset)])
                                                            cube(size=[grilleWidthX, objectSizeYAdjusted*cutMultiplier, grilleHeight+ cutOffset], center=true);
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    /*
                                    * Screw Holes Z
                                    */
                                    if(stabilizerGrid || (baseCutoutType == "none") || (baseCutoutType == "groove")){
                                        screwHoleZRoundingRadius = mb_fn_even_for_radius(
                                            0.5 * screwHoleZSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );
                                        color(baseColor){
                                            for (a = [ startX : 1 : endX ]){
                                                for (b = [ startY : 1 : endY ]){
                                                    if(drawScrewHoleZ(a, b, 0)){
                                                        translate([posX(a), posY(b), 0.5*knobHeight])
                                                            cylinder(h = (resultingBaseHeight + knobHeight)*cutMultiplier, r = 0.5*screwHoleZSize, center=true, $fn=screwHoleZRoundingRadius);
                                                    } 
                                                }
                                            }
                                        } // End color
                                    } // End if stabilizerGrid

                                    /*
                                    * Screw Holes X
                                    */
                                    if(screwHolesX != false && len(screwHolesX) > 0){
                                        screwHoleXRoundingRadius = mb_fn_even_for_radius(
                                            0.5 * screwHoleXSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );
                                        for (b = [ 0 : 1 : len(screwHolesX) - 1]){
                                            
                                            color(baseColor){
                                                for (s = [ 0 : 1 : 1]){
                                                    if(screwHolesX[b][2] == undef || screwHolesX[b][2] == s){
                                                        translate([posX(screwHolesX[b][0]), sideY(s) + (0.5 - s)*(screwHoleXDepth - cutOffset), xyScrewHolesZ + screwHolesX[b][1] * gridSizeZ])
                                                            rotate([90, 0, 0])
                                                                cylinder(h = screwHoleXDepth + cutOffset, r = 0.5*screwHoleXSize, center=true, $fn=screwHoleXRoundingRadius);
                                                    }
                                                }
                                            } // End color
                                        } // End for screwHolesX
                                    }

                                    /*
                                    * Screw Holes Y
                                    */
                                    if(screwHolesY != false && len(screwHolesY) > 0){
                                        screwHoleYRoundingRadius = mb_fn_even_for_radius(
                                            0.5 * screwHoleYSize, 
                                            0, 
                                            qualitySegBase,
                                            qualityFactor,
                                            qualityResolutionMin,
                                            qualityResolutionMax,
                                            qualityResolutionMultiplier,
                                            previewQuality
                                        );
                                        for (b = [ 0 : 1 : len(screwHolesY) - 1]){
                                            color(baseColor){
                                                for (s = [ 0 : 1 : 1]){
                                                    if(screwHolesY[b][2] == undef || screwHolesY[b][2] == s){
                                                        translate([sideX(s) + (0.5 - s)*(screwHoleYDepth - cutOffset), posY(screwHolesY[b][0]), xyScrewHolesZ + screwHolesY[b][1] * gridSizeZ])
                                                            rotate([0, 90, 0])
                                                                cylinder(h = screwHoleYDepth + cutOffset, r = 0.5*screwHoleYSize, center=true, $fn=screwHoleYRoundingRadius);
                                                    }
                                                }
                                            } // End color
                                        } // End for screwHolesY
                                    }
                                    /*
                                    * Cut Groove
                                    */
                                    if(baseCutoutType == "groove"){
                                        color(baseColor){
                                            translate([0, 0, sideZ(0) + 0.5*tonGrooveDepthCalc]){ 
                                                translate([0, 0, -0.5 * cutOffset]){
                                                    mb_tongue(
                                                        gridSizeXY = gridSizeXY,
                                                        objectSize = [objectSizeX, objectSizeY],
                                                        objectSizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
                                                        baseRoundingRadiusZ = baseRoundingRadiusZ,
                                                        beveled = beveled,
                                                        bevelOuter = bevelOuter,
                                                        tongueOffset = tonOffsetCalc,
                                                        tongueThickness = tonThicknessCalc,
                                                        tongueThicknessAdjustment = tongueThicknessAdjustment,
                                                        tongueHeight = tonGrooveDepthCalc + cutOffset,
                                                        tongueClampThickness = tongueClampThickness,
                                                        tongueClampHeight = tonClampHeightCalc,
                                                        tongueClampOffset = tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc,
                                                        tongueRoundingRadius = tongueRoundingRadius,
                                                        tongueInnerRoundingRadius = tongueInnerRoundingRadius,
                                                        pit = true,
                                                        pitWallGaps = recessWallGaps,
                                                        pitSizeX = pitSizeX,
                                                        pitSizeY = pitSizeY,
                                                        qualitySegBase = qualitySegBase,
                                                        qualityFactor = qualityFactor,
                                                        qualityResolutionMin = qualityResolutionMin,
                                                        qualityResolutionMax = qualityResolutionMax,
                                                        qualityResolutionMultiplier = qualityResolutionMultiplier,
                                                        previewQuality = previewQuality
                                                    );
                                                }

                                                tongueSizeX = objectSizeX - 2 * tonOffsetCalc + tongueThicknessAdjustment;
                                                tongueSizeY = objectSizeY - 2 * tonOffsetCalc + tongueThicknessAdjustment;
                                                tongueThicknessAdjusted = tonThicknessCalc + tongueThicknessAdjustment;
                                                tongueInnerSizeX = tongueSizeX - 2 * tongueThicknessAdjusted;
                                                tongueInnerSizeY = tongueSizeY - 2 * tongueThicknessAdjusted;

                                                /*
                                                * Groove Wall Gaps X
                                                */
                                                //color([0.608, 0.349, 0.714]) //9b59b6
                                                for (a = [ startX : 1 : endX ]){
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        gapLength = drawWallGapX(a, side, 0);
                                                        if(gapLength > 0){
                                                            translate([posX(a + 0.5*(gapLength-1)), sideY(side), -0.5 * cutOffset]){
                                                                cube([
                                                                    gapLength*gridSizeXY - objectSizeX + tongueSizeX + cutTolerance, 
                                                                    objectSizeY - tongueSizeY + sAdjustment[2 + side] + cutTolerance, 
                                                                    tonGrooveDepthCalc + cutOffset
                                                                ], center=true); 
                                                                
                                                                translate([0,0,+0.5*(tonGrooveDepthCalc+cutOffset)-0.5*tonClampHeightCalc - (tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc)])
                                                                    cube([
                                                                        gapLength*gridSizeXY - objectSizeX + tongueSizeX + 2* tongueClampThickness + cutTolerance, 
                                                                        objectSizeY - tongueSizeY + sAdjustment[2 + side] + cutTolerance, 
                                                                        tonClampHeightCalc
                                                                    ], center=true); 
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                /*
                                                * Groove Wall Gaps Y
                                                */
                                                for (b = [ startY : 1 : endY ]){
                                                    for (side = [ 0 : 1 : 1 ]){
                                                        gapLength = drawWallGapY(b, side, 0);
                                                        if(gapLength > 0){
                                                            translate([sideX(side), posY(b + 0.5*(gapLength-1)), -0.5 * cutOffset]){
                                                                cube([
                                                                    objectSizeX - tongueSizeX + sAdjustment[side] + cutTolerance, 
                                                                    gapLength*gridSizeXY - objectSizeY + tongueSizeY + cutTolerance, 
                                                                    tonGrooveDepthCalc + cutOffset
                                                                ], center=true);   

                                                                translate([0,0,+0.5*(tonGrooveDepthCalc+cutOffset)-0.5*tonClampHeightCalc - (tonClampOffsetCalc + tonGrooveDepthCalc - tonHeightCalc)])
                                                                    cube([
                                                                        objectSizeX - tongueSizeX + sAdjustment[side] + cutTolerance, 
                                                                        gapLength*gridSizeXY - objectSizeY + tongueSizeY + 2* tongueClampThickness + cutTolerance, 
                                                                        tonClampHeightCalc
                                                                    ], center=true);   
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                
                                            }   
                                        } // End color
                                    } // End if baseCutoutType

                                    /*
                                    if(cutout != false && cutout != [0, 0]){
                                        translate([-rotationOffsetX - alignX, -rotationOffsetY - alignY, -rotationOffsetZ - alignZ]){
                                            machineblock(
                                                size = [cutout[0], cutout[1], size[2]],
                                                studs = false,
                                                baseCutoutType = "none"
                                            );
                                        }
                                    }*/
                                } // End main difference
                            }

                            /*
                            * Final Addition AREA
                            * Starting from here, everything affects both solid and cutout blocks
                            */
                            
                            /*
                            * Classic Knobs
                            */
                            if(studs != false){
                                color(baseColor){
                                    studRoundingRes = mb_fn_even_for_radius(
                                        0.5 * knobSize + studClampThickness, 
                                        0, 
                                        qualitySegBase,
                                        qualityFactor,
                                        qualityResolutionMin,
                                        qualityResolutionMax,
                                        qualityResolutionMultiplier,
                                        previewQuality
                                    );

                                    studHoleRoundingRes = mb_fn_even_for_radius(
                                        0.5 * knobHoleSize, 
                                        0, 
                                        qualitySegBase,
                                        qualityFactor,
                                        qualityResolutionMin,
                                        qualityResolutionMax,
                                        qualityResolutionMultiplier,
                                        previewQuality
                                    );

                                    studHelperRoundingRes = mb_fn_even_for_radius(
                                        knobRounding, 
                                        2, 
                                        qualitySegBase,
                                        qualityFactor,
                                        qualityResolutionMin,
                                        qualityResolutionMax,
                                        qualityResolutionMultiplier,
                                        previewQuality
                                    );

                                    knobShiftedX = (studShift == true || studShift == "x" || studShift == "xy");
                                    knobShiftedY = (studShift == true || studShift == "y" || studShift == "xy");

                                    /*
                                    * Normal studs
                                    */
                                    for (a = [ startX : 1 : (ceil(endX) - (knobShiftedX ? 1 : 0)) ]){
                                        for (b = [ startY : 1 : (ceil(endY) - (knobShiftedY ? 1 : 0)) ]){
                                            knobOffsetX = knobShiftedX ? 0.5 : 0;
                                            knobOffsetY = knobShiftedY ? 0.5 : 0;
                                            ovStudType = drawStud(a + knobOffsetX, b + knobOffsetY);
                                            echo(st = ovStudType);
                                            if(ovStudType != false){
                                                pitKnobShiftedX = (recessStudShift == true || recessStudShift == "x" || recessStudShift == "xy");
                                                pitKnobShiftedY = (recessStudShift == true || recessStudShift == "y" || recessStudShift == "xy");
                                                pitKnobOffsetX = pitKnobShiftedX ? 0.5 : 0;
                                                pitKnobOffsetY = pitKnobShiftedY ? 0.5 : 0;
                                                inPit = recess && recessStuds && inPit(a + pitKnobOffsetX, b + pitKnobOffsetY);
                                                onPitBorder = !recess || onPitBorder(a + knobOffsetX, b + knobOffsetY);
                                                if(onPitBorder || inPit){
                                                    posOffsetX = (inPit ? pitKnobShiftedX : knobShiftedX) ? 0.5 : 0;
                                                    posOffsetY = (inPit ? pitKnobShiftedY : knobShiftedY) ? 0.5 : 0;
                                                    translate([posX(a + posOffsetX), posY(b + posOffsetY), knobZ(a + posOffsetX, b + posOffsetY)]){ 
                                                        kType = studType(ovStudType, a + posOffsetX, b + posOffsetY);
                                                        difference(){

                                                            union(){
                                                                /*
                                                                difference(){
                                                                    union(){
                                                                        translate([0, 0, -0.5 * (knobRounding + studClampHeight * mbuToMm) - 0.5 * knobSink])
                                                                            cylinder(h=knobHeight - knobRounding - studClampHeight * mbuToMm + knobSink + knobPartsOverlap, r=0.5 * knobSize, center=true, $fn=studRoundingRes);

                                                                        
                                                                        translate([0, 0, 0.5 * (knobHeight - studClampHeight * mbuToMm) - knobRounding ])
                                                                            cylinder(h=studClampHeight * mbuToMm + (knobRounding > knobPartsOverlap ? knobPartsOverlap : 0), r=0.5 * knobSize + studClampThickness, center=true, $fn=studRoundingRes);
                                                                        
                                                                        if(knobRounding > 0){
                                                                            translate([0, 0, 0.5 * (knobHeight - knobRounding)])
                                                                                cylinder(h=knobRounding, r=0.5 * knobSize + studClampThickness - knobRounding, center=true, $fn=studRoundingRes);
                                                                        }
                                                                    }
                                                                    
                                                                    if(kType == "hollow"){
                                                                        intersection(){
                                                                            cube([knobHoleSize - 2*studHoleClampThickness, knobHoleSize - 2*studHoleClampThickness, knobHeight*cutMultiplier], center=true);
                                                                            cylinder(h=knobHeight * cutMultiplier, r=0.5 * knobHoleSize, center=true, $fn=studHoleRoundingRes);
                                                                        }
                                                                    }
                                                                } // end difference
                                                                
                                                                //Knob Rounding
                                                                if(knobRounding > 0){
                                                                    translate([0, 0, 0.5 * knobHeight - knobRounding]){ 
                                                                        mb_torus(
                                                                            circleRadius = knobRounding, 
                                                                            torusRadius = 0.5 * knobSize + studClampThickness, 
                                                                            circleResolution = studHelperRoundingRes,
                                                                            torusResolution = studRoundingRes
                                                                        );
                                                                    }
                                                                }*/

                                                                mb_stud(
                                                                    height = knobHeight + knobSink,
                                                                    radius = 0.5 * knobSize,
                                                                    holeRadius = kType == "hollow" ? 0.5 * knobHoleSize : 0,
                                                                    holeClampThickness = studHoleClampThickness,
                                                                    roundingRadius = knobRounding,
                                                                    clampHeight = studClampHeight,
                                                                    clampThickness = studClampThickness,
                                                                    bodyRoundingResolution = studRoundingRes,
                                                                    holeRoundingResolution = studHoleRoundingRes,
                                                                    edgeRoundingResolution = studHelperRoundingRes
                                                                );

                                                                if(!mb_is_empty_string(studIcon) && studIcon != "none" && studIconDepth > 0 && kType != "hollow"){
                                                                    color(studIconColor == "inherit" ? baseColor : studIconColor){
                                                                        translate([0, 0, knobHeight + knobSink])
                                                                            rotate(decoratorRotations[surfacePatternSide])
                                                                                mb_svg3d(
                                                                                    file = studIcon,
                                                                                    orgWidth = studIconDimensions[0],
                                                                                    orgHeight = studIconDimensions[1],
                                                                                    depth = 2 * abs(studIconDepth),
                                                                                    size = scale * studIconScale,
                                                                                    center = true
                                                                                );
                                                                                
                                                                    } // End color
                                                                }
                                                            } // End union
                                                            
                                                            

                                                            if(!mb_is_empty_string(studIcon) && studIcon != "none" && studIconDepth < 0 && kType != "hollow"){
                                                                color(studIconColor == "inherit" ? baseColor : studIconColor){
                                                                    translate([0, 0, knobHeight + knobSink])
                                                                        rotate(decoratorRotations[surfacePatternSide])
                                                                            mb_svg3d(
                                                                                file = studIcon,
                                                                                orgWidth = studIconDimensions[0],
                                                                                orgHeight = studIconDimensions[1],
                                                                                depth = 2 * abs(studIconDepth),
                                                                                size = scale * studIconScale,
                                                                                center = true
                                                                            );
                                                                            
                                                                } // End color
                                                            }
                                                        } // End difference
                                                    } // End translate
                                                }
                                            }
                                        }
                                    }
                                } // End base color
                            } // End if studs

                            /*
                            * Tongue
                            */
                            if(tongue){
                                color(baseColor){
                                    translate([0, 0, 0.5 * (resultingBaseHeight + tonHeightCalc)]){ 
                                        mb_tongue(
                                            gridSizeXY = gridSizeXY,
                                            objectSize = [objectSizeX, objectSizeY],
                                            objectSizeAdjusted = [objectSizeXAdjusted, objectSizeYAdjusted],
                                            baseRoundingRadiusZ = baseRoundingRadiusZ,
                                            beveled = beveled,
                                            bevelOuter = bevelOuter,
                                            tongueOffset = tonOffsetCalc,
                                            tongueThickness = tonThicknessCalc,
                                            tongueThicknessAdjustment = tongueThicknessAdjustment,
                                            tongueHeight = tonHeightCalc,
                                            tongueClampThickness = tongueClampThickness,
                                            tongueClampHeight = tonClampHeightCalc,
                                            tongueClampOffset = tonClampOffsetCalc,
                                            tongueRoundingRadius = tongueRoundingRadius,
                                            tongueInnerRoundingRadius = tongueInnerRoundingRadius,
                                            pit = recess,
                                            pitWallGaps = recessWallGaps,
                                            pitSizeX = pitSizeX,
                                            pitSizeY = pitSizeY,
                                            qualitySegBase = qualitySegBase,
                                            qualityFactor = qualityFactor,
                                            qualityResolutionMin = qualityResolutionMin,
                                            qualityResolutionMax = qualityResolutionMax,
                                            qualityResolutionMultiplier = qualityResolutionMultiplier,
                                            previewQuality = previewQuality
                                        );
                                    }
                                } // End color
                            } // End if tongue

                            //PCB
                            if(pcb){
                                color(baseColor){
                                    translate([pcbOffset[0]*gridSizeXY, pcbOffset[1]*gridSizeXY, pitFloorZ]){
                                        if(pcbMountingType == "clips"){
                                            mb_pcb_clips(
                                                pcbDimensions = pcbDimensions
                                            );
                                        }
                                        if(pcbMountingType == "screws"){
                                            mb_pcb_screw_sockets(
                                                screwSockets = pcbScrewSockets,
                                                screwSocketHeight = pcbScrewSocketHeight,
                                                screwSocketSize = pcbScrewSocketSize,
                                                screwSocketHoleSize = pcbScrewSocketHoleSize
                                            );
                                        }
                                    }
                                } // End color
                            } // End if pcb
                            
                            /*
                            * Text
                            */
                            if(text != false && !mb_is_empty_string(text) && txtDepth > 0){
                                color(textColor == "inherit" ? baseColor : textColor)
                                    translate([decoratorX(textSide, txtDepth, textOffset[0]), decoratorY(textSide, txtDepth, textOffset[1]), decoratorZ(textSide, txtDepth, textOffset[1])])
                                        rotate(decoratorRotations[textSide])
                                            mb_text3d(
                                                text = text,
                                                textDepth = txtDepth,
                                                textSize = scale * textSize,
                                                textFont = textFont,
                                                textSpacing = textSpacing,
                                                textVerticalAlign = textVerticalAlign,
                                                textHorizontalAlign = textHorizontalAlign,
                                                center = true
                                            );
                            } // End if text

                            /*
                            * SVG
                            */
                            if(!mb_is_empty_string(svg) && svgDepth > 0){
                                color(svgColor == "inherit" ? baseColor : svgColor)
                                    translate([decoratorX(svgSide, svgDepth, svgOffset[0]), decoratorY(svgSide, svgDepth, svgOffset[1]), decoratorZ(svgSide, svgDepth, svgOffset[1])])
                                        rotate(decoratorRotations[svgSide])
                                            mb_svg3d(
                                                file = svg,
                                                orgWidth = svgDimensions[0],
                                                orgHeight = svgDimensions[1],
                                                depth = svgDepth,
                                                size = scale * svgScale,
                                                center = true
                                            );
                            } // End if svg
                            
                        } // End pre_render

                        //Render children for assembly == merged
                        if(assembly == "merged"){
                            translate([translateXChildren, translateYChildren, translateZChildren]){
                                children();
                            }
                        }
                    } // End final union
                    
                    //Render children for assembly != merged
                    if(assembly != "merged"){
                        translate([translateXChildren, translateYChildren, translateZChildren]){
                            children();
                        }
                    }
                } // End direction rotation
            } // End rotation offset and alignment
        } // End rotation
    } //End grid offset and rotation offset revert

    echo("Rendering of Block finished.");
    echo("Join our Discord! Visit machineblocks.com");
} // End module block 

/*
* Legacy machineblock() module
*/
module machineblock(

    // Grid units
    unitMbu = undef,
    unitGrid = undef,

    // Scale
    scale = undef,

    // Rotation
    rotation = undef,
    rotationOffset = undef,
    rotationOffsetRevert = undef,
    direction = undef,

    // Size
    size = undef,
    offset = undef,
    crop = undef,

    cutout = undef,
    cutoutOffset = undef,

    // Base
    base = undef,
    baseColor = undef,
    baseHeight = undef,

    baseTopPlateHeight = undef,
    baseTopPlateHeightAdjustment = undef,

    baseCutoutType = undef,
    baseCutoutMaxDepth = undef,

    baseClampOffset = undef,
    baseClampHeight = undef,
    baseClampThickness = undef,
    baseClampOuter = undef,

    baseRoundingRadius = undef,
    baseCutoutRoundingRadius = undef,
    baseRoundingResolution = undef,

    // Relief Cut
    baseReliefCut = undef,
    baseReliefCutHeight = undef,
    baseReliefCutThickness = undef,

    // Base Adjustment
    baseSideAdjustment = undef,
    baseHeightAdjustment = undef,

    // Walls
    baseWallThickness = undef,
    baseWallThicknessAdjustment = undef,
    baseWallGapsX = undef,
    baseWallGapsY = undef,

    // Top Plate Helpers
    topPlateHelpers = undef,
    topPlateHelperHeight = undef,
    topPlateHelperThickness = undef,

    // Stabilizers
    stabilizerGrid = undef,
    stabilizerGridOffset = undef,
    stabilizerGridHeight = undef,
    stabilizerGridThickness = undef,
    stabilizerExpansion = undef,
    stabilizerExpansionOffset = undef,

    // Pillars
    pillars = undef,
    pillarRoundingResolution = undef,
    pillarGapCornerLength = undef,
    pillarGapMiddle = undef,

    // Pins
    pinDiameter = undef,
    pinDiameterAdjustment = undef,

    // Tubes
    tubeWallThickness = undef,
    tubeXDiameter = undef,
    tubeXDiameterAdjustment = undef,
    tubeYDiameter = undef,
    tubeYDiameterAdjustment = undef,
    tubeZDiameter = undef,
    tubeZDiameterAdjustment = undef,
    tubeInnerClampThickness = undef,

    // Slope
    slope = undef,
    slopeBaseHeightLower = undef,
    slopeBaseHeightLowerInner = undef,
    slopeBaseHeightUpper = undef,

    // Bevel
    bevel = undef,

    // Holes X
    holeX = undef,
    holeXType = undef,
    holeXShift = undef,
    holeXDiameter = undef,
    holeXDiameterAdjustment = undef,
    holeXInsetThickness = undef,
    holeXInsetThicknessAdjustment = undef,
    holeXInsetDepth = undef,
    holeXInsetDepthAdjustment = undef,
    holeXGridOffsetZ = undef,
    holeXGridOffsetZAdjustment = undef,
    holeXGridSizeZ = undef,
    holeXGridSizeZAdjustment = undef,
    holeXMinTopMargin = undef,
    holeXPartial = undef,

    // Holes Y
    holeY = undef,
    holeYType = undef,
    holeYShift = undef,
    holeYDiameter = undef,
    holeYDiameterAdjustment = undef,
    holeYInsetThickness = undef,
    holeYInsetThicknessAdjustment = undef,
    holeYInsetDepth = undef,
    holeYInsetDepthAdjustment = undef,
    holeYGridOffsetZ = undef,
    holeYGridOffsetZAdjustment = undef,
    holeYGridSizeZ = undef,
    holeYGridSizeZAdjustment = undef,
    holeYMinTopMargin = undef,
    holeYPartial = undef,

    // Holes Z
    holeZ = undef,
    holeZType = undef,
    holeZShift = undef,
    holeZDiameter = undef,
    holeZDiameterAdjustment = undef,
    holeRoundingResolution = undef,
    holeZPartialX = undef,
    holeZPartialY = undef,

    // Axle
    holeAxleThickness = undef,

    // Studs
    studs = undef,
    studType = undef,
    studShift = undef,
    studMaxOverhang = undef,
    studPadding = undef,

    studClampHeight = undef,
    studClampThickness = undef,

    studHoleDiameter = undef,
    studHoleDiameterAdjustment = undef,
    studHoleClampThickness = undef,

    studRounding = undef,
    studRoundingResolution = undef,

    studDiameter = undef,
    studDiameterAdjustment = undef,

    studHeight = undef,
    studHeightAdjustment = undef,

    studCutoutAdjustment = undef,

    studIcon = undef,
    studIconDimensions = undef,
    studIconScale = undef,
    studIconDepth = undef,
    studIconColor = undef,

    // Tongue
    tongue = undef,
    tongueHeight = undef,
    tongueGrooveDepth = undef,
    tongueRoundingRadius = undef,
    tongueInnerRoundingRadius = undef,
    tongueThickness = undef,
    tongueThicknessAdjustment = undef,
    tongueOffset = undef,
    tongueClampHeight = undef,
    tongueClampOffset = undef,
    tongueClampThickness = undef,

    // Grille
    grille = undef,
    grilleInverted = undef,
    grilleDepth = undef,
    grilleCount = undef,

    // Recess
    recess = undef,
    recessRoundingRadius = undef,
    recessDepth = undef,
    recessWallThickness = undef,
    recessStuds = undef,
    recessStudPadding = undef,
    recessStudType = undef,
    recessStudShift = undef,
    recessWallGaps = undef,

    // Text
    text = undef,
    textSide = undef,
    textDepth = undef,
    textFont = undef,
    textSize = undef,
    textSpacing = undef,
    textVerticalAlign = undef,
    textHorizontalAlign = undef,
    textOffset = undef,
    textColor = undef,

    // Surface Pattern
    surfacePattern = undef,
    surfacePatternDimensions = undef,
    surfacePatternOffset = undef,
    surfacePatternScale = undef,
    surfacePatternDepth = undef,
    surfacePatternColor = undef,

    // SVG
    svg = undef,
    svgSide = undef,
    svgDepth = undef,
    svgDimensions = undef,
    svgScale = undef,
    svgOffset = undef,
    svgColor = undef,

    // Connectors
    connectors = undef,
    connectorPadding = undef,
    connectorHeight = undef,
    connectorDepth = undef,
    connectorWidth = undef,
    connectorDepthTolerance = undef,
    connectorSideTolerance = undef,

    // Screws Z
    screwHolesZ = undef,
    screwHoleZSize = undef,
    screwHoleZHelperThickness = undef,
    screwHoleZHelperOffset = undef,
    screwHoleZHelperHeight = undef,

    // Screws X
    screwHolesX = undef,
    screwHoleXSize = undef,
    screwHoleXDepth = undef,

    // Screws Y
    screwHolesY = undef,
    screwHoleYSize = undef,
    screwHoleYDepth = undef,

    // PCB
    pcb = undef,
    pcbMountingType = undef,
    pcbDimensions = undef,
    pcbOffset = undef,
    pcbScrewSocketSize = undef,
    pcbScrewSocketHoleSize = undef,
    pcbScrewSocketHeight = undef,
    pcbScrewSockets = undef,

    // Alignment
    align = undef,
    alignChildren = undef,

    // Quality
    qualitySegBase = undef,
    qualityResolutionMax = undef,
    qualityFactor = undef,
    qualityResolutionMin = undef,
    qualityResolutionMultiplier = undef,

    // Preview
    previewQuality = undef,
    previewRender = undef,
    previewRenderConvexity = undef

){
    settings = [
        ["unitMbu", unitMbu],
        ["unitGrid", unitGrid],
        ["scale", scale],

        ["rotation", rotation],
        ["rotationOffset", rotationOffset],
        ["rotationOffsetRevert", rotationOffsetRevert],
        ["direction", direction],

        ["size", size],
        ["offset", offset],
        ["crop", crop],

        ["cutout", cutout],
        ["cutoutOffset", cutoutOffset],

        ["base", base],
        ["baseColor", baseColor],
        ["baseHeight", baseHeight],

        ["baseTopPlateHeight", baseTopPlateHeight],
        ["baseTopPlateHeightAdjustment", baseTopPlateHeightAdjustment],

        ["baseCutoutType", baseCutoutType],
        ["baseCutoutMaxDepth", baseCutoutMaxDepth],

        ["baseClampOffset", baseClampOffset],
        ["baseClampHeight", baseClampHeight],
        ["baseClampThickness", baseClampThickness],
        ["baseClampOuter", baseClampOuter],

        ["baseRoundingRadius", baseRoundingRadius],
        ["baseCutoutRoundingRadius", baseCutoutRoundingRadius],
        ["baseRoundingResolution", baseRoundingResolution],

        ["baseReliefCut", baseReliefCut],
        ["baseReliefCutHeight", baseReliefCutHeight],
        ["baseReliefCutThickness", baseReliefCutThickness],

        ["baseSideAdjustment", baseSideAdjustment],
        ["baseHeightAdjustment", baseHeightAdjustment],

        ["baseWallThickness", baseWallThickness],
        ["baseWallThicknessAdjustment", baseWallThicknessAdjustment],
        ["baseWallGapsX", baseWallGapsX],
        ["baseWallGapsY", baseWallGapsY],

        ["topPlateHelpers", topPlateHelpers],
        ["topPlateHelperHeight", topPlateHelperHeight],
        ["topPlateHelperThickness", topPlateHelperThickness],

        ["stabilizerGrid", stabilizerGrid],
        ["stabilizerGridOffset", stabilizerGridOffset],
        ["stabilizerGridHeight", stabilizerGridHeight],
        ["stabilizerGridThickness", stabilizerGridThickness],
        ["stabilizerExpansion", stabilizerExpansion],
        ["stabilizerExpansionOffset", stabilizerExpansionOffset],

        ["pillars", pillars],
        ["pillarRoundingResolution", pillarRoundingResolution],
        ["pillarGapCornerLength", pillarGapCornerLength],
        ["pillarGapMiddle", pillarGapMiddle],

        ["pinDiameter", pinDiameter],
        ["pinDiameterAdjustment", pinDiameterAdjustment],

        ["tubeWallThickness", tubeWallThickness],
        ["tubeXDiameter", tubeXDiameter],
        ["tubeXDiameterAdjustment", tubeXDiameterAdjustment],
        ["tubeYDiameter", tubeYDiameter],
        ["tubeYDiameterAdjustment", tubeYDiameterAdjustment],
        ["tubeZDiameter", tubeZDiameter],
        ["tubeZDiameterAdjustment", tubeZDiameterAdjustment],
        ["tubeInnerClampThickness", tubeInnerClampThickness],

        ["slope", slope],
        ["slopeBaseHeightLower", slopeBaseHeightLower],
        ["slopeBaseHeightLowerInner", slopeBaseHeightLowerInner],
        ["slopeBaseHeightUpper", slopeBaseHeightUpper],

        ["bevel", bevel],

        ["holeX", holeX],
        ["holeXType", holeXType],
        ["holeXShift", holeXShift],
        ["holeXDiameter", holeXDiameter],
        ["holeXDiameterAdjustment", holeXDiameterAdjustment],
        ["holeXInsetThickness", holeXInsetThickness],
        ["holeXInsetThicknessAdjustment", holeXInsetThicknessAdjustment],
        ["holeXInsetDepth", holeXInsetDepth],
        ["holeXInsetDepthAdjustment", holeXInsetDepthAdjustment],
        ["holeXGridOffsetZ", holeXGridOffsetZ],
        ["holeXGridOffsetZAdjustment", holeXGridOffsetZAdjustment],
        ["holeXGridSizeZ", holeXGridSizeZ],
        ["holeXGridSizeZAdjustment", holeXGridSizeZAdjustment],
        ["holeXMinTopMargin", holeXMinTopMargin],
        ["holeXPartial", holeXPartial],

        ["holeY", holeY],
        ["holeYType", holeYType],
        ["holeYShift", holeYShift],
        ["holeYDiameter", holeYDiameter],
        ["holeYDiameterAdjustment", holeYDiameterAdjustment],
        ["holeYInsetThickness", holeYInsetThickness],
        ["holeYInsetThicknessAdjustment", holeYInsetThicknessAdjustment],
        ["holeYInsetDepth", holeYInsetDepth],
        ["holeYInsetDepthAdjustment", holeYInsetDepthAdjustment],
        ["holeYGridOffsetZ", holeYGridOffsetZ],
        ["holeYGridOffsetZAdjustment", holeYGridOffsetZAdjustment],
        ["holeYGridSizeZ", holeYGridSizeZ],
        ["holeYGridSizeZAdjustment", holeYGridSizeZAdjustment],
        ["holeYMinTopMargin", holeYMinTopMargin],
        ["holeYPartial", holeYPartial],

        ["holeZ", holeZ],
        ["holeZType", holeZType],
        ["holeZShift", holeZShift],
        ["holeZDiameter", holeZDiameter],
        ["holeZDiameterAdjustment", holeZDiameterAdjustment],
        ["holeRoundingResolution", holeRoundingResolution],
        ["holeZPartialX", holeZPartialX],
        ["holeZPartialY", holeZPartialY],

        ["holeAxleThickness", holeAxleThickness],

        ["studs", studs],
        ["studType", studType],
        ["studShift", studShift],
        ["studMaxOverhang", studMaxOverhang],
        ["studPadding", studPadding],

        ["studClampHeight", studClampHeight],
        ["studClampThickness", studClampThickness],

        ["studHoleDiameter", studHoleDiameter],
        ["studHoleDiameterAdjustment", studHoleDiameterAdjustment],
        ["studHoleClampThickness", studHoleClampThickness],

        ["studRounding", studRounding],
        ["studRoundingResolution", studRoundingResolution],

        ["studDiameter", studDiameter],
        ["studDiameterAdjustment", studDiameterAdjustment],

        ["studHeight", studHeight],
        ["studHeightAdjustment", studHeightAdjustment],

        ["studCutoutAdjustment", studCutoutAdjustment],

        ["studIcon", studIcon],
        ["studIconDimensions", studIconDimensions],
        ["studIconScale", studIconScale],
        ["studIconDepth", studIconDepth],
        ["studIconColor", studIconColor],

        ["tongue", tongue],
        ["tongueHeight", tongueHeight],
        ["tongueGrooveDepth", tongueGrooveDepth],
        ["tongueRoundingRadius", tongueRoundingRadius],
        ["tongueInnerRoundingRadius", tongueInnerRoundingRadius],
        ["tongueThickness", tongueThickness],
        ["tongueThicknessAdjustment", tongueThicknessAdjustment],
        ["tongueOffset", tongueOffset],
        ["tongueClampHeight", tongueClampHeight],
        ["tongueClampOffset", tongueClampOffset],
        ["tongueClampThickness", tongueClampThickness],

        ["grille", grille],
        ["grilleInverted", grilleInverted],
        ["grilleDepth", grilleDepth],
        ["grilleCount", grilleCount],

        ["recess", recess],
        ["recessRoundingRadius", recessRoundingRadius],
        ["recessDepth", recessDepth],
        ["recessWallThickness", recessWallThickness],
        ["recessStuds", recessStuds],
        ["recessStudPadding", recessStudPadding],
        ["recessStudType", recessStudType],
        ["recessStudShift", recessStudShift],
        ["recessWallGaps", recessWallGaps],

        ["text", text],
        ["textSide", textSide],
        ["textDepth", textDepth],
        ["textFont", textFont],
        ["textSize", textSize],
        ["textSpacing", textSpacing],
        ["textVerticalAlign", textVerticalAlign],
        ["textHorizontalAlign", textHorizontalAlign],
        ["textOffset", textOffset],
        ["textColor", textColor],

        ["surfacePattern", surfacePattern],
        ["surfacePatternDimensions", surfacePatternDimensions],
        ["surfacePatternOffset", surfacePatternOffset],
        ["surfacePatternScale", surfacePatternScale],
        ["surfacePatternDepth", surfacePatternDepth],
        ["surfacePatternColor", surfacePatternColor],

        ["svg", svg],
        ["svgSide", svgSide],
        ["svgDepth", svgDepth],
        ["svgDimensions", svgDimensions],
        ["svgScale", svgScale],
        ["svgOffset", svgOffset],
        ["svgColor", svgColor],

        ["connectors", connectors],
        ["connectorPadding", connectorPadding],
        ["connectorHeight", connectorHeight],
        ["connectorDepth", connectorDepth],
        ["connectorWidth", connectorWidth],
        ["connectorDepthTolerance", connectorDepthTolerance],
        ["connectorSideTolerance", connectorSideTolerance],

        ["screwHolesZ", screwHolesZ],
        ["screwHoleZSize", screwHoleZSize],
        ["screwHoleZHelperThickness", screwHoleZHelperThickness],
        ["screwHoleZHelperOffset", screwHoleZHelperOffset],
        ["screwHoleZHelperHeight", screwHoleZHelperHeight],

        ["screwHolesX", screwHolesX],
        ["screwHoleXSize", screwHoleXSize],
        ["screwHoleXDepth", screwHoleXDepth],

        ["screwHolesY", screwHolesY],
        ["screwHoleYSize", screwHoleYSize],
        ["screwHoleYDepth", screwHoleYDepth],

        ["pcb", pcb],
        ["pcbMountingType", pcbMountingType],
        ["pcbDimensions", pcbDimensions],
        ["pcbOffset", pcbOffset],
        ["pcbScrewSocketSize", pcbScrewSocketSize],
        ["pcbScrewSocketHoleSize", pcbScrewSocketHoleSize],
        ["pcbScrewSocketHeight", pcbScrewSocketHeight],
        ["pcbScrewSockets", pcbScrewSockets],

        ["align", align],
        ["alignChildren", alignChildren],

        ["qualitySegBase", qualitySegBase],
        ["qualityResolutionMax", qualityResolutionMax],
        ["qualityFactor", qualityFactor],
        ["qualityResolutionMin", qualityResolutionMin],
        ["qualityResolutionMultiplier", qualityResolutionMultiplier],

        ["previewQuality", previewQuality],
        ["previewRender", previewRender],
        ["previewRenderConvexity", previewRenderConvexity]
    ];

    mb_block(settings = settings){
        children();
    }
}

/*
//Grid units
unitMbu = 1.6, // mm - The MachineBlocks base unit.
unitGrid = [5, 2], // vector2 x mbu ([xy, z]) - The MachineBlocks grid relative to the base unit.

//Scale
scale = 1.0, // float - Scale of the block. Only affects parameters given in mbu and grid.

//Rotation
rotation = [0, 0, 0], // vector3 x int - Rotation of the brick around the x, y and z - axis.
rotationOffset = [0, 0, 0], // grid ([x, y, z]) - Origin of the rotation relative to the Bricks origin.
rotationOffsetRevert = true,
direction = "west",

//Size
size = [1, 1, 1], // vector3 x grid ([x, y, z]) - Size of the brick as multiple of the grid unit.
offset = [0, 0, 0], // grid ([x, y, z]) - Position of the brick relative to the origin.
crop = [0, 0, 0, 0],

cutout = false,
cutoutOffset = [0, 0],

//Base
base = true, // bool
baseColor = "#EAC645", // color - Color of the block.
baseHeight = "auto", // mm | "auto" - Fixed height in mm or auto to calculate height based on the size parameter.

baseTopPlateHeight = 1, // mbu - The minimum height of the top plate. Final height might differ and is affected by baseCutoutMaxDepth and recessDepth.
baseTopPlateHeightAdjustment = -0.6, // mm

baseCutoutType = "standard", // "standard" | "studs" | "groove" | "none"
baseCutoutMaxDepth = 5, // mbu

baseClampOffset = 0.25, // mbu
baseClampHeight = 0.5, // mbu
baseClampThickness = 0.1, // mm
baseClampOuter = false, // bool


baseRoundingRadius = 0.0, // grid | vector3 x grid | vector3 x vector4 (e.g. 4 or [1, 2, 3] or [1, [2, 3, 4, 5], [6, 7, 8, 9]])
baseCutoutRoundingRadius = "auto", // mm (e.g 2.7 or [2.7, 2.7, 2.7, 2.7]) 
baseRoundingResolution = 64, // int TODO remove

//Relief Cut
baseReliefCut = false, // bool
baseReliefCutHeight = 0.375, // mbu
baseReliefCutThickness = 0.375, // mbu

//Base Adjustment
baseSideAdjustment = -0.1, // mm
baseHeightAdjustment = 0.0, // mm

//Walls
baseWallThickness = "auto", // mbu | "auto"
baseWallThicknessAdjustment = -0.1, // mm
baseWallGapsX = [], // vector
baseWallGapsY = [], // vector

//Top Plate Helpers
topPlateHelpers = true, // bool
topPlateHelperHeight = 0.2, // mm (min printable layer height, usually 0.2mm)
topPlateHelperThickness = 0.4, // mm (min printable wall thickness, usually 0.4mm)

//Stabilizers
stabilizerGrid = true, // bool
stabilizerGridOffset = 0.2, // mm (min printable layer height, usually 0.2mm)
stabilizerGridHeight = 0.5, // mbu
stabilizerGridThickness = 0.5, // mbu
stabilizerExpansion = 2, // int (create expansion after each [n] bricks)
stabilizerExpansionOffset = 1, // mbu

//Pillars: Tubes and Pins
pillars = true, // bool | vector
pillarRoundingResolution = 64, // int TODO remove
pillarGapCornerLength = 2, // int
pillarGapMiddle = 10, // int

//Pins (little tubes for blocks with 1 brick side length)
pinDiameter = "auto", // mbu | "auto"
pinDiameterAdjustment = 0.0, // mm

//Tubes
tubeWallThickness = 0.53125, // mbu (constant, should not be changed normally)
tubeXDiameter = "auto", // mbu | "auto"
tubeXDiameterAdjustment = -0.1, // mm
tubeYDiameter = "auto", // mbu | "auto"
tubeYDiameterAdjustment = -0.1, // mm
tubeZDiameter = "auto", // mbu | "auto"
tubeZDiameterAdjustment = -0.1, // mm

tubeInnerClampThickness = 0.1, // mm

// Slope
slope = false, // false | vector4
slopeBaseHeightLower = 1.333, // mbu
slopeBaseHeightLowerInner = 1.125, // mbu
slopeBaseHeightUpper = 1, // mbu

// Bevel
bevel = [[0, 0], [0, 0], [0, 0], [0, 0]], // vector4 x vector2

//Holes
holeX = false, // bool | vector
holeXType = "pin", // "pin" | "axle"
holeXShift = true, // bool
holeXDiameter = "auto", // mbu | "auto"
holeXDiameterAdjustment = 0.3, // mm
holeXInsetThickness = 0.375, // mbu
holeXInsetThicknessAdjustment = 0.0, // mm
holeXInsetDepth = 0.5, // mbu
holeXInsetDepthAdjustment = 0.0, // mm
holeXGridOffsetZ = 3.625, // mbu
holeXGridOffsetZAdjustment = 0.0, // mm
holeXGridSizeZ = 6, // mbu
holeXGridSizeZAdjustment = 0.0, // mm
holeXMinTopMargin = 0.5, // mbu
holeXPartial = "none", // "none", "start", "end", "all"

holeY = false, // bool or vector
holeYType = "pin", // "pin" | "axle"
holeYShift = true, // bool
holeYDiameter = "auto", // mbu | "auto"
holeYDiameterAdjustment = 0.3, // mm
holeYInsetThickness = 0.375, // mbu
holeYInsetThicknessAdjustment = 0.0, // mm
holeYInsetDepth = 0.5, // mbu
holeYInsetDepthAdjustment = 0.0, // mm
holeYGridOffsetZ = 3.625, // mbu
holeYGridOffsetZAdjustment = 0.0, //mm
holeYGridSizeZ = 6, // mbu
holeYGridSizeZAdjustment = 0.0, // mm
holeYMinTopMargin = 0.5, // mbu
holeYPartial = "none", // "none", "start", "end", "all"

holeZ = false, // bool or vector
holeZType = "pin", // "pin" | "axle"
holeZShift = true, // false | "none" | "x" | "y" | true | "xy"
holeZDiameter = "auto", // mbu | "auto"
holeZDiameterAdjustment = 0.3, // mm
holeRoundingResolution = 64, // int TODO remove
holeZPartialX = "none", // "none", "start", "end", "all"
holeZPartialY = "none", // "none", "start", "end", "all"

//Axle Holes
holeAxleThickness = 1, //mbu

//Studs
studs = true, // bool or vector
studType = "solid", // "solid" | "hollow"
studShift = false, // false | "none" | "x" | "y" | true | "xy"
studMaxOverhang = 0.3, // mm
studPadding = 0, // grid

studClampHeight = 0.5, // mbu
studClampThickness = 0.0, // mm

studHoleDiameter = "auto", // mbu | "auto"
studHoleDiameterAdjustment = 0.3, // mm
studHoleClampThickness = 0.1, // mm

studRounding = 0.0625, // mbu
studRoundingResolution = 64, // int TODO remove

studDiameter = 3, // mbu (constant, should not be changed normally)
studDiameterAdjustment = 0.2, // mm

studHeight = 1, // mbu (constant, should not be changed normally)
studHeightAdjustment = 0.0, // mm

studCutoutAdjustment = [0.2, 0.4], // mm [diameter, height]

studIcon = "../pattern/bolt-solid-full.svg",
studIconDimensions = [169.333, 169.333],
studIconScale = 0.024,
studIconDepth = -0.2,
studIconColor = "inherit",

//Tongue
tongue = false, // bool
tongueHeight = 1.25, // mbu
tongueGrooveDepth = 1.5, // mbu
tongueRoundingRadius = "auto", // grid | "auto" (e.g 1.0 or [1, 2, 3, 4]) 
tongueInnerRoundingRadius = "auto", // grid | "auto" (e.g 1.0 or [1, 2, 3, 4]) 
tongueThickness = 0.666, // mbu
tongueThicknessAdjustment = 0, // mm
tongueOffset = 1, // mbu
tongueClampHeight = 0.5, // mbu
tongueClampOffset = 0.25, // mbu
tongueClampThickness = 0.1, // mm

//Grille
grille = "none", // "none" | "x" | "y"
grilleInverted = false, // bool
grilleDepth = 1, // mbu
grilleCount = 5, // int

//Recess
recess = false, // bool
recessRoundingRadius = "auto", // grid | "auto" (e.g 2.7 or [2.7, 2.7, 2.7, 2.7])
recessDepth = "auto", // mm | "auto"
recessWallThickness = 0.333, // grid (e.g. 0.333 or [0.333, 0.333, 0.333, 0.333])
recessStuds = true, // bool
recessStudPadding = 0.2, // grid
recessStudType = "solid", // "solid" | "hollow"
recessStudShift = false, // false | "none" | "x" | "y" | true | "xy"
recessWallGaps = [], // vector

//Text
text = "", // string
textSide = 0, // side
textDepth = -0.25, // mbu
textFont = "Liberation Sans", // font
textSize = 4, // pt
textSpacing = 1, // int
textVerticalAlign = "center",
textHorizontalAlign = "center",
textOffset = [0, 0], // grid (multipliers of gridSizeXY and gridSizeZ depending on side)
textColor = "#2c3e50", // color - Color of text.

//Surface Pattern
surfacePattern = "none",
surfacePatternDimensions = [451.556, 451.556],
surfacePatternOffset = [0,0],
surfacePatternScale=0.25,
surfacePatternDepth=-0.2,
surfacePatternColor="inherit",

//SVG
svg = "", // string
svgSide = 5, // side
svgDepth = 0.4, // mm
svgDimensions = [100, 100], // vector2 x int
svgScale = 1.0, // float
svgOffset = [0, 0], // vector2 x grid (multipliers of gridSizeXY and gridSizeZ depending on side)
svgColor = "#2c3e50", // color - Color of svg

connectors = false, // bool
connectorPadding = [0, 0],
connectorHeight = "auto", // mbu
connectorDepth = 0.75, // mbu
connectorWidth = 2.5, // mbu
connectorDepthTolerance = 0.2, // mm
connectorSideTolerance = 0.1, // mm

//Screw Holes
screwHolesZ = [], // vector
screwHoleZSize = 2.3, // mm
screwHoleZHelperThickness = 0.8, // mm
screwHoleZHelperOffset = 0.2, // mm
screwHoleZHelperHeight = 0.2, // mm

screwHolesX = [], // vector
screwHoleXSize = 2.1, // mm
screwHoleXDepth = 4, // mm

screwHolesY = [], // vector
screwHoleYSize = 2.1, // mm
screwHoleYDepth = 4, // mm

//PCB
pcb = false, // bool
pcbMountingType = "clips",
pcbDimensions = [20, 30, 3], // vector3 x mm
pcbOffset = [0, 0], // vector2 x grid
pcbScrewSocketSize = 5, // mm
pcbScrewSocketHoleSize = 2.2, // mm
pcbScrewSocketHeight = 3, // mm
pcbScrewSockets = [], // vector

//Alignment
align = "start", // string | vector3 x string
alignChildren = "start", // string | vector3 x string
//alignMode = "grid", // "grid" | "object" (If set to object, brick is aligned like a normal scad object - TODO implement object mode)

//Quality
qualitySegBase = 1.2,
qualityResolutionMax = 220,

qualityFactor = [
    0.6,  // FUNCTIONAL
    1.0,  // VISUAL
    1.6,  // OTHER
    2.5   // DRAFT
],

qualityResolutionMin = [
    24, // FUNCTIONAL
    18, // VISUAL
    12, // OTHER
    8  // DRAFT
],

qualityResolutionMultiplier = 0.25,

//Preview
previewQuality = 0.5, // float (between 0.0 and 1.0)
previewRender = false, // bool (Whether the brick should always be rendered in preview mode)
previewRenderConvexity = 15 // int (Convexity for preview rendering)
*/