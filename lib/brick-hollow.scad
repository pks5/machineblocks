/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Brick Hollow
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/
echo(version=version());

module brickHollow(height=9.3, fade=2.5, minSize=[4.6,4.6], maxSize=[5.2, 5.2], center = false){
    echo(height, minSize, maxSize, fade);
    sizeX = max(minSize[0],maxSize[0]); 
   sizeY = max(minSize[1],maxSize[1]); 
    
    posX = center ? 0 : 0.5*sizeX; 
   posY = center ? 0 : 0.5*sizeY;   
   posZ = center ? -0.5 * (height-fade) : 0.5*fade;
    
    cutHelper = 0.2;
    overlapSpace=0.1;
    
    translate([posX, posY, posZ]){
        union(){
            polyhedron(points=[
                [-0.5*minSize[0],-0.5*minSize[1],-0.5*fade],
                [0.5*minSize[0],-0.5*minSize[1],-0.5*fade],
                [0.5*minSize[0],0.5*minSize[1],-0.5*fade],
                [-0.5*minSize[0],0.5*minSize[1],-0.5*fade],
                [-0.5*maxSize[0],-0.5*maxSize[1],0.5*fade],
                [0.5*maxSize[0],-0.5*maxSize[1],0.5*fade],
                [0.5*maxSize[0],0.5*maxSize[1],0.5*fade],
                [-0.5*maxSize[0],0.5*maxSize[1],0.5*fade]
            ], faces=[[0,1,2,3],[1,0,4,5],[2,1,5,6],[3,2,6,7],[0,3,7,4],[7,6,5,4]]);
            
            if(height > fade){
                translate([0,0,0.5*height - overlapSpace]){
                    cube([maxSize[0], maxSize[1], height - fade + overlapSpace], center=true);
                }
            }
            
            translate([0,0,-0.5*(fade + cutHelper) + overlapSpace]){
                cube([minSize[0], minSize[1], cutHelper + overlapSpace], center=true);
            }
        }
    }
}

//brickHollow(height=9.3, maxSize=[5.2,5.2], minSize=[4.6,4.6], center=true);
