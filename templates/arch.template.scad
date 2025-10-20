/**
* MachineBlocks
* https://machineblocks.com/examples/classic-bricks
*
* Slim Plate 2x1
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
brickSizeX = 4;
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 1; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
brickHeight = 3; // [1:24]

// Size of first pillar in X-direction specified as multiple of an 1x1 brick.
column1SizeX = 1;
// Height of the deck as multiple of a plate
deckHeight = 1;

//Whether the arc has a second column
secondColumn = false;
// Size of second pillar in X-direction specified as multiple of an 1x1 brick.
column2SizeX = 1;

inverted = false;

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Studs] */
//Whether to render the stud icon
studIcon = true;

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

tunnelWidth = (secondColumn ? 1 : 2)*(brickSizeX - column1SizeX - (secondColumn ? column2SizeX : 0)) * unitGrid[0] * unitMbu;
tunnelHeight = (brickHeight - deckHeight) * unitGrid[1] * unitMbu;

brickTotalSizeY = (brickSizeY * unitGrid[0] * unitMbu + 2 * bSideAdjustment);

difference(){
    // First Column
    machineblock(
        size = [inverted ? brickSizeX : column1SizeX, brickSizeY, brickHeight],
        studIcon = studIcon,

        /*{BASE_PARAMETERS}*/

        baseSideAdjustment = bSideAdjustment,
        baseCutoutMaxDepth = inverted ? 2 : 5,

        /*{PRESET_PARAMETERS}*/
    ){
        if(!inverted){
            if(secondColumn){
                machineblock(
                    size = [column2SizeX, brickSizeY, brickHeight],
                    offset = [brickSizeX - column2SizeX, 0, 0],
                    studIcon = studIcon,

                    /*{BASE_PARAMETERS}*/

                    baseSideAdjustment = bSideAdjustment,

                    /*{PRESET_PARAMETERS}*/
                );
            }

    
            difference(){
                // Tunnel
                machineblock(
                    size = [brickSizeX - column1SizeX - (secondColumn ? column2SizeX : 0), brickSizeY, brickHeight],
                    offset = [column1SizeX,0,0],
                    baseCutoutType = "none",
                    studIcon = studIcon,
                    
                    /*{BASE_PARAMETERS}*/
                    
                    baseSideAdjustment = [-bSideAdjustment, secondColumn ? -bSideAdjustment : bSideAdjustment, bSideAdjustment, bSideAdjustment],

                    /*{PRESET_PARAMETERS}*/
                );
                
                
                translate([0.5*tunnelWidth + column1SizeX * unitGrid[0] * unitMbu, 0.5*(brickTotalSizeY) - bSideAdjustment, 0])
                    rotate([90,0,0])
                        scale([1, 2* tunnelHeight / tunnelWidth, 1])
                            cylinder(h = 1.1*brickTotalSizeY, r = 0.5*tunnelWidth, center=true, $fn=roundingResolution);
                
            }
        
        }
        
    }

    if(inverted){
        translate([0.5*tunnelWidth + column1SizeX * unitGrid[0] * unitMbu, 0.5*(brickTotalSizeY) - bSideAdjustment, brickHeight * unitGrid[1] * unitMbu])
                    rotate([90,0,0])
                        scale([1, 2* tunnelHeight / tunnelWidth, 1])
                            cylinder(h = 1.1*brickTotalSizeY, r = 0.5*tunnelWidth, center=true, $fn=roundingResolution);
    }
}