// Let's make fragment number dynamic
// Lower for preview, higher for rendering
$fn = $preview ? 32 : 64;

// Let's create a Sphere with 6mm radius
// Radius is half the diameter
// The diameter is therefore 12mm
sphere(r = 6);