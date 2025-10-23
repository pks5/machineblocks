// Set fragment number for roundings
$fn = $preview ? 32 : 64;

// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// The radius of the Sphere
sphereRadius = 6;

// X-Translation of the Cylinder and Sphere
tX = 5;

// Create Cube and move Cylinder and Sphere by 'tX'
// Then move Sphere again by 'tX'
// The inner translation does not need {} around
// if you only translate one shape
cube(size = [cuSize, cuSize, cuSize], center = true);
translate([tX, 0, 0]){
    cylinder(d = cyDia, h = cyHei, center = true);
    translate([tX, 0, 0])
        sphere(r = sphereRadius);
}