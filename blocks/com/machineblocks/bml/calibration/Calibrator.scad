/**
 * MachineBlocks.com Block File
 *
 * Name: Calibrator
 * Filename: Calibrator.scad
 * FQN: com.machineblocks.bml.calibration.Calibrator
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Visit machineblocks.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../lib/block.scad>;
// Global Config
include <../../../../config/mb_config.scad>;

/*
 * Customization
 */

// Number of samples per calibration row
numberOfSamples = 5; // [3:1:9]

// Font
font = "Liberation Sans";

// Font size (pt)
fontSize = 3; // [1:0.5:8]

// Label block width (in studs)
labelSize = 5; // [3:1:10]

// studDiameterAdjustment — start value (mm)
studDiameterAdjustmentValueStart  = 0.0;   // [-1:0.1:1]
// studDiameterAdjustment — step (mm)
studDiameterAdjustmentValueStep   = 0.1;   // [0.05:0.05:0.5]

// baseWallThicknessAdjustment — start value (mm)
baseWallThicknessAdjustmentValueStart = -0.3; // [-1:0.1:1]
// baseWallThicknessAdjustment — step (mm)
baseWallThicknessAdjustmentValueStep  = 0.1;  // [0.05:0.05:0.5]

// tubeDiameterAdjustment (Z) — start value (mm)
tubeDiameterAdjustmentValueStart = -0.3; // [-1:0.1:1]
// tubeDiameterAdjustment (Z) — step (mm)
tubeDiameterAdjustmentValueStep  = 0.1;  // [0.05:0.05:0.5]

// pinDiameterAdjustment — start value (mm)
pinDiameterAdjustmentValueStart = -0.2; // [-1:0.1:1]
// pinDiameterAdjustment — step (mm)
pinDiameterAdjustmentValueStep  = 0.1;  // [0.05:0.05:0.5]

/*
 * Main Module Call
 */
mb_block__com__machineblocks__calibration__Calibrator(
    config = mb_config,
    settings = [
        ["numberOfSamples",                   numberOfSamples],
        ["font",                              font],
        ["fontSize",                          fontSize],
        ["labelSize",                         labelSize],
        ["studDiameterAdjustmentValueStart",  studDiameterAdjustmentValueStart],
        ["studDiameterAdjustmentValueStep",   studDiameterAdjustmentValueStep],
        ["baseWallThicknessAdjustmentValueStart", baseWallThicknessAdjustmentValueStart],
        ["baseWallThicknessAdjustmentValueStep",  baseWallThicknessAdjustmentValueStep],
        ["tubeDiameterAdjustmentValueStart",  tubeDiameterAdjustmentValueStart],
        ["tubeDiameterAdjustmentValueStep",   tubeDiameterAdjustmentValueStep],
        ["pinDiameterAdjustmentValueStart",   pinDiameterAdjustmentValueStart],
        ["pinDiameterAdjustmentValueStep",    pinDiameterAdjustmentValueStep]
    ]
);

/*
 * Main Module Definition
 * com.machineblocks.bml.calibration.Calibrator
 *
 * Composite block. Renders four calibration rows:
 *   Row 0 (vOffset=0):  studDiameterAdjustment
 *   Row 1 (vOffset=-3): baseWallThicknessAdjustment
 *   Row 2 (vOffset=-6): tubeDiameterAdjustment
 *   Row 3 (vOffset=-9): pinDiameterAdjustment
 *
 * baseHeight = 0.5 unitGrid[1] (≈ 1 mbu = 1.6 mm) for base strips and labels.
 * Rows are spaced 3 studs apart in Y.
 */
module mb_block__com__machineblocks__calibration__Calibrator(config = undef, settings = undef) {
    // Native Parameters
    blockId = mb_param_id(config, settings, "com.machineblocks.bml.calibration.Calibrator");
    align   = mb_param_align(config, settings);
    offset  = mb_param_offset(config, settings);

    // Custom Parameters
    numberOfSamples = mb_param(config, settings, "numberOfSamples", 5);
    font            = mb_param(config, settings, "font", "Liberation Sans");
    fontSize        = mb_param(config, settings, "fontSize", 3);
    labelSize       = mb_param(config, settings, "labelSize", 5);

