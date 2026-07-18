# MachineBlocks — MBOM Type System & SCAD Mapping

version: 3.0.1

> **Render Output** — Compiler render artifact of MachineBlocks BML (SSOT), not an
> authored source. Primary sources: `com.machineblocks.bml.type.*`,
> `com.machineblocks.bml.documentation.mbml.TypeSystem`, and
> `com.machineblocks.bml.documentation.scad.TypesAndSerialization`. Future builds
> regenerate this Markdown from BML. Do not edit as canonical — change BML first.

## Purpose of this Document

This document defines the canonical MBOM (MachineBlocks Object Model) type system
and the serialization rules for mapping MBOM values to SCAD format.

It serves two audiences:

- **MBOM compiler / SCAD renderer implementors** — defines the exact SCAD
  serialization for every MBOM type
- **Direct SCAD users and AI** — defines the accepted SCAD input formats for
  every parameter type

> MBOM is canonical. SCAD is a renderer serialization.
> Do not design MBOM around SCAD arrays. Design SCAD arrays as serialization of MBOM.

**Naming:** axis-keyed types use **XYZ** / **XY** (not 3D / 2D) — e.g. `SizeXYZ`, `AxisXYZ<T>`, `AxisXY<T>`, `GridPositionXYZ`. See `docs/04_types.md` — Naming convention.

For parameter definitions (names, defaults, constraints) see `09_api_parameters.yml`.
For architecture context see `01_system.md`.

---

## Status

The MBOM type system is defined but not yet fully validated against the SCAD
implementation. Maturity is expressed via **status Block references** — see `02_mbml.md` — § Status.

**Default:** `status:Stable`. Declare status only when deviating (e.g. `<status>Draft</status>` on a parameter whose mapping is incomplete).

```text
status:Stable       — implemented, tested, mapping complete (implicit default)
status:Draft        — defined; mapping incomplete or untested
status:Stub         — placeholder; shape declared, behaviour not yet specified
status:Deprecated   — retained for compatibility; do not use in new work
```

Use `status:Draft` with an explicit note when SCAD implementation and MBOM target diverge.

---

# 1. Primitive Types

```text
Boolean
Integer
Float
String
```

---

# 2. Atomic MB Types

## Axis

```text
"x" | "y" | "z"
```

## Face

```text
"x-" | "x+" | "y-" | "y+" | "z-" | "z+"
```

## Direction

```text
"west" | "north" | "east" | "south"
```

## Align

```text
"start" | "center" | "end"
```

## StudType

```text
"solid" | "hollow"
```

## HoleType

```text
"pin" | "axle"
```

## Color

```text
"#RRGGBB" | "#RRGGBBAA" | [r,g,b] | [r,g,b,a]
```

## ColorOrInherit

```text
Color | "inherit"
```

---

# 3. Unit Types

| Type            | Description                  |
|-----------------|------------------------------|
| `FloatMm`       | Length in millimeters        |
| `FloatMbu`      | Length in MachineBlocks units |
| `FloatUnitGrid` | Length in grid units         |
| `FloatPt`       | Text size unit               |
| `FloatDeg`      | Angle in degrees             |

---

# 4. Generic Container Types

## AutoOr\<T\>

```text
"auto" | T
```

## FalseOr\<T\>

```text
false | T
```

## NoneOr\<T\>

```text
"none" | T
```

## BooleanOr\<T\>

```text
boolean | T
```

---

## AxisXY\<T\>

Canonical MBOM:

```text
{ x: T, y: T }
```

SCAD author forms:

```text
value      → x == y
[x, y]     → x != y
```

---

## AxisXYZ\<T\>

Canonical MBOM:

```text
{ x: T, y: T, z: T }
```

SCAD author forms:

```text
value        → x == y == z
[xy, z]      → x == y, z differs
[x, y, z]    → all differ
```

---

## PerSide4\<T\>

Faces: `x-`, `x+`, `y-`, `y+`

Canonical MBOM:

```text
{ "x-": T, "x+": T, "y-": T, "y+": T }
```

SCAD author forms:

```text
value              → all equal
[x, y]             → x- == x+, y- == y+
[x-, x+, y-, y+]   → all differ
```

---

## FaceVector6\<T\>

Faces: `x-`, `x+`, `y-`, `y+`, `z-`, `z+`

Canonical MBOM:

