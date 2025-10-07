use <../../../lib/block.scad>;
include <../../../config/presets.scad>;

// The height of the Tree.
treeHeight = 100; //[10:400]

// The bottom diameter of the Tree. Please ensure in the preview, that the angle of the segments are not too flat. You can correct it by decreasing the diameter and/or increasing the height Otherwise it will cause print fails if you are using vase mode or zero infill!
treeBottomDiameter = 66; //[10:300]

// Number of segments.
treeSegments = 10; //[3:100]

// Set the number of sides. A value between 3 and 10 looks like a low poly Tree. Greater than 24 looks like a round tree.
numberOfSides = 7;  //[3:100]

//Grid Size X-direction
gridX = 6; 
//Grid Size Y-direction
gridY = 6; 
//Number of layers
baseLayers = 1;
//Draw Knobs
knobs = [true, [1,1,4,4,true]];



/* [Hidden] */
segmentH = treeHeight / (treeSegments + 1);
halfSegmentH = segmentH / 2;
segmentW = treeBottomDiameter / (treeSegments + 1);
treeD = treeBottomDiameter;


translate([0,0,16])
color("green")
for(segment = [0:1:treeSegments - 1]) {
    bottom_d = treeD - segmentW * (segment + 1) > 0 ? treeD - segmentW * (segment + 1) : 2;
    middle_d = treeD - segmentW * segment > 0 ? treeD - segmentW * segment : 2;
    top_d = treeD - segmentW * (segment + 2) > 0 ? treeD - segmentW * (segment + 2) : 2;
    dynamic_halfSegmentH = segment == treeSegments - 1 ? halfSegmentH * 3 : halfSegmentH;
    translate([0, 0, segmentH * segment]) {        
        cylinder(d1 = bottom_d, d2 = middle_d, h = halfSegmentH, $fn = numberOfSides);
        translate([0, 0, halfSegmentH]) {
            cylinder(d1 = middle_d, d2 = top_d, h = dynamic_halfSegmentH, $fn = numberOfSides);
        }
    }
}


//Generate the block
color("brown")
machineblock(
    size = [gridX, gridY,baseLayers],
    align="ccs",
    studs = knobs,

    scale = scale,
    baseHeightAdjustment = baseHeightAdjustment,
    baseSideAdjustment = baseSideAdjustment,
    baseWallThicknessAdjustment = baseWallThicknessAdjustment,
    baseClampThickness = baseClampThickness,
    tubeXDiameterAdjustment = tubeXDiameterAdjustment,
    tubeYDiameterAdjustment = tubeYDiameterAdjustment,
    tubeZDiameterAdjustment = tubeZDiameterAdjustment,
    holeXDiameterAdjustment = holeXDiameterAdjustment,
    holeYDiameterAdjustment = holeYDiameterAdjustment,
    holeZDiameterAdjustment = holeZDiameterAdjustment,
    pinDiameterAdjustment = pinDiameterAdjustment,
    studDiameterAdjustment = studDiameterAdjustment,
    studCutoutAdjustment = studCutoutAdjustment,
    previewRender = previewRender
);

translate([0,0,10])
color("brown")
    cylinder(r=5, h=16, center=true);