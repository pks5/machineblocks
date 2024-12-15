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

// X-Rotation of the Cylinder and Cube
rX = 45;

// Create Sphere and rotate Cube and Cylinder by 'rX'
// You need to use {} around the shapes to rotate
sphere(r = sphereRadius);
rotate([rX, 0, 0]){
    cube(size = [cuSize, cuSize, cuSize], center = true);
    cylinder(d = cyDia, h = cyHei, center = true);
}