    studDiameterAdjustmentValueStart  = mb_param(config, settings, "studDiameterAdjustmentValueStart",  0.0);
    studDiameterAdjustmentValueStep   = mb_param(config, settings, "studDiameterAdjustmentValueStep",   0.1);
    baseWallThicknessAdjustmentValueStart = mb_param(config, settings, "baseWallThicknessAdjustmentValueStart", -0.3);
    baseWallThicknessAdjustmentValueStep  = mb_param(config, settings, "baseWallThicknessAdjustmentValueStep",  0.1);
    tubeDiameterAdjustmentValueStart  = mb_param(config, settings, "tubeDiameterAdjustmentValueStart",  -0.3);
    tubeDiameterAdjustmentValueStep   = mb_param(config, settings, "tubeDiameterAdjustmentValueStep",   0.1);
    pinDiameterAdjustmentValueStart   = mb_param(config, settings, "pinDiameterAdjustmentValueStart",   -0.2);
    pinDiameterAdjustmentValueStep    = mb_param(config, settings, "pinDiameterAdjustmentValueStep",    0.1);

    // Derived
    // Row width (base strip): 2*numberOfSamples+1 studs
    // Row height: 3 studs (base strip 1, label 1, value labels 1 below)
    // 4 rows × 3 studs = 12 studs in Y; add 1 for top label row
    totalSizeX = max(2 * numberOfSamples + 1, labelSize);
    totalSizeY = 4 * 3;  // 4 rows, 3 studs each
    totalSizeZ = 2;       // enough to cover base (0.5) + sample blocks (1)

    // Wrapper Block
    mb_block(
        config = config,
        settings = [
            ["id",      blockId],
            ["size",    [totalSizeX, totalSizeY, totalSizeZ]],
            ["align",   align],
            ["offset",  offset],
            ["base",    false],
            ["studs",   false],
            ["alignChildren", "ccs"]
        ]
    ) {
        // Row 0 — studDiameterAdjustment
        mb_block__com__machineblocks__calibration__Calibrator__Base(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "base_stud")],
                ["label",         "studDiaAdj"],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    studDiameterAdjustmentValueStart],
                ["valueStep",     studDiameterAdjustmentValueStep],
                ["font",          font],
                ["fontSize",      fontSize],
                ["labelSize",     labelSize],
                ["offset",        [0, 0, 0]]
            ]
        );
        mb_block__com__machineblocks__calibration__Calibrator__StudDiameter(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "samples_stud")],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    studDiameterAdjustmentValueStart],
                ["valueStep",     studDiameterAdjustmentValueStep],
                ["offset",        [0, 0, 0]]
            ]
        );

        // Row 1 — baseWallThicknessAdjustment
        mb_block__com__machineblocks__calibration__Calibrator__Base(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "base_wall")],
                ["label",         "wallThickAdj"],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    baseWallThicknessAdjustmentValueStart],
                ["valueStep",     baseWallThicknessAdjustmentValueStep],
                ["font",          font],
                ["fontSize",      fontSize],
                ["labelSize",     labelSize],
                ["offset",        [0, -3, 0]]
            ]
        );
        mb_block__com__machineblocks__calibration__Calibrator__BaseWallThickness(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "samples_wall")],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    baseWallThicknessAdjustmentValueStart],
                ["valueStep",     baseWallThicknessAdjustmentValueStep],
                ["offset",        [0, -3, 2]]
            ]
        );

        // Row 2 — tubeDiameterAdjustment
        mb_block__com__machineblocks__calibration__Calibrator__Base(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "base_tube")],
                ["label",         "tubeZDiaAdj"],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    tubeDiameterAdjustmentValueStart],
                ["valueStep",     tubeDiameterAdjustmentValueStep],
                ["font",          font],
                ["fontSize",      fontSize],
                ["labelSize",     labelSize],
                ["offset",        [0, -6, 0]]
            ]
        );
        mb_block__com__machineblocks__calibration__Calibrator__TubeDiameter(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "samples_tube")],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    tubeDiameterAdjustmentValueStart],
                ["valueStep",     tubeDiameterAdjustmentValueStep],
                ["offset",        [0, -6, 2]]
            ]
        );

        // Row 3 — pinDiameterAdjustment
        mb_block__com__machineblocks__calibration__Calibrator__Base(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "base_pin")],
                ["label",         "pinDiaAdj"],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    pinDiameterAdjustmentValueStart],
                ["valueStep",     pinDiameterAdjustmentValueStep],
                ["font",          font],
                ["fontSize",      fontSize],
                ["labelSize",     labelSize],
                ["offset",        [0, -9, 0]]
            ]
        );
        mb_block__com__machineblocks__calibration__Calibrator__PinDiameter(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, "samples_pin")],
                ["numberOfSamples", numberOfSamples],
                ["valueStart",    pinDiameterAdjustmentValueStart],
                ["valueStep",     pinDiameterAdjustmentValueStep],
                ["offset",        [0, -9, 2]]
            ]
        );
    }
}

