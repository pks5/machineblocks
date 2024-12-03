// Size of the cube (all directions)
cubSiz = 10;

//Diameter of the Cylinder
cyDia = 10;

//Height of the Cylinder
cyHei = 15;

//Radius of the Sphere
sRad = 6;

// You can subtract multiple shapes
// 2nd, 3rd, etc shape is subtracted from 1st shape
difference(){
    cube(size = [cubSiz, cubSiz, cubSiz], center = true);
    cylinder(d = cyDia, h = cyHei, center = true);
    sphere(r = sRad);
}