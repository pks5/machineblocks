use <shapes.scad>;

//Dupont plug grid size is 2.54 mm
module mb_dupont_plug(
    gridSize = 2.54,
    plugSize = 2.8,
    borderWidth = 0.8,
    borderRadius = 0.8,
    blindHoleDiameter = 1.2,

    totalDepth = 12,

    grid = [1, 1],
    blinds=[]
){

    totalWidth = grid[0] * gridSize + 2 * borderWidth + plugSize - gridSize;
    totalHeight = grid[1] * gridSize + 2 * borderWidth + plugSize - gridSize;

    function is_blind(a, b, i) = (i < len(blinds)) && (((a == blinds[i][0]) && (b == blinds[i][1])) || is_blind(a, b, i + 1)); 

    difference(){
        mb_roundedcube_custom(
            size = [totalWidth, totalHeight, totalDepth], 
            center = true, 
            radius = borderRadius, 
            resolution = 30
        );

        for (a = [ 0 : 1 : grid[0] - 1 ]){
            for (b = [ 0 : 1 : grid[1] - 1 ]){
                translate([(a + 0.5 - 0.5 * grid[0]) * gridSize, (b + 0.5 - 0.5 * grid[1]) * gridSize, 0]){
                    if(is_blind(a, b, 0)){
                        cylinder(r = 0.5*blindHoleDiameter, h=totalDepth*1.1, center=true, $fn=30);
                    }
                    else{
                        cube(
                            size = [plugSize, plugSize, totalDepth * 1.1],
                            center = true
                        );
                    }
                }
            }
        }
    }
}