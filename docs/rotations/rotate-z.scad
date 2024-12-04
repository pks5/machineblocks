// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// Z-Rotation of the Cylinder
rZ = 45;

// Create Cube and rotate Cylinder by 'rZ'
// Rotation around Z-Axis does nothing
// Because the Cylinder is round
cube(size = [cuSize, cuSize, cuSize], center = true);
rotate([0, 0, rZ])
    cylinder(d = cyDia, h = cyHei, center = true);