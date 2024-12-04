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
// The inner rotation does not need {} around
// if you only rotate one shape
sphere(r = sphereRadius);
rotate([rX, 0, 0]){
    cylinder(d = cyDia, h = cyHei, center = true);
    rotate([rX, 0, 0])
        cube(size = [cuSize, cuSize, cuSize], center = true);        
}