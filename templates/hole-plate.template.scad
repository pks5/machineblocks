/**
* MachineBlocks
* {URL}
*
* {BRICK_NAME}
* Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
/*{IMPORTS}*/

/* [Size] */

// Brick size in X-direction specified as multiple of an 1x1 brick.
brickSizeX = 4; // [1:32]  
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
baseLayers = 1; // [1:24]
// Border Size as multiple of an 1x1 brick.
borderSize = 1; // [1:8]

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Knobs] */

// Whether to draw knobs.
knobs = true;
// Type of the knobs
knobType = "solid"; // [solid, hollow]
//Whether to render the stud icon
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

/* [Pin Holes] */

pinHoles = false;
pinHolesCentered = true;

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

// Generate the block
union(){
    machineblock(
        size=[borderSize, brickSizeY,baseLayers], 
        studs=knobs,
        studType=knobType,
        studIcon = studIcon,
        /*{BASE_PARAMETERS}*/

        holeYCentered = pinHolesCentered,
        holeY = pinHoles ? [false, [1,0,brickSizeY - (pinHolesCentered ? 3 : 2),0]] : false,
        baseWallGapsY=[[0,1,borderSize], [brickSizeY-borderSize,1,borderSize]],
        offset=[-0.5*(brickSizeX-borderSize),0,0],
        align="ccs",
        
        baseSideAdjustment = bSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
    );  

    machineblock(
        size=[brickSizeX,borderSize,baseLayers],
        studs=knobs,
        studType=knobType,
        studIcon = studIcon,
        /*{BASE_PARAMETERS}*/

        holeXCentered = pinHolesCentered,
        holeX = pinHoles ? [false, [1,0,brickSizeX - (pinHolesCentered ? 3 : 2),0]] : false,
        baseWallGapsX=[[0,0,borderSize], [brickSizeX-borderSize,0,borderSize]],
        offset=[0,0.5*(brickSizeY-borderSize),0],
        align="ccs",

        baseSideAdjustment = bSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );

    machineblock(
        size=[borderSize, brickSizeY,baseLayers], 
        studs=knobs,
        studType=knobType,
        studIcon = studIcon,
        /*{BASE_PARAMETERS}*/

        holeYCentered = pinHolesCentered,
        holeY = pinHoles ? [false, [1,0,brickSizeY - (pinHolesCentered ? 3 : 2),0]] : false,
        baseWallGapsY=[[0,0,borderSize], [brickSizeY-borderSize,0,borderSize]],
        offset=[0.5*(brickSizeX-borderSize),0,0],
        align="ccs",
        
        baseSideAdjustment = bSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );    

    machineblock(
        size=[brickSizeX,borderSize,baseLayers], 
        studs=knobs,
        studType=knobType,
        studIcon = studIcon,
        /*{BASE_PARAMETERS}*/

        holeXCentered = pinHolesCentered,
        holeX = pinHoles ? [false, [1,0,brickSizeX - (pinHolesCentered ? 3 : 2),0]] : false,
        baseWallGapsX=[[0,1,borderSize], [brickSizeX-borderSize,1,borderSize]],
        offset=[0,-0.5*(brickSizeY-borderSize),0],
        align="ccs",
        
        baseSideAdjustment = bSideAdjustment,
    
        /*{PRESET_PARAMETERS}*/
    );
}