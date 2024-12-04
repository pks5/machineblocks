// Size of the cube (all directions)
cubSiz = 10;

//Diameter of the Cylinder
cyDia = 10;

//Height of the Cylinder
cyHei = 15;

// Or subtract Cube from Cylinder
// The order does matter with difference()
difference(){
    cylinder(d = cyDia, h = cyHei, center = true);
    cube(size = [cubSiz, cubSiz, cubSiz], center = true);
}