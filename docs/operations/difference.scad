// Size of the cube (all directions)
cubSiz = 10;

//Diameter of the Cylinder
cyDia = 10;

//Height of the Cylinder
cyHei = 15;

// Let's subtract the Cylinder from the Cube
difference(){
    cube(size = [cubSiz, cubSiz, cubSiz], center = true);
    cylinder(d = cyDia, h = cyHei, center = true);
}