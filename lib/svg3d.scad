
module mb_svg3d(file, orgWidth, orgHeight, depth, size, center = true){
    translate([0, 0, -0.5*depth])
    //scale([size, size, 1])
        //surface(file = file, center = true, invert = true);
        
        
        linear_extrude(depth) {
            scale([size, size, 0])
            translate([-0.5*orgWidth, -0.5*orgHeight, 0])
                import(file);
        }
        
    
}