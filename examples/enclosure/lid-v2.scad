include <../../lib/block.scad>;

knobType = "CLASSIC";

difference(){
    union(){
        block(
            baseLayers=1,
            grid=[16,1],
            wallGapsX=[[0,0], [15,0]],
            brickOffset=[0,7.5,0],
            knobType = knobType,
            knobs = false,
            pillars=[true, [6,0,8,0,true]],
            baseRounding = true,
            baseRoundingRadius = [0, 0, [0,4,4,0]],
            baseCutoutRoundingRadius = [0,2.7,2.7,0]
        );

        block(
            baseLayers=1,
            grid=[1,16],
            wallGapsY=[[0,0], [15,0]],
            brickOffset=[7.5,0,0],
            knobType = knobType,
            knobs = false,
            baseRounding = true,
            baseRoundingRadius = [0, 0, [0,0,4,4]],
            baseCutoutRoundingRadius = [0,0,2.7,2.7]
        );

        block(
            baseLayers=1,
            grid=[1,16],
            wallGapsY=[[0,1], [15,1]],
            brickOffset=[-7.5,0,0],
            knobType = knobType,
            knobs = false,
            baseRounding = true,
            baseRoundingRadius = [0, 0, [4,4,0,0]],
            baseCutoutRoundingRadius = [2.7,2.7,0,0]
        );

        block(
            baseLayers=1,
            grid=[16,1],
            wallGapsX=[[0,1], [15,1]],
            brickOffset=[0,-7.5,0],
            knobType = knobType,
            knobs = false,
            baseRounding = true,
            baseRoundingRadius = [0, 0, [4,0,0,4]],
            baseCutoutRoundingRadius = [2.7,0,0,2.7]
        );

        block(
            baseLayers=1,
            grid=[6,14],
            baseCutoutType="NONE",
            sideAdjustment=0.2,
            knobType = knobType,
            knobs = false,
            brickOffset=[-4,0,0]
        );

        block(
            baseLayers=1,
            grid=[6,14],
            baseCutoutType="NONE",
            sideAdjustment=0.2,
            knobType = knobType,
            knobs = false,
            brickOffset=[4,0,0]
        );

        block(
            baseLayers=1,
            grid=[2,11],
            baseCutoutType="NONE",
            sideAdjustment=0.2,
            knobType = knobType,
            knobs = false,
            brickOffset=[0,1.5,0],

            withText=true, 
            textSize=6, 
            textSide=5,
            text="martian", 
            textFont="Space Age", 
            textDepth=0.8, 
            textSpacing=1.1,
            textOffset=[5/8, -8.5 -0.3/8],

            withSvg = true,
            svgFile = "../../martian/martian-logo.svg",
            svgDimensions = [640, 640],
            svgSide = 5,
            svgScale = 0.01,
            svgOffset = [-25/8, -8.5],
            svgDepth = 0.8
        );

        block(
            baseLayers=1,
            grid=[2,3],
            sideAdjustment=0.2,
            knobType = knobType,
            knobs = false,
            brickOffset=[0,-5.5,0]
        );
    }

    block(
        baseLayers=1,
        baseCutoutType="NONE",
        grid=[2,1],
        sideAdjustment=0,
        knobType = knobType,
        knobs = false,
        brickOffset=[0,8,-0.75]
    );

    translate([0,0,3.2])
    cylinder(r=32, h=3.2, center=true);
}