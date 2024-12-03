// Name variables so you know what they are for!

// Size of the Cube in the X-direction (width)
cuSizeX = 10;

// Size of the Cube in the Y-direction (depth)
cuSizeY = 10;

// Size of the Cube in the Z-direction (height)
cuSizeZ = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

cube(size = [cuSizeX, cuSizeY, cuSizeZ], center = true);
cylinder(d = cyDia, h = cyHei, center = true);