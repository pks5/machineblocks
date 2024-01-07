include <roundedcube.scad>;

module base(size, baseRounding, roundingRadius, roundingResolution, center=true){
        if(baseRounding == "none"){
            cube(size = size, center = center);    
        }
        else if(baseRounding == "all"){
            roundedcube_simple(size = size, 
                        center = center, 
                        radius=roundingRadius, 
                        resolution=roundingResolution);    
        }
        else{
            roundedcube(size = size, 
                        center = center, 
                        radius=roundingRadius, 
                        apply_to=baseRounding,
                        resolution=roundingResolution);
        }
}