/**
* Machine Blocks
* https://machineblocks.com/examples/corner
*
* Drill Holder
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

// Imports
/*{IMPORTS}*/

/* [Render] */
// Select "unassembled" for printing without support. Select "merged" for printing as one piece. Use "assembled" only for preview.
assemblyMode = "merged"; // [unassembled, assembled, merged]

/* [Size] */

brick1SizeX = 4;
brick1HolesZ = true;
brick1KnobType = "classic"; // [classic, technic]

brick2SizeX = 4;
brick2HolesZ = true;
brick2KnobType = "classic"; // [classic, technic]

gridSizeY = 2;
middleSizeX = 1;
middleLayers = 2;

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Studs] */
//Whether to render the stud icon
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */
multipart = assemblyMode != "merged";
assembled = assemblyMode != "unassembled";

/*{HIDDEN_PARAMETERS}*/

machineblock(
    size=[brick1SizeX,gridSizeY,1],
    offset=[-0.5*(brick1SizeX-middleSizeX),0,0],
    holeZ=[brick1HolesZ,[brick1SizeX-middleSizeX-1,0,brick1SizeX-2,gridSizeY-2,true]],
    studType = brick1KnobType,
    studIcon = studIcon,
    align="ccs",

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

machineblock(
    size=[middleSizeX,gridSizeY,middleLayers],
    offset=[0,0,1],
    studs = false,
    tongue = multipart,
    align="ccs",
    studIcon = studIcon,

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);

machineblock(
    size=[middleSizeX,gridSizeY,1],
    offset=[0, assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    studType = brick2KnobType,
    baseCutoutType = multipart ? "groove" : "none",
    tongueThicknessAdjustment = 0.1,
    align="ccs",
    studIcon = studIcon,

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = [bSideAdjustment, -bSideAdjustment, bSideAdjustment, bSideAdjustment],
    
    /*{PRESET_PARAMETERS}*/
);


machineblock(
    size=[brick2SizeX-middleSizeX,gridSizeY,1],
    offset=[0.5*(brick2SizeX-middleSizeX+middleSizeX), assembled ? 0 : -gridSizeY-0.5, assembled ? middleLayers+1 : 0],
    holeZ=brick2HolesZ,
    studType = brick2KnobType,
    align="ccs",
    studIcon = studIcon,

    /*{BASE_PARAMETERS}*/

    baseSideAdjustment = bSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
    
);
