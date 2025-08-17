/*
* Extracts the z-radis from the base radius as four dimensional vector
*/
function mb_base_rounding_radius_z(radius) = radius[2] == undef ? 
        [radius, radius, radius, radius] : 
        (radius[2][0] == undef ? [radius[2], radius[2], radius[2], radius[2]] : radius[2]);

/*
* Creates a four dimensional vector with the inner rounding radius
*/
function mb_base_cutout_radius(cutoutRadius, baseRadiusZ) = cutoutRadius == 0 ? 0 : (cutoutRadius[0] == undef ? 
    [
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[0]), 
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[1]),
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[2]),
        mb_calc_rounding_radius(cutoutRadius, baseRadiusZ[3])   
    ] : 
    [
        mb_calc_rounding_radius(cutoutRadius[0], baseRadiusZ[0]), 
        mb_calc_rounding_radius(cutoutRadius[1], baseRadiusZ[1]),
        mb_calc_rounding_radius(cutoutRadius[2], baseRadiusZ[2]),
        mb_calc_rounding_radius(cutoutRadius[3], baseRadiusZ[3])   
    ]);
function mb_calc_rounding_radius(radius, baseRadius) = radius < 0 ? max(0, baseRadius + radius) : radius;