/*
 * Sub Module "Base"
 * com.machineblocks.bml.calibration.Calibrator.Base
 *
 * Renders the base strip, the label block, and the value label blocks for one row.
 * All blocks use baseHeight = 0.5 unitGrid[1] (size[2] = 0.5).
 * Positions are relative to the row's vOffset (passed via offset[1]).
 */
module mb_block__com__machineblocks__calibration__Calibrator__Base(config = undef, settings = undef) {
    blockId       = mb_param_id(config, settings, "com.machineblocks.bml.calibration.Calibrator.Base");
    rowOffset     = mb_param_offset(config, settings);

    label         = mb_param(config, settings, "label", "");
    numberOfSamples = mb_param(config, settings, "numberOfSamples", 5);
    valueStart    = mb_param(config, settings, "valueStart", 0);
    valueStep     = mb_param(config, settings, "valueStep", 0.1);
    font          = mb_param(config, settings, "font", "Liberation Sans");
    fontSize      = mb_param(config, settings, "fontSize", 3);
    labelSize     = mb_param(config, settings, "labelSize", 5);

    baseZ = 1; // 1 mbu ≈ 1.6 mm
    baseZMod = -0.5;

    // Base strip — centered, at row Y position
    mb_block(
        config = config,
        settings = [
            ["id",            mb_block_id(blockId, "strip")],
            ["size",          [2 * numberOfSamples + 1, 1, baseZ]],
            ["sizeMod", [["z+", baseZMod]]],
            ["baseCutoutType","none"],
            ["studs",         false],
            ["offset",        rowOffset],
            ["align",         "ccs"],
            ["baseAdjustment", [["y", 0.11]]]
        ]
    );

    // Label block — 1 stud above base strip
    mb_block(
        config = config,
        settings = [
            ["id",            mb_block_id(blockId, "label")],
            ["size",          [labelSize, 1, baseZ]],
            ["sizeMod", [["z+", baseZMod]]],
            ["baseCutoutType","none"],
            ["studs",         false],
            ["offset",        [rowOffset[0], rowOffset[1] + 1, rowOffset[2]]],
            ["text",          label],
            ["textFont",      font],
            ["textSize",      fontSize],
            ["textFace",      5],
            ["textDepth",     -0.25],
            ["align",         "ccs"],
            ["baseAdjustment", [["y", 0.11]]]
        ]
    );

    // Value label blocks — 1 stud below base strip, one per sample
    for (i = [0 : numberOfSamples - 1]) {
        mb_block(
            config = config,
            settings = [
                ["id",            mb_block_id(blockId, str("val_", i))],
                ["size",          [1, 1, baseZ]],
                ["sizeMod", [["z+", baseZMod]]],
                ["baseCutoutType","none"],
                ["studs",         false],
                ["offset",        [
                    rowOffset[0] + 2 * (i - floor(0.5 * numberOfSamples)),
                    rowOffset[1] - 1,
                    rowOffset[2]
                ]],
                ["text",          mb_block__com__machineblocks__calibration__Calibrator__func__formatValue(valueStart + i * valueStep)],
                ["textFont",      font],
                ["textSize",      fontSize],
                ["textFace",      5],
                ["textDepth",     0.25],
                ["align",         "ccs"]
            ]
        );
    }
}

/*
 * Sub Module "StudDiameter"
 * com.machineblocks.bml.calibration.Calibrator.StudDiameter
 *
 * Renders one sample block per step with varying studDiameterAdjustment.
 * NOTE: studDiameterAdjustment is config_only in MB3. Its use in settings
 * here is intentional — this is a calibration tool whose purpose is to
 * vary this value per brick.
 */
