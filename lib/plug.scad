/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Plug Holder
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
module plug(
outerWidth = 4.4,
cableEndWidth = 3.8,
plugWidth = 2.6,
height = 7,
cableEndHeight=0,
pins=[0,0,0]
){

difference(){
        
    for (a = [ 0 : 1 : len(pins) - 1 ]){
        translate([a*plugWidth,pins[a]*0.5*plugWidth,-0.5*cableEndHeight]){
            cube([outerWidth, outerWidth, height], center=true);
            
            if(cableEndHeight > 0){
                translate([0,0,0.5*(height + cableEndHeight)]){
                       cube([cableEndWidth, cableEndWidth, cableEndHeight], center=true);
                }
            }
        }
    }

    for (a = [ 0 : 1 : len(pins) - 1 ]){
        translate([a*plugWidth,pins[a]*0.5*plugWidth,0]){
            cube([plugWidth*1.01, plugWidth*1.01, (height + cableEndHeight)*1.1], center=true);
        }
    }

}

}