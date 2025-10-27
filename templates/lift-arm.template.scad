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

// Whether lift arm should be thin
thin = false;

// Whether lift has axle in middle
leg1AxleHoleFirst = false;

// Whether lift has axle in middle
leg1AxleHoleLast = false;

// Size of first leg as multiple of an 1x1 brick.
leg1Size=6;  // [1:32]

// Size of second leg as multiple of an 1x1 brick.
leg2Size=4;  // [1:32]

// Rotation of second leg
leg2Rotation=0;

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Studs] */
//Whether to render the stud icon
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

holeY = leg1AxleHoleLast ? [true, [0,0,0,0,"axle"], [leg1Size-1,0,leg1Size-1,0,"axle"]] : [true, [0,0,0,0,"axle"]];

/*{HIDDEN_PARAMETERS}*/

machineblock(
    baseRoundingRadius = [1.25,0,0],
    baseCutoutRoundingRadius = 0,
    baseCutoutType = "none",
    baseColor = baseColor,
    holeY = holeY,
    holeYCentered = false,
    holeYGridOffsetZ = 2.3125,
    size=[thin ? 0.5 : 1, leg1Size, 2.3125], 
    studs = false,

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
){
    if(leg2Size > 0){
        machineblock(
            rotation = [leg2Rotation,0,0],
            rotationOffset = [0, -0.5, -1.25],
            offset = [0, leg1Size-1, 0],
            baseRoundingRadius = [1.25,0,0],
            baseCutoutRoundingRadius = 0,
            baseCutoutType = "none",
            baseColor = baseColor,
            holeY = [true, [leg2Size-1, 0, leg2Size-1, 0, "axle"]],
            holeYCentered = false,
            holeYGridOffsetZ = 2.3125,
            size=[thin ? 0.5 : 1, leg2Size, 2.3125], 
            studs = false,

            baseSideAdjustment = bSideAdjustment,
            
            /*{PRESET_PARAMETERS}*/
        );
    }
}

