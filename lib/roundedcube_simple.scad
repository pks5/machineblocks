/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Module for simple rounded cubes
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial 4.0 International
* https://creativecommons.org/licenses/by-nc/4.0/legalcode
*
*/
module roundedcube_simple(size = [1, 1, 1], center = false, radius = 0.5, resolution = 20) {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate = (center == false) ?
		[radius, radius, radius] :
		[
			radius - (size[0] / 2),
			radius - (size[1] / 2),
			radius - (size[2] / 2)
	];

	translate(v = translate)
	minkowski() {
		cube(size = [
			size[0] - (radius * 2),
			size[1] - (radius * 2),
			size[2] - (radius * 2)
		]);
		sphere(r = radius, $fn = resolution);
	}
}