/**
 * MachineBlocks.com Block File
 *
 * Name: DefaultConfigSet
 * Filename: DefaultConfigSet.scad
 * Package: com.machineblocks.bml.config.DefaultConfigSet
 */

/*
 * Optional Global Functions
 *
 * Caller passes the customizer parameter:
 *   mb__com__machineblocks__scad__config__DefaultConfigSet__func__config(configProfile)
 * configProfile is "fine" or "standard".
 */

function mb__com__machineblocks__scad__config__DefaultConfigSet__func__config(profile) =
    // if
    profile == "fine" ? mb__com__machineblocks__scad__config__DefaultConfigSet__func__fine()
    // else if
    : profile == "standard" ? mb__com__machineblocks__scad__config__DefaultConfigSet__func__standard()
    // else
    : mb__com__machineblocks__scad__config__DefaultConfigSet__func__fine();

function mb__com__machineblocks__scad__config__DefaultConfigSet__func__fine() = [
    ["printerLayerHeight", 0.1],
    ["printerNozzleDiameter", 0.25],
    ["studDiameterAdjustment", 0.1]
];

function mb__com__machineblocks__scad__config__DefaultConfigSet__func__standard() = [
    ["printerLayerHeight", 0.2],
    ["printerNozzleDiameter", 0.4],
    ["studDiameterAdjustment", 0.8]
];
