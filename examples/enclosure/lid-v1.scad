include <../../lib/block.scad>;

knobType = "CLASSIC";

block(
    baseLayers=1,
    grid=[16,1],
    wallGapsX=[[0,0], [15,0]],
    brickOffset=[0,7.5,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[1,16],
    wallGapsY=[[0,0], [15,0]],
    brickOffset=[7.5,0,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[1,16],
    wallGapsY=[[0,1], [15,1]],
    brickOffset=[-7.5,0,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[16,1],
    wallGapsX=[[0,1], [15,1]],
    brickOffset=[0,-7.5,0],
    knobType = knobType,
    knobs = false
);

block(
    baseLayers=1,
    grid=[4,14],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false,
    brickOffset=[-5,0,0]
);

block(
    baseLayers=1,
    grid=[4,14],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false,
    brickOffset=[5,0,0]
);

block(
    baseLayers=1,
    grid=[6,6],
    pillars=false,
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false,
    brickOffset=[0,0,0]
);

block(
    baseLayers=1,
    grid=[6,4],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false,
    brickOffset=[0,5,0]
);

block(
    baseLayers=1,
    grid=[2,3],
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false,
    brickOffset=[0,-5.5,0]
);

block(
    baseLayers=1,
    grid=[2,4],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false,
    brickOffset=[-2,-5,0]
);

block(
    baseLayers=1,
    grid=[2,4],
    baseCutoutType="NONE",
    sideAdjustment=0.2,
    knobType = knobType,
    knobs = false,
    brickOffset=[2,-5,0]
);

difference(){
    union(){
        block(
            baseLayers=1,
            baseCutoutType="NONE",
            grid=[16,16],
            
            brickOffset=[0,0,1],
            knobType = knobType,
            knobs = false,
            withText=true, 
            textSize=6, 
            textSide=5,
            sideAdjustment=[0,0,0,0],
            text="martian", 
            textFont="Space Age", 
            textDepth=0.8, 
            textSpacing=1.1,
            textOffset=[5,-56.3],

            withSvg = true,
            svgFile = "../../martian/martian-logo.svg",
            svgDimensions = [640, 640],
            svgSide = 5,
            svgScale = 0.01,
            svgOffset = [-25, -56],
            svgDepth = 0.8
        );

        translate([0,0,2*3.2 + 0.4])
        cylinder(r=36, h=0.8, center=true);
    }

    translate([0,0,2*3.2])
    cylinder(r=32, h=2, center=true);
}