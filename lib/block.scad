echo(version=version());

include <roundedcube.scad>;
include <roundedcube_simple.scad>;

module torus(r1,r2, resolution = 50){
    rotate_extrude(convexity = 10, $fn = resolution)
        translate([0.5*(r2 - r1), 0, 0])
            circle(r = 0.5*r1, $fn = resolution);
}


module block(
        withBaseHoles = true,
        withBaseZHoles = true,
        withKnobs = true,
        withXHoles = false,
        xyHolesOuterSize = 6.5,
        xyHolesInnerSize = 5,
        xyHolesInsetSize = 6.1,
        xyHolesInsetDepth = 0.9,
        withYHoles = false,
        withZHoles = false,
        zHolesOuterSize = 6.4,
        zHolesInnerSize = 5,
        holeResolution = 30,
        baseHeight = 3.15,
        baseLayers = 1,
        baseSideLength = 7.95,
        baseHoleSize = 4.9,
        plateHeight = 0.65,
        grid = [4, 2],
        withKnobsFilled = true,
        withBaseRounding = true,
        knobSize = 5,
        knobHeight = 1.9,
        knobHoleSize = 3.3,
        knobHolderSize = 0.3,
        knobResolution = 30,
        roundingRadius = 0.1,
        roundingResolution = 15,
        center = false){
            
    knobRoundingHeight = 0.25 * (knobSize - knobHoleSize);        
    knobCylinderHeight = knobHeight - knobRoundingHeight;

    objectSizeX = baseSideLength * grid[0];
    objectSizeY = baseSideLength * grid[1];
    
    resultingBaseHeight = baseLayers * baseHeight;
    baseHoleDepth = withBaseHoles ? resultingBaseHeight - plateHeight : 0;
    
    startX = 0;
    endX = grid[0] - 1;
    
    startY = 0;
    endY = grid[1] - 1;
    
    offsetX = center ? 0.5 * (grid[0] - 1) : -0.5;
    offsetY = center ? 0.5 * (grid[1] - 1) : -0.5;
    
    resultingPlateHeight = withBaseHoles ? plateHeight : resultingBaseHeight;        
    totalHeight = resultingBaseHeight + (withKnobs ? knobHeight : 0);        
    
    posZBaseHoles = withBaseHoles ? (center ? -0.5 * (totalHeight - baseHoleDepth) : 0.5 * baseHoleDepth) : 0;        
    posZPlate = posZBaseHoles + (withBaseHoles ? 0.5 * resultingBaseHeight : (center ? -0.5 * (totalHeight - resultingPlateHeight) : 0.5 * resultingPlateHeight));
    posZKnobs = posZPlate + 0.5 * (resultingPlateHeight + knobCylinderHeight);

    roundingApply = withBaseHoles ? (withKnobs ? "all" : "zmin") : (withKnobs ? "zmax" : "z");
    translateRoundingZ = center && withKnobs ? -0.5 * knobHeight : 0; //0.001;
    
    xyHolesZ = center ? 0 : (resultingBaseHeight + knobHeight) / 2;
    xyzHolesY = center ? 0 : objectSizeY / 2;
    xyzHolesX = center ? 0 : objectSizeX / 2;
    
    centerZ = center && withKnobs ? -0.5 * knobHeight : resultingBaseHeight / 2;
    
    zHolesZ = withZHoles ? centerZ : posZBaseHoles;
    zHolesHeight = withZHoles ? resultingBaseHeight : baseHoleDepth;
            
    function posX(a) = (a - offsetX) * baseSideLength;
    function posY(b) = (b - offsetY) * baseSideLength;
    
    union(){
        
        //Base
        difference(){
            intersection(){
                union(){
                    
                    for (a = [ startX : 1 : endX ]){
                        for (b = [ startY : 1 : endY ]){
                           
                           //Base Hole 
                           if(withBaseHoles){ 
                                translate([posX(a), posY(b), posZBaseHoles]){ 
                                    difference() {
                                        //Base Hole
                                        cube([baseSideLength, baseSideLength, baseHoleDepth], center = true);
                                        intersection() {
                                            cube([baseHoleSize, baseHoleSize, baseHoleDepth*1.1], center = true);
                                            cylinder(h=baseHoleDepth*1.2, r=baseHoleSize*0.65, center=true);
                                        };
                                        
                                        //Base hole inset
                                        translate([0, 0, -0.5 * baseHoleDepth]){
                                           intersection() {
                                                cube([baseHoleSize*1.1, baseHoleSize*1.1, 0.1], center = true);
                                                cylinder(h=0.2, r=baseHoleSize*1.1*0.65, center=true);
                                           };
                                        }; 
                                    };
                                };
                           }
                           
                           //Plate
                           translate([posX(a), posY(b), posZPlate]){ 
                                cube([baseSideLength, baseSideLength, resultingPlateHeight], center = true);
                           };
                           
                           //Y Holes outer
                           if(withYHoles && (a == startX) && (b < endY)){
                                translate([xyzHolesX, posY(b + 0.5), xyHolesZ]){
                                    rotate([0, 90, 0]){ 
                                        cylinder(h=objectSizeX, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                    };
                                };
                           }
                           
                           //Z Holes outer
                           if(((withBaseHoles && withBaseZHoles) || withZHoles) && (a < endX) && (b < endY)){
                                translate([posX(a + 0.5), posY(b + 0.5), zHolesZ]){
                                    cylinder(h=zHolesHeight, r=0.5 * zHolesOuterSize, center=true, $fn=holeResolution);
                                };
                           }
                        }
                        //End for b
                        
                        //X Holes outer
                        if(withXHoles && (a < endX)){
                            translate([posX(a + 0.5), xyzHolesY, xyHolesZ]){
                                rotate([90, 0, 0]){ 
                                    cylinder(h=objectSizeY, r=0.5 * xyHolesOuterSize, center=true, $fn=holeResolution);
                                }
                            };
                        }
                        
                    }
                    //End for a

                };
                //End union

                //Base Rounding
                translate([0,0,translateRoundingZ]){
                    if(withBaseHoles && withKnobs){
                        roundedcube_simple(size = [objectSizeX, objectSizeY, resultingBaseHeight], 
                                    center = center, 
                                    radius=roundingRadius, 
                                    resolution=roundingResolution);    
                    }
                    else{
                        roundedcube(size = [objectSizeX, objectSizeY, resultingBaseHeight], 
                                    center = center, 
                                    radius=roundingRadius, 
                                    apply_to=roundingApply,
                                    resolution=roundingResolution);
                    }
                };
            }
            //End intersection
            
            //XHoles
            if(withXHoles){
                for (a = [ startX : 1 : endX-1 ]){
                    translate([posX(a + 0.5),xyzHolesY,xyHolesZ]){
                        rotate([90,0,0]){ 
                            cylinder(h=objectSizeY*1.1, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                            translate([0,0, 0.5 * (objectSizeY - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                            translate([0,0, - 0.5 * (objectSizeY - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                        };
                    };
                }
            }
            
            //YHoles
            if(withYHoles){
                for (b = [ startY : 1 : endY-1 ]){
                    translate([xyzHolesX,posY(b + 0.5),xyHolesZ]){
                        rotate([0,90,0]){ 
                            cylinder(h=objectSizeX*1.1, r=0.5 * xyHolesInnerSize, center=true, $fn=holeResolution);
                            translate([0,0, 0.5 * (objectSizeX - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                            translate([0,0, - 0.5 * (objectSizeX - xyHolesInsetDepth)])
                                cylinder(h=xyHolesInsetDepth, r=0.5 * xyHolesInsetSize, center=true, $fn=holeResolution);
                        };
                    };
                }
            }
            
            //ZHoles
            if((withBaseHoles && withBaseZHoles) || withZHoles){
                for (a = [ startX : 1 : endX-1 ]){
                    for (b = [ startY : 1 : endY-1 ]){
                        translate([posX(a + 0.5),posY(b+0.5),zHolesZ]){
                            cylinder(h=zHolesHeight, r=0.5 * zHolesInnerSize, center=true, $fn=holeResolution);
                        };
                    }
                }
            }
            
        };
        //End difference
        
        //With knobs
        if(withKnobs){
            for (a = [ startX : 1 : endX ]){
                for (b = [ startY : 1 : endY ]){
                    
                    translate([posX(a), posY(b), posZKnobs]){ 
                        //Knob Cylinder
                        //union(){
                            if(withKnobsFilled){
                                cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                            }
                            else{
                                difference(){
                                    cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                                    cylinder(h=knobCylinderHeight * 1.1, r=0.5 * knobHoleSize, center=true, $fn=knobResolution);
                                };
                                
                                //Holder for small poles
                                intersection(){
                                    cylinder(h=knobCylinderHeight, r=0.5 * knobSize, center=true, $fn=knobResolution);
                                    difference(){
                                        cube([knobSize, knobSize, knobCylinderHeight], center=true);
                                        cube([knobHoleSize-knobHolderSize, knobHoleSize-knobHolderSize, knobCylinderHeight*1.1], center=true);
                                    };
                                };
                            }
                            
                            if(withKnobsFilled){
                                translate([0, 0, 0.5 * knobHeight]){ 
                                   cylinder(h=knobRoundingHeight, r=knobHoleSize / 2 + knobRoundingHeight, center=true, $fn=knobResolution);
                                };
                            }
                            
                            //Knob Rounding
                            translate([0, 0, 0.5 * knobCylinderHeight]){ 
                                torus(2 * knobRoundingHeight, knobSize, knobResolution);
                            };
                        //};
                        //End union
                        
                    };
                    
                }
            }
        }
        //End with knobs
    }
    //End union

}    