```text
{ "x-": T, "x+": T, "y-": T, "y+": T, "z-": T, "z+": T }
```

SCAD format — always full 6-element array:

```text
[x-, x+, y-, y+, z-, z+]
```

---

## FaceMap\<T\>

Canonical MBOM:

```text
{ face: T, ... }   (partial — only present faces)
```

SCAD format:

```text
[["x-", value], ["z+", value], ...]
```

Supports namespaced keys for composite block forwarding:

```text
[["pbx.x+", value], ["pty.z+", value]]
```

---

## SelectiveGrid\<T\>

Canonical MBOM (`com.machineblocks.bml.type.SelectiveGrid` — Sub-Block `Selector`):

```text
{
  baseValue: T,
  selectors: [
    { from: {x, y}, to: {x, y}, value: T }
  ]
}
```

`Selector` is a Java-style static nested StructType with its own `T`; the parent forwards via
`selectors: Selector(T)[]`. `from` / `to` are `AxisXY(Integer(GridUnitXY))`.

SCAD format:

```text
[baseValue, [[x0, y0, x1, y1], value], ...]
```

If no selectors:

```text
baseValue only (scalar or boolean)
```

---

# 5. Compound Domain Types

## SizeXYZ

```text
MBOM: { x: Integer, y: Integer, z: Integer }
SCAD: [x, y, z]
```

Integer grid dimensions. Defines the block's spatial contract.

---

## UnitGridToMbu

```text
MBOM: { x: FloatMbu, y: FloatMbu, z: FloatMbu }
```

SCAD author forms:

```text
[xy, z]      → x == y
[x, y, z]    → all differ
```

---

## WallGap

```text
MBOM: { face: Face, position: Integer, length: Integer | "full" }

SCAD: ["face"]                     → position 0, full length
      ["face", position, length]   → explicit position and length
```

## WallGapList

List of WallGap entries.

SCAD:

```text
[["x+"], ["y-", 2, 3]]
```

Shorthand — single gap, full length:

```text
"x+"   →   [["x+"]]
```

---

## Connector

```text
MBOM: { face, axis, gender, align, paddingStart, paddingEnd }

SCAD: ["face", "axis", "gender"]                           → defaults for align/padding
      ["face", "axis", "gender", "align", start, end]      → full form
```

Gender: `"male"` | `"female"`

---

## ScrewHole

```text
MBOM: { face, position: {x,y}, diameter, depth, insetThickness, insetDepth }

SCAD: ["face", [x, y]]                                              → defaults
      ["face", [x, y], diameter, depth, insetThickness, insetDepth] → full form
```

---

## RoundingRadius

> **Status: `status:Draft`**
> The MBOM canonical form and V3 SCAD input modes are defined below. The current
> SCAD implementation reflects V2 behavior (Modus 1 only, no ellipse support per
> corner, no per-corner 6-radius support). Modus 2 and Modus 3 are defined here
> as the V3 SCAD target but are not yet implemented. The MBOM compiler mapping is
> pending finalization of the V3 SCAD implementation.
>
> V2 behavior (Modus 1 scalar and per-axis array) remains valid and is the current
> implementation.

### MBOM Canonical Form

8 corners × 6 radii per corner.

Corners:

```text
sw-  nw-  ne-  se-   (lower Z plane)
sw+  nw+  ne+  se+   (upper Z plane)
```

Radii per corner (block-agnostic, axis-pair notation):

```text
xy  — edge between X and Y axes
xz  — edge between X and Z axes
yx  — edge between Y and X axes  (same Z-face as xy, orthogonal direction)
yz  — edge between Y and Z axes
zx  — edge between Z and X axes
zy  — edge between Z and Y axes
```

The corner implementation is block-agnostic. It has no knowledge of block
orientation. The axis-pair names describe the edge between two axis directions
from the corner's own perspective.

Orientation helper — which radii are visible from which block viewpoint:

```text
View from Z+ (top-down)    →  corner.xy  (radius in X direction)
                               corner.yx  (radius in Y direction)
                               together they define the ellipse visible from above:
                               xy == yx → circle;  xy != yx → ellipse

View from X- (left side)   →  corner.yz  and  corner.zy
View from Y- (front)       →  corner.xz  and  corner.zx
```

### SCAD Input Modes

