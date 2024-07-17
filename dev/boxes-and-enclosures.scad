echo(version=version());

include <../examples/pcbs/lib/pcb_block.scad>;

translate([0, 0, 30])
    pcb_block(
        top=true, 
        brickHeight=2, 
        grid=[4,4]
    );

translate([0, 0, 0])
    hollowBlock(brickHeight=2, grid=[4,4], alignBottom=true, top=false);

translate([-40, 0, 0]){
    
    translate([0, 0, 30])
        pcb_block(
            top=true, 
            grid=[3,4], 
            brickHeight=2, 
            withText=true,
            text="\uf0eb",
            textFont="Font Awesome 6 Free Solid"
        );

    pcb_block(
        top=false, 
        grid=[3,4], 
        pcbY=19.2, 
        pcbX=15.5, 
        pins=[0,0,0,0]
    );
}

translate([-80, 0, 0]){
    block(
        grid=[4,4],
        baseLayers=8,
        withPit=true
    );
    
    translate([0, 0, 40])
    block(
        grid=[4,4]
    );
}