module mb_block__com__machineblocks__calibration__Calibrator__StudDiameter(config = undef, settings = undef) {
    blockId       = mb_param_id(config, settings, "com.machineblocks.bml.calibration.Calibrator.StudDiameter");
    rowOffset     = mb_param_offset(config, settings);
    numberOfSamples = mb_param(config, settings, "numberOfSamples", 5);
    valueStart    = mb_param(config, settings, "valueStart", 0);
    valueStep     = mb_param(config, settings, "valueStep", 0.1);

    for (i = [0 : numberOfSamples - 1]) {
        mb_block(
            config = config,
            settings = [
                ["id",                    mb_block_id(blockId, str("s", i))],
                ["baseCutoutType",        "none"],
                ["size",                  [1, 1, 0.4]],  // 0.8 mbu ≈ 0.4 unitGrid[1]
                ["studDiameterAdjustment", mb_block__com__machineblocks__calibration__Calibrator__func__round1(valueStart + i * valueStep)],
                ["offset",                [
                    rowOffset[0] + 2 * (i - floor(0.5 * numberOfSamples)),
                    rowOffset[1],
                    rowOffset[2] + 0.5  // sits on top of base strip (0.5 unitGrid[1])
                ]],
                ["align",         "ccs"]
            ]
        );
    }
}

/*
 * Sub Module "BaseWallThickness"
 * com.machineblocks.bml.calibration.Calibrator.BaseWallThickness
 *
 * Renders inverted sample blocks with varying baseWallThicknessAdjustment.
 * CUSTOM SCAD: rotation = [180, 0, 0] is required to flip blocks upside-down.
 * No MB3-native alternative exists for a 180° X-axis flip.
 * NOTE: baseWallThicknessAdjustment is config_only in MB3; used here intentionally.
 */
module mb_block__com__machineblocks__calibration__Calibrator__BaseWallThickness(config = undef, settings = undef) {
    blockId       = mb_param_id(config, settings, "com.machineblocks.bml.calibration.Calibrator.BaseWallThickness");
    rowOffset     = mb_param_offset(config, settings);
    numberOfSamples = mb_param(config, settings, "numberOfSamples", 5);
    valueStart    = mb_param(config, settings, "valueStart", -0.3);
    valueStep     = mb_param(config, settings, "valueStep", 0.1);

    for (i = [0 : numberOfSamples - 1]) {
        mb_block(
            config = config,
            settings = [
                ["id",                         mb_block_id(blockId, str("s", i))],
                ["size",                       [1, 1, 1]],
                ["studs",                      false],
                ["rotation",                   [180, 0, 0]],  // CUSTOM SCAD: intentional flip
                ["baseWallThicknessAdjustment", mb_block__com__machineblocks__calibration__Calibrator__func__round1(valueStart + i * valueStep)],
                ["topPlateHelpers",            false],
                ["offset",                     [
                    rowOffset[0] + 2 * (i - floor(0.5 * numberOfSamples)),
                    rowOffset[1],
                    rowOffset[2] - 0.5  // sits below base strip after flip
                ]],
                ["align",         "ccs"]
            ]
        );
    }
}

/*
 * Sub Module "TubeDiameter"
 * com.machineblocks.bml.calibration.Calibrator.TubeDiameter
 *
 * Renders inverted 2×2 sample blocks with varying tubeDiameterAdjustment.
 * CUSTOM SCAD: rotation = [180, 0, 0] is required to flip blocks upside-down.
 * NOTE: tubeDiameterAdjustment is config_only in MB3; used here intentionally.
 *       V2 tubeZDiameterAdjustment → V3 tubeDiameterAdjustment (unified).
 */
module mb_block__com__machineblocks__calibration__Calibrator__TubeDiameter(config = undef, settings = undef) {
    blockId       = mb_param_id(config, settings, "com.machineblocks.bml.calibration.Calibrator.TubeDiameter");
    rowOffset     = mb_param_offset(config, settings);
    numberOfSamples = mb_param(config, settings, "numberOfSamples", 5);
    valueStart    = mb_param(config, settings, "valueStart", -0.3);
    valueStep     = mb_param(config, settings, "valueStep", 0.1);

