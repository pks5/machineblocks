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

// Brick size
size = [4, 1, 3]; // [1:32]

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

/*{STUD_VARIABLES}*/

/* [Style] */

/*{STYLE_VARIABLES}*/

/*{OVERRIDE_CONFIG_VARIABLES}*/

/* [Hidden] */

/*{HIDDEN_PARAMETERS}*/

tunnelWidth = (secondColumn ? 1 : 2)*(size[0] - column1SizeX - (secondColumn ? column2SizeX : 0)) * unitGrid[0] * unitMbu;
tunnelHeight = (size[2] - deckHeight) * unitGrid[1] * unitMbu;

brickTotalSizeY = (size[1] * unitGrid[0] * unitMbu + 2 * bSideAdjustment);

difference(){
    // First Column
    machineblock(
        size = [inverted ? size[0] : column1SizeX, size[1], size[2]],
        
        /*{BASE_PARAMETERS}*/

        /*{STUD_PARAMETERS}*/

        /*{STYLE_PARAMETERS}*/

        baseSideAdjustment = bSideAdjustment,
        baseCutoutMaxDepth = inverted ? 2 : 5,

        /*{PRESET_PARAMETERS}*/
    ){
        if(!inverted){
            if(secondColumn){
                machineblock(
                    size = [column2SizeX, size[1], size[2]],
                    offset = [size[0] - column2SizeX, 0, 0],
                    
                    /*{STUD_PARAMETERS}*/

                    /*{BASE_PARAMETERS}*/

                    /*{STYLE_PARAMETERS}*/

                    baseSideAdjustment = bSideAdjustment,

                    /*{PRESET_PARAMETERS}*/
                );
            }

    
            difference(){
                // Tunnel
                machineblock(
                    size = [size[0] - column1SizeX - (secondColumn ? column2SizeX : 0), size[1], size[2]],
                    offset = [column1SizeX,0,0],
                    baseCutoutType = "none",
                    
                    /*{STUD_PARAMETERS}*/

                    /*{STYLE_PARAMETERS}*/
                    
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
        translate([0.5*tunnelWidth + column1SizeX * unitGrid[0] * unitMbu, 0.5*(brickTotalSizeY) - bSideAdjustment, size[2] * unitGrid[1] * unitMbu])
                    rotate([90,0,0])
                        scale([1, 2* tunnelHeight / tunnelWidth, 1])
                            cylinder(h = 1.1*brickTotalSizeY, r = 0.5*tunnelWidth, center=true, $fn=roundingResolution);
    }
}