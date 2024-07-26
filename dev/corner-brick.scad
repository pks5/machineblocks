echo(version=version());

include <../lib/block.scad>;


        
block(baseLayers=3, grid=[2,1], wallGapsX=[[0,0]]);

block(baseLayers=3, grid=[1, 2], gridOffset=[-0.5, -0.5, 0], wallGapsY=[[1,1], [0,0]]);

block(baseLayers=3, grid=[2,1], gridOffset=[-1, -1, 0], wallGapsX=[[1,1], [0,0]]);

block(baseLayers=3, grid=[1, 2], gridOffset=[-1.5, -1.5, 0], wallGapsY=[[1,1], [0,0]]);

block(baseLayers=3, grid=[2,1], gridOffset=[-2, -2, 0], wallGapsX=[[1,1], [0,0]]);

block(baseLayers=3, grid=[1, 2], gridOffset=[-2.5, -2.5, 0], wallGapsY=[[1,1], [0,0]]);

block(baseLayers=3, grid=[2,1], gridOffset=[-3, -3, 0], wallGapsX=[[1,1]]);

translate([50,10,0]){
    block(
        grid=[7,1],
        baseLayers = 6,
        knobType = "technic",
        holesX=true
    );
}

translate([26,-20,0]){
    block(
        grid=[4,4]
    );
    
    block(
        grid=[4,2],
        baseLayers=2,
        gridOffset=[0,0,1]
    );    
}

translate([73,-16,0]){
    block(baseLayers=3, grid=[6,1], wallGapsX=[[0,0]]);

    block(baseLayers=3, grid=[1, 4], wallGapsY=[[3,1]], gridOffset=[-2.5, -1.5, 0]);
}

translate([-46,-20,0]){
block(
    grid=[3,5],
    baseLayers = 9
);
}

translate([20,-60,0]){
block(
    grid=[12,2],
    baseSideAdjustment=[-0.1,0.1,-0.1,-0.1]
);
    block(
    grid=[2,4],
    gridOffset=[7,0,0],
    holesZ=true
);
}