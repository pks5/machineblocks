// Set fragment number for roundings
$fn = $preview ? 32 : 64;

// Size of the cube (all directions)
cubSiz = 10;

// Radius of the Sphere
sRad = 6;

// The intersection of Cube and Sphere
// The part that both shapes have in common
intersection(){
    cube(size = [cubSiz, cubSiz, cubSiz], center = true);
    sphere(r = sRad);
}