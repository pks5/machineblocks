// Set fragment number for roundings
$fn = $preview ? 32 : 64;

// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// Z-Translation of the Cylinder
tZ = 5;

// Create Cube and move Cylinder by 'tZ'
cube(size = [cuSize, cuSize, cuSize], center = true);
translate([0, 0, tZ])
    cylinder(d = cyDia, h = cyHei, center = true);