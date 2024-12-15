// Variables starting with $ are special
// You cannot rename it
$fn = $preview ? 32 : 64;

// Other variables can be abbreviated!

// The diameter of the Cylinder
dia = 10;

// The height of the Cylinder
hei = 15;

// Create the Cylinder
// We use 'dia' as diameter, 'hei' as height
cylinder(d = dia, h = hei, center = true);