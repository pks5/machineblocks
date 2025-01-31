module
mb_connector_prism(side, height, size)
{
  zRots = [ 315, 135, 45, 225 ];
  rotate([ 90, 90, zRots[side] ])
    translate([ -0.5 * height, -0.5 * size, -0.5 * size ])
      polyhedron(points =
                   [
                     [ 0, 0, 0 ],
                     [ height, 0, 0 ],
                     [ height, size, 0 ],
                     [ 0, size, 0 ],
                     [ 0, size, size ],
                     [ height, size, size ]
                   ],
                 faces = [
                   [ 0, 1, 2, 3 ],
                   [ 5, 4, 3, 2 ],
                   [ 0, 4, 5, 1 ],
                   [ 0, 3, 4 ],
                   [ 5, 2, 1 ]
                 ]);
}

module
mb_connectors(side, grid, baseHeight, height, size, depth, gs, inverse)
{
  sigs = [ -1, 1, -1, 1 ];
  gX = [ 0, 0, 1, 1 ];
  gY = [ 1, 1, 0, 0 ];

rotate(inverse ? [0,0,180]:[0,0,0])
  for (i = [0:1:grid[gY[side]] - 1]) {
    t0X = (0.5 * grid[gX[side]] * gs + (inverse ? -1 : 1) * depth);
    t0Y = (i + 0.5 - 0.5 * grid[gY[side]]) * gs;

    color([ 0.945, 0.769, 0.059 ]) // f1c40f
      translate([

        side < 2 ? (inverse ? -1 : 1) * sigs[side] * t0X : t0Y,
        side < 2 ? t0Y : (inverse ? -1 : 1) * sigs[side] * t0X,
        -0.5 * baseHeight + 0.5 *
        (height + (inverse ? -0.02 : 0))
      ]) mb_connector_prism(side, height+ (inverse ? 0.02 : 0), size);
  }
}

module
mb_connector_grooves(side,
                     grid,
                     baseHeight,
                     height,
                     tolerance,
                     size,
                     depth,
                     gs,
                     inverse)
{
  gX = [ 0, 0, 1, 1 ];
  gY = [ 1, 1, 0, 0 ];
  rot = [ 90, 90, 0, 0 ];
  
  sigs = [ 1, -1, -1, 1 ];
  rotate([ 90, inverse ? 180 : 0, rot[side] ]) for (i =
                                                      [0:1:grid[gY[side]] - 1])
  {
    translate([
      (-(0.5 * grid[gY[side]] - 0.5) * gs + i * gs),
      -0.5 * baseHeight + height,
      sigs[side] * (-0.5 * grid[gX[side]] * gs + 0.5 * depth - 0.02)
    ]) mb_connector_prism(3, depth + 0.02, size);
  }
}