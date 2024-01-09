echo(version=version());

include <../lib/block.scad>;

translate([-20, -20, 0])
    block(
        baseLayers=3, 
        grid=[2,2],
        center=false
    );
        
translate([-20, -40, 0])
    block(
        baseLayers=3, 
        grid=[3,2],
        center=false
    );
        
translate([-20, -60, 0])
    block(
        baseLayers=3, 
        grid=[4,2],
        center=false
    );
        
translate([-20, -80, 0])
    block(
        baseLayers=3, 
        grid=[6,2],
        center=false
    );
    
    translate([-44, -120, 0])
    block(
        baseLayers=3, 
        grid=[2,14],
        center=false
    );
    
translate([-20, -120, 0])
    block(
        baseLayers=3, 
        grid=[4,4],
        center=false
    );
    
translate([50, -84,0])
    rotate([0,0,180]){     
        translate([0, -20, 0])
            block(
                grid=[2,2],
                center=false
            );
                
        translate([0, -40, 0])
            block(
                grid=[3,2],
                center=false
            );
                
        translate([0, -60, 0])
            block(
                grid=[4,2],
                center=false
            );
                
        translate([0, -80, 0])
            block(
                grid=[6,2],
                center=false
            );
}

translate([20, -120, 0])
    block(
        grid=[12,4],
        center=false
    );

translate([116, -92,0])
    rotate([0,0,180]){        
        translate([0, -20, 0])
            block(
                baseLayers=3, 
                grid=[1,1],
                center=false
            );
                
        translate([0, -40, 0])
            block(
                baseLayers=3, 
                grid=[2,1],
                center=false
            );
                
        translate([0, -60, 0])
            block(
                baseLayers=3, 
                grid=[4,1],
                center=false
            );
                
        translate([0, -80, 0])
            block(
                baseLayers=3, 
                grid=[6,1],
                center=false
            );
    }
    
 translate([56, -20, 0])
        block(
            grid=[1,1],
            center=false
        );
        
translate([56, -40, 0])
        block(
            grid=[2,1],
            center=false
        );
        
translate([56, -60, 0])
        block(
            grid=[4,1],
            center=false
        );
        
translate([56, -80, 0])
        block(
            grid=[6,1],
            center=false
        );