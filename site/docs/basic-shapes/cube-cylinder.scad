// Set fragment number for roundings
$fn = $preview ? 32 : 64;

// Cube and Cylinder combined
// The Cube is 10mm wide
// The Cylinder has a diameter of 10mm
// You wouldn't see the Cylinder
// But the Cylinder is higher (15mm)
cube(size = [10, 10, 10], center = true);
cylinder(d = 10, h = 15, center = true);