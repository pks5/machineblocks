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

// Create Sphere and rotate Cylinder and Cube by 'rX'
// Then rotate Cube again by 'rX'
// We rotated the Cube by 90 degrees in total
// Which does nothing with a Cube
sphere(r = sphereRadius);
rotate([rX, 0, 0]){
    cylinder(d = cyDia, h = cyHei, center = true);
    rotate([rX, 0, 0])
        cube(size = [cuSize, cuSize, cuSize], center = true);        
}