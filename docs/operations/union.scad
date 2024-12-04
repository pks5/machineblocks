// Size of the cube (all directions)
cubSiz = 10;

//Diameter of the Cylinder
cyDia = 10;

//Height of the Cylinder
cyHei = 15;

// Create a union from a Cube and Cylinder
// Seems to be superfluous
// You will learn later why it's needed
union(){
    cube(size = [cubSiz, cubSiz, cubSiz], center = true);
    cylinder(d = cyDia, h = cyHei, center = true);
}