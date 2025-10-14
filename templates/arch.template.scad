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
brickSizeX = 8;
// Brick size in Y-direction specified as multiple of an 1x1 brick.
brickSizeY = 2; // [1:32]  
// Height of brick specified as number of layers. Each layer has the height of one plate.
brickHeight = 3; // [1:24]

// Size of first pillar in X-direction specified as multiple of an 1x1 brick.
column1SizeX = 2;
// Size of second pillar in X-direction specified as multiple of an 1x1 brick.
column2SizeX = 2;
// Height of the deck as multiple of a plate
deckHeight = 1;

// Shape of the span between columns
spanShape = "round"; // [square, round]

/* [Base] */

/*{BASE_VARIABLES}*/

/* [Hidden] */
brickTotalSizeY = (brickSizeY * unitGrid[0] * unitMbu + 2 * baseSideAdjustment);

tunnelWidth = (brickSizeX - column1SizeX - column2SizeX) * unitGrid[0] * unitMbu;
tunnelHeight = (brickHeight - deckHeight) * unitGrid[1] * unitMbu;

// First Pillar
machineblock(
    size = [column1SizeX, brickSizeY, brickHeight - deckHeight],
    studs = false,

    /*{BASE_PARAMETERS}*/
    
    baseSideAdjustment = baseSideAdjustment,
    
    /*{PRESET_PARAMETERS}*/
){

    if(spanShape != "square"){
        difference(){
            // Tunnel
            machineblock(
                size = [brickSizeX - column1SizeX - column2SizeX, brickSizeY, brickHeight - deckHeight],
                offset = [column1SizeX,0,0],
                baseCutoutType = "none",
                studs = false,

                /*{BASE_PARAMETERS}*/
                
                baseSideAdjustment = [-baseSideAdjustment, -baseSideAdjustment,baseSideAdjustment, baseSideAdjustment],
                
                /*{PRESET_PARAMETERS}*/
            );
            
            if(spanShape == "round"){
                translate([0.5*tunnelWidth + column1SizeX * unitGrid[0] * unitMbu, 0.5*(brickTotalSizeY)- baseSideAdjustment, 0])
                rotate([90,0,0])
                    scale([1, 2* tunnelHeight / tunnelWidth, 1])
                        cylinder(h = 1.1*brickTotalSizeY, r = 0.5*tunnelWidth, center=true);
            }
        }
    }

    // Second Pillar
    machineblock(
        size = [column2SizeX, brickSizeY, brickHeight - deckHeight],
        offset = [brickSizeX - column2SizeX,0,0],
        studs = false,

        /*{BASE_PARAMETERS}*/
        
        baseSideAdjustment = baseSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
    );

    // Bridge
    machineblock(
        size = [brickSizeX, brickSizeY, deckHeight],
        offset = [0,0,brickHeight - deckHeight],
        baseCutoutType = "none",

        /*{BASE_PARAMETERS}*/
        
        baseSideAdjustment = baseSideAdjustment,
        
        /*{PRESET_PARAMETERS}*/
    );
}