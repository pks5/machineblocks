/*
* Extracts the z-radis from the base radius as four dimensional vector
*/
function get_base_rounding_radius_z(radius) = radius[2] == undef ? 
        [radius, radius, radius, radius] : 
        (radius[2][0] == undef ? [radius[2], radius[2], radius[2], radius[2]] : radius[2]);

/*
*
*/
function get_base_cutout_radius(cutoutRadius, baseRadiusZ) = cutoutRadius == 0 ? 0 : (cutoutRadius[0] == undef ? 
    [
        calc_rounding_radius(cutoutRadius, baseRadiusZ[0]), 
        calc_rounding_radius(cutoutRadius, baseRadiusZ[1]),
        calc_rounding_radius(cutoutRadius, baseRadiusZ[2]),
        calc_rounding_radius(cutoutRadius, baseRadiusZ[3])   
    ] : 
    [
        calc_rounding_radius(cutoutRadius[0], baseRadiusZ[0]), 
        calc_rounding_radius(cutoutRadius[1], baseRadiusZ[1]),
        calc_rounding_radius(cutoutRadius[2], baseRadiusZ[2]),
        calc_rounding_radius(cutoutRadius[3], baseRadiusZ[3])   
    ]);
function calc_rounding_radius(radius, baseRadius) = radius < 0 ? max(0, baseRadius + radius) : radius;