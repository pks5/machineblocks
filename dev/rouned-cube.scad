echo(version=version());

include <../lib/block.scad>;

//linear_extrude(height = 20, center = true)
 //import("images/machineblocks-qr-code.svg");

 surface(file = "images/machineblocks-qr-code.png", center = true, invert = true);