Three input modes are supported. The SCAD compiler normalizes all modes to the
MBOM canonical form.

---

#### Modus 1 — Block-Axis (simple, V2-compatible)

The most common and convenient input mode. Radii are specified per block axis.
This is the recommended starting point — escalate to Modus 2 or 3 only when
finer control is needed.

```text
scalar        → all 48 radii equal
[x, y, z]     → per block axis; all 4 corners of that axis equal
```

Each axis value can be:

```text
scalar              → circle radius, all 4 corners equal
                      for Z: corner.xy = corner.yx = scalar
[sw, nw, ne, se]    → circle radius per corner
                      for Z: corner.xy = corner.yx = per-corner scalar
[[r1,r2], ...]      → ellipse radius per corner: r1 → corner.xy, r2 → corner.yx
                      (ellipse only meaningful for Z axis — X and Y use single
                      radius per corner in this mode)
```

Corner viewing convention for Modus 1:

```text
x-axis: view from X- (from left)
y-axis: view from Y- (from front)
z-axis: view from Z+ (from above)  ← exception: Z- is the floor;
                                       viewing from below would be unintuitive
```

This convention is V2-compatible and intentional. The Z exception is explicitly
by design — not an error.

Common usage examples:

```text
4                           → all radii = 4 (circle, same on all faces)
[0, 0, 4]                   → Z radii = 4 (circle), X and Y = 0
                              most common case: rounded block seen from top
[0, 0, [1, 2, 3, 4]]        → Z radii: sw=1, nw=2, ne=3, se=4 (circles)
[0, 0, [[1,2], 0, 0, 0]]    → Z sw = ellipse (xy=1, yx=2), rest = 0
```

---

#### Modus 2 — Block-Axis as Map (explicit)

```text
[["x", [...]], ["y", [...]], ["z", [...]]]
```

Each value follows the same rules as Modus 1. Use when only specific axes need
to be set and the array-position syntax of Modus 1 would be ambiguous.

Example:

```text
[["z", [1, 2, 3, 4]]]   → Z radii per corner, X and Y = 0
```

---

#### Modus 3 — Per-Corner Direct (MBOM 1:1)

```text
[["sw-", [["xy", 1], ["xz", 2], ...]], ["ne+", [...]]]
```

Corner names: `sw-`, `nw-`, `ne-`, `se-`, `sw+`, `nw+`, `ne+`, `se+`

Viewing convention: always from above — `+` = upper Z plane, `-` = lower Z plane.

Per corner: map of up to 6 radii using axis-pair keys `xy`, `xz`, `yx`, `yz`,
`zx`, `zy`. Omitted radii default to 0.

This mode is the direct SCAD serialization of the MBOM canonical form and
provides full control over every individual radius.

Example:

```text
[["sw-", [["xy", 1], ["xz", 0.5]]], ["sw+", [["xy", 1], ["xz", 0.5]]]]
```

---

### auto Derivation (tongueRoundingRadius)

```text
auto → derived from baseRoundingRadius
       source radii: corner.xy and corner.yx of the relevant corners
                     (= the two radii of the Z-face ellipse seen from above)
       formula: innerRadius.xy = outerRadius.xy - offset
                innerRadius.yx = outerRadius.yx - offset
                offset = tongue padding
                both clamped to 0 if result is negative
```

The `xy` and `yx` radii are used because the tongue sits on the Z-face of the
block, offset inward. The inner radius must be smaller than the outer radius by
exactly the offset amount to produce a constant-width border — the same
principle as a rounded rect with a concentric inner rounded rect.

---

# 6. MBOM-to-SCAD Serialization Rules

## General Strategy

```text
1. Read MBOM canonical value
2. Validate type
3. Normalize to renderer-neutral form
4. Choose shortest valid SCAD representation
5. Emit SCAD settings array entry: ["paramName", value]
```

## AxisXYZ Serialization

```text
if x == y == z   →  emit scalar value
if x == y        →  emit [xy, z]
else             →  emit [x, y, z]
```

## AxisXY Serialization

```text
if x == y   →  emit scalar value
else        →  emit [x, y]
```

## PerSide4 Serialization

```text
if all equal            →  emit scalar value
if x- == x+, y- == y+  →  emit [x, y]
else                    →  emit [x-, x+, y-, y+]
```

## FaceVector6 Serialization

Always emit full 6-element array:

