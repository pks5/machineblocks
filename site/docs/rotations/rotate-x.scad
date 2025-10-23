// Set fragment number for roundings
$fn = $preview ? 32 : 64;

// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// X-Rotation of the Cylinder
rX = 45;

// Create Cube and rotate Cylinder by 'rX'
cube(size = [cuSize, cuSize, cuSize], center = true);
rotate([rX, 0, 0])
    cylinder(d = cyDia, h = cyHei, center = true);