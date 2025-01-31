module mb_roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all", resolution = 20) {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius, $fn = resolution);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true, $fn = resolution);
						}
					}
				}
			}
		}
	}
}

module mb_roundedcube_simple(size = [1, 1, 1], center = false, radius = 0.5, resolution = 20) {
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

module mb_roundedcube_custom(size = [1, 1, 1], center = false, radius = 0.1, resolution = 20) {
	size = (size[0] == undef) ? [size, size, size] : size;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];


	translate(v = obj_translate) {
		if(radius == 0 || radius == [0,0,0,0]){
			cube(size=size);
		}
		else{
			rots=[180,90,0,-90];
			radius = (radius[0] == undef) ? [radius, radius, radius, radius] : radius;
			hull() {
			//union(){
				for (i = [ 0 : 1 : 3 ]){
					cornerRadius = radius[i] == 0 ? 0.1 : radius[i];
					translateX = i < 2 ? cornerRadius : size[0] - cornerRadius;
					translateY = (i == 0) || (i == 3) ? cornerRadius : size[1] - cornerRadius;
				
					//translate_min = cornerRadius;
					//translate_zmax = size[2] - cornerRadius;						

					//for (translate_z = [translate_min, translate_zmax]) {
					translate(v = [translateX, translateY, 0.5 * size[2]]){
							if(radius[i] == 0)
							cube(size = [2*cornerRadius, 2*cornerRadius, size[2]], center = true);
							else
							rotate([0,0,rots[i]])
								translate([0,0,-0.5*size[2]])
									rotate_extrude(angle=90) 
										square([cornerRadius, size[2]]);
							//cylinder(h = size[2], r = cornerRadius, center = true, $fn = resolution);
					}
					//}
				}
			}
		}
	}
}

module mb_rounded_block(size, resolution, center=true, radius = 0){
	if((radius == 0) || (radius == [0, 0, 0]) || (radius == [[0,0,0,0], [0,0,0,0], [0,0,0,0]])){
		cube(size = size, center = center);
	}
	else if((radius[0] == 0 || radius[0] == [0,0,0,0]) && (radius[1] == 0 || radius[1] == [0,0,0,0]) && (radius[2] != 0 && radius[2] != [0,0,0,0])){
		mb_roundedcube_custom(
			size = size, 
			center = center, 
			radius = radius[2], 
			resolution = resolution
		);
	}
	else{
		radius = (radius[0] == undef) ? [radius, radius, radius] : radius;
		size = (size[0] == undef) ? [size, size, size] : size;
		intersection() {
			
			//X-Axis
			rotate([0,90,0])     
				mb_roundedcube_custom(
					size = [size[2], size[1], size[0]], 
					center = center, 
					radius = radius[0], 
					resolution = resolution
				);
			
			//Y-Axis
			rotate([90,0,0]) 
				mb_roundedcube_custom(
					size = [size[0], size[2], size[1]], 
					center = center, 
					radius = radius[1], 
					resolution = resolution
				);
			
			//Z-Axis
			mb_roundedcube_custom(
				size = size, 
				center = center, 
				radius = radius[2], 
				resolution = resolution
			);
		}
	}
}

module mb_torus(circleRadius, torusRadius, circleResolution = 30, torusResolution = 30){
    rotate_extrude(convexity = 10, $fn = torusResolution)
        translate([torusRadius - circleRadius, 0, 0])
            circle(r = circleRadius, $fn = circleResolution);
}