```text
[x-, x+, y-, y+, z-, z+]
```

## SelectiveGrid Serialization

```text
[baseValue, [[x0,y0,x1,y1], value], ...]
```

If no selectors:

```text
baseValue only (scalar or boolean)
```

---

# 7. Mapping Examples

## SizeXYZ

```text
MBOM: { x:4, y:2, z:3 }
SCAD: ["size", [4, 2, 3]]
```

## AxisXYZ\<FloatMbu\> — holeXYZDiameter

```text
MBOM: { x:"auto", y:"auto", z:"auto" }
SCAD: ["holeXYZDiameter", "auto"]

MBOM: { x:3, y:3, z:4 }
SCAD: ["holeXYZDiameter", [3, 4]]

MBOM: { x:3, y:3.2, z:4 }
SCAD: ["holeXYZDiameter", [3, 3.2, 4]]
```

## AxisXY\<FloatMbu\> — holeXYGridOffsetZ

```text
MBOM: { x:3.625, y:3.625 }
SCAD: ["holeXYGridOffsetZ", 3.625]

MBOM: { x:3.5, y:4 }
SCAD: ["holeXYGridOffsetZ", [3.5, 4]]
```

## PerSide4\<FloatUnitGrid\> — recessWallThickness

```text
MBOM: { "x-":0.333, "x+":0.333, "y-":0.333, "y+":0.333 }
SCAD: ["recessWallThickness", 0.333]

MBOM: { "x-":0.5, "x+":0.5, "y-":0.25, "y+":0.25 }
SCAD: ["recessWallThickness", [0.5, 0.25]]

MBOM: { "x-":0.5, "x+":0.4, "y-":0.25, "y+":0.2 }
SCAD: ["recessWallThickness", [0.5, 0.4, 0.25, 0.2]]
```

## FaceVector6\<FloatUnitGrid\> — sizeMod

```text
MBOM: { "x-":0, "x+":0.5, "y-":0, "y+":0, "z-":0, "z+":0 }
SCAD: ["sizeMod", [0, 0.5, 0, 0, 0, 0]]
```

## FaceVector6 — crop

```text
MBOM: { "x-":0, "x+":-0.5, "y-":0, "y+":0, "z-":0, "z+":-1 }
SCAD: ["crop", [0, -0.5, 0, 0, 0, -1]]
```

Rule: crop values must be `<= 0`.

## FaceMap\<FloatMm\> — baseAdjustment

```text
MBOM: { "x-": -0.1, "x+": -0.1, "z+": 0.05 }
SCAD: ["baseAdjustment", [["x-", -0.1], ["x+", -0.1], ["z+", 0.05]]]
```

Namespaced composite forwarding:

```text
MBOM: { "pbx.x+": 0.01, "pty.z+": 0.1 }
SCAD: ["baseAdjustment", [["pbx.x+", 0.01], ["pty.z+", 0.1]]]
```

## SelectiveGrid\<Boolean | StudType\> — studs

```text
MBOM:
{
  baseValue: true,
  selectors: [
    { from:{x:0,y:0}, to:{x:1,y:1}, value: false },
    { from:{x:2,y:0}, to:{x:3,y:1}, value: "hollow" }
  ]
}

SCAD: ["studs", [true, [[0,0,1,1], false], [[2,0,3,1], "hollow"]]]
```

## WallGapList — recessWallGaps

```text
MBOM:
[
  { face:"x+", position:0, length:"full" },
  { face:"y-", position:2, length:3 }
]

SCAD: ["recessWallGaps", [["x+"], ["y-", 2, 3]]]
```

## ConnectorList — connectors

```text
MBOM:
[
  { face:"x+", axis:"z", gender:"male", align:"center", paddingStart:1, paddingEnd:1 },
  { face:"z+", axis:"x", gender:"female" }
]

SCAD: ["connectors", [["x+", "z", "male", "center", 1, 1], ["z+", "x", "female"]]]
```

## ScrewHoleList — screwHoles

```text
MBOM:
[
  { face:"z+", position:{x:2,y:2} },
  { face:"y+", position:{x:4,y:3}, diameter:2.1, depth:4, insetThickness:0.5, insetDepth:0.6 }
]

SCAD: ["screwHoles", [["z+", [2,2]], ["y+", [4,3], 2.1, 4, 0.5, 0.6]]]
```