    for (i = [0 : numberOfSamples - 1]) {
        mb_block(
            config = config,
            settings = [
                ["id",                    mb_block_id(blockId, str("s", i))],
                ["size",                  [2, 2, 1]],
                ["studs",                 false],
                ["rotation",              [180, 0, 0]],  // CUSTOM SCAD: intentional flip
                ["tubeDiameterAdjustment", mb_block__com__machineblocks__calibration__Calibrator__func__round1(valueStart + i * valueStep)],
                ["baseCrop",              [["xy", -0.5]]],
                ["baseWallThickness",     0],
                ["offset",                [
                    rowOffset[0] + 2 * (i - floor(0.5 * numberOfSamples)),
                    rowOffset[1],
                    rowOffset[2] - 0.5
                ]],
                ["align",         "ccs"]
            ]
        );
    }
}

/*
 * Sub Module "PinDiameter"
 * com.machineblocks.bml.calibration.Calibrator.PinDiameter
 *
 * Renders inverted 2×1 sample blocks with varying pinDiameterAdjustment.
 * CUSTOM SCAD: rotation = [180, 0, 0] is required to flip blocks upside-down.
 * NOTE: pinDiameterAdjustment is config_only in MB3; used here intentionally.
 */
module mb_block__com__machineblocks__calibration__Calibrator__PinDiameter(config = undef, settings = undef) {
    blockId       = mb_param_id(config, settings, "com.machineblocks.bml.calibration.Calibrator.PinDiameter");
    rowOffset     = mb_param_offset(config, settings);
    numberOfSamples = mb_param(config, settings, "numberOfSamples", 5);
    valueStart    = mb_param(config, settings, "valueStart", -0.2);
    valueStep     = mb_param(config, settings, "valueStep", 0.1);

    for (i = [0 : numberOfSamples - 1]) {
        mb_block(
            config = config,
            settings = [
                ["id",                  mb_block_id(blockId, str("s", i))],
                ["size",                [2, 1, 1]],
                ["studs",               false],
                ["rotation",            [180, 0, 0]],  // CUSTOM SCAD: intentional flip
                ["pinDiameterAdjustment", mb_block__com__machineblocks__calibration__Calibrator__func__round1(valueStart + i * valueStep)],
                ["baseCrop",              [["x", -0.5]]],
                ["baseWallThickness",     0],
                ["offset",              [
                    rowOffset[0] + 2 * (i - floor(0.5 * numberOfSamples)),
                    rowOffset[1],
                    rowOffset[2] - 0.5
                ]],
                ["align",         "ccs"]
            ]
        );
    }
}

/**
 * Global function "round1"
 * com.machineblocks.bml.calibration.Calibrator.func.round1
 *
 * Rounds x to 1 decimal place.
 */
function mb_block__com__machineblocks__calibration__Calibrator__func__round1(x) =
    round(x * 10) / 10;

/**
 * Global function "formatValue"
 * com.machineblocks.bml.calibration.Calibrator.func.formatValue
 *
 * Converts a float to a display string, removing the leading "0" before
 * the decimal point (e.g. 0.1 → ".1", -0.2 → "-.2").
 * CUSTOM SCAD: String manipulation — no MB3-native equivalent.
 */
function mb_block__com__machineblocks__calibration__Calibrator__func__formatValue(x) =
    mb_block__com__machineblocks__calibration__Calibrator__func__replaceZeroDot(
        str(mb_block__com__machineblocks__calibration__Calibrator__func__round1(x))
    );

function mb_block__com__machineblocks__calibration__Calibrator__func__replaceZeroDot(s, i = 0) =
    (i >= len(s) - 1) ? s :
    (s[i] == "0" && s[i + 1] == ".")
        ? str(
            mb_block__com__machineblocks__calibration__Calibrator__func__strPrefix(s, i),
            ".",
            mb_block__com__machineblocks__calibration__Calibrator__func__replaceZeroDot(
                mb_block__com__machineblocks__calibration__Calibrator__func__strSuffix(s, i + 2), 0
            )
          )
        : mb_block__com__machineblocks__calibration__Calibrator__func__replaceZeroDot(s, i + 1);

function mb_block__com__machineblocks__calibration__Calibrator__func__strPrefix(s, k, i = 0) =
    (i >= k) ? "" : str(s[i], mb_block__com__machineblocks__calibration__Calibrator__func__strPrefix(s, k, i + 1));

function mb_block__com__machineblocks__calibration__Calibrator__func__strSuffix(s, k, i = 0) =
    (k + i >= len(s)) ? "" : str(s[k + i], mb_block__com__machineblocks__calibration__Calibrator__func__strSuffix(s, k, i + 1));