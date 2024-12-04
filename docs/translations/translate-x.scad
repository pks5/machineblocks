// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// X-Translation of the Cylinder
tX = 5;

// Create Cube and move Cylinder by 'tX'
cube(size = [cuSize, cuSize, cuSize], center = true);
translate([tX, 0, 0])
    cylinder(d = cyDia, h = cyHei, center = true);