// Set fragment number for roundings
$fn = $preview ? 32 : 64;

// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// Y-Translation of the Cylinder
tY = 5;

// Create Cube and move Cylinder by 'tY'
// You can put {} around the shape to translate
// It's optional if you translate only one shape
cube(size = [cuSize, cuSize, cuSize], center = true);
translate([0, tY, 0]){
    cylinder(d = cyDia, h = cyHei, center = true);
}