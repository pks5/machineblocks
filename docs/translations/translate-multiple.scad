// Size of the Cube (all directions)
cuSize = 10;

// The diameter of the Cylinder
cyDia = 10;

// The height of the Cylinder
cyHei = 15;

// The radius of the Sphere
sphereRadius = 6;

// X-Translation of the Cylinder and Sphere
tX = 5;

// Create Cube and move Cylinder and Sphere by 'tX'
// You need to use {} around the shapes to translate
cube(size = [cuSize, cuSize, cuSize], center = true);
translate([tX, 0, 0]){
    cylinder(d = cyDia, h = cyHei, center = true);
    sphere(r = sphereRadius);
}