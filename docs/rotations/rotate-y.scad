// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// Y-Rotation of the Cylinder
rY = 45;

// Create Cube and rotate Cylinder by 'rY'
// You can put {} around the shape to rotate
// It's optional if you rotate only one shape
cube(size = [cuSize, cuSize, cuSize], center = true);
rotate([0, rY, 0]){
    cylinder(d = cyDia, h = cyHei, center = true);
}