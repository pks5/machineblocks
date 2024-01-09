echo(version=version());

include <../lib/block-v2.scad>;

translate([-26, -20, 0])
    block(
        baseLayers=3, 
        grid=[6,2],
        center=false,
        withHolesX=true
    );
        
translate([-26, -40, 0])
    block(
        baseLayers=3, 
        grid=[4,2],
        center=false,
        withHolesX=true
    );
        
translate([-26, -60, 0])
    block(
        baseLayers=3, 
        grid=[2,2],
        center=false,
        withHolesX=true
    );
        

    

    
translate([32,10,0]){
     
        translate([0, -20, 0])
            block(
                grid=[2,2],
                withHolesZ=true
            );
                
        translate([0, -40, 0])
            block(
                grid=[4,2],
                withHolesZ=true
            );
                
        translate([0, -60, 0])
            block(
                grid=[6,2],
                withHolesZ=true
            );
                
        translate([0, -80, 0])
            block(
                grid=[8,2],
                withHolesZ=true
            );
        }



translate([108, -110,0])
    rotate([0,0,180]){        
        translate([0, -40, 0])
            block(
                baseLayers=3, 
                grid=[2,1],
                center=false,
                withHolesX=true,
                knobsFilled=false
            );
                
        translate([0, -60, 0])
            block(
                baseLayers=3, 
                grid=[4,1],
                center=false,
                withHolesX=true,
                knobsFilled=false
            );
                
        translate([0, -80, 0])
            block(
                baseLayers=3, 
                grid=[6,1],
                center=false,
                withHolesX=true,
                knobsFilled=false
            );
            
       translate([0, -100, 0])
            block(
                baseLayers=3, 
                grid=[8,1],
                center=false,
                withHolesX=true,
                knobsFilled=false
            );
            
            translate([0, -120, 0])
            block(
                baseLayers=3, 
                grid=[16,1],
                center=false,
                withHolesX=true,
                knobsFilled=false
            );
    }
 