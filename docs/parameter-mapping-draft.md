# MachineBlocks MBOM Type System

## Version 0.1 (Draft)

---

# 1. Purpose

This document defines the canonical MachineBlocks type system.

The goal is to provide a renderer-independent object model that can be used by:

* MBML
* MBOM
* Editors
* Validators
* Compilers
* Renderers
* Future code generators

OpenSCAD is considered a renderer target and not the canonical representation.

---

# 2. Architecture

MachineBlocks uses a layered type system.

```text
Primitive Types
        ↓
Atomic MB Types
        ↓
Generic Container Types
        ↓
Domain Types
        ↓
Feature Systems
        ↓
Renderer Mappings
```

---

# 3. Canonical Model

The canonical representation of all MachineBlocks data is MBOM.

```text
MBML
  ↓
MBOM
  ↓
SCAD
  ↓
Other Renderers
```

Important:

```text
MBOM is the truth.
SCAD is only a serialization format.
```

---

# 4. Primitive Types

```text
Boolean
Integer
Float
String
```

---

# 5. Atomic MB Types

## Axis

```text
x
y
z
```

---

## Face

```text
x-
x+
y-
y+
z-
z+
```

---

## Direction

```text
west
north
east
south
```

Used for block orientation.

---

## AlignValue

```text
start
center
end
```

---

## Color

Supported forms:

```text
#RRGGBB
#RRGGBBAA
[r,g,b]
[r,g,b,a]
```

---

## ColorOrInherit

```text
Color
inherit
```

---

## StudType

```text
solid
hollow
```

---

## HoleType

```text
pin
axle
```

---

## BlockId

Hierarchical object identifier.

Example:

```text
phone
phone/display
phone/display/frame
```

Generated automatically from the block hierarchy.

---

# 6. Unit Types

## FloatMm

Length in millimeters.

---

## FloatMbu

Length in MachineBlocks units.

---

## FloatUnitGrid

Length in grid units.

---

## FloatPt

Text size unit.

---

## FloatDeg

Angle in degrees.

---

## ScaleFactor

Dimensionless scale value.

---

# 7. Generic Container Types

## Vector2<T>

```text
x
y
```

---

## Vector3<T>

```text
x
y
z
```

---

## AxisXY<T>

Canonical:

```text
x
y
```

Author formats:

```text
value
[x,y]
```

---

## AxisXYZ<T>

Canonical:

```text
x
y
z
```

Author formats:

```text
value
[xy,z]
[x,y,z]
```

---

## PerSide4<T>

Faces:

```text
x-
x+
y-
y+
```

Author formats:

```text
value
[x,y]
[x-,x+,y-,y+]
```

---

## FaceVector6<T>

Faces:

```text
x-
x+
y-
y+
z-
z+
```

Canonical only.

---

## FaceMap<T>

Canonical:

```text
face -> value
```

---

## SelectiveGrid<T>

Canonical:

```text
default
overrides[]
```

Example:

```text
default = true

override:
  region = [0,0,1,1]
  value = false
```

---

## AutoOr<T>

```text
auto
T
```

---

## FalseOr<T>

```text
false
T
```

---

## NoneOr<T>

```text
none
T
```

---

# 8. Core Domain Types

## Size3D

```text
x
y
z
```

Integer grid dimensions.

Defines the block's spatial contract.

---

## UnitGridToMbu

Canonical:

```text
x
y
z
```

Author forms:

```text
[xy,z]
[x,y,z]
```

Defines the physical size of a grid unit.

---

## Rotation

```text
x
y
z
```

Degrees.

---

## Offset3D

```text
x
y
z
```

Grid units.

---

## RotationOffset

Rotation pivot.

---

## WallGap

Opening in a wall.

Canonical:

```text
face
position
length
```

---

## WallGapList

List of wall gaps.

Used by:

```text
baseWallGaps
recessWallGaps
```

---

## Bevel

Corner offsets.

Corners:

```text
sw
nw
ne
se
```

---

## Slope

Faces:

```text
x-
x+
y-
y+
```

Positive:

```text
top slope
```

Negative:

```text
bottom slope
```

---

## RoundingRadius

Canonical MBOM representation:

```text
8 corners
×
6 radii per corner
```

Corners:

```text
sw-
nw-
ne-
se-
sw+
nw+
ne+
se+
```

Radii:

```text
xy
xz
yx
yz
zx
zy
```

Author formats may use compact forms.

---

## Cutout

Negative geometry volume.

Supports:

```text
size
offset
sizeMod
crop
bevel
slope
roundingRadius
```

---

## Connector

Canonical:

```text
face
axis
gender
align
```

Gender:

```text
male
female
```

---

## Port

Canonical:

```text
face
axis
align
position
type
```

Renderer-independent semantic interface.

Supported by SCAD renderer.

---

## ScrewHole

Canonical:

```text
face
position
diameter
depth
insetThickness
insetDepth
```

---

## AssemblyMode

```text
unassembled
assembled
merged
```

Renderer-independent assembly intent.

---

## RenderGroupSelection

```text
all
group
[group...]
```

Visible in editor.

---

# 9. Feature Systems

## BodySystem

```text
base
baseColor
```

---

## StudSystem

```text
studs
studType
studShift
studPadding

studDiameter
studHeight
studRounding

studClamp*

studHole*

studBaseOverlap
```

---

## HoleSystem

```text
holeX
holeY
holeZ

holeXYZType
holeXYZShift

holeXYZDiameter

holeXYZInset*

holeXYGrid*

holeXYZAxle*
```

---

## RecessSystem

```text
recess
recessDepth

recessWallThickness
recessWallGaps

recessStuds
recessStudType
recessStudPadding
recessStudShift

recessRoundingRadius

recessAdjustment
```

---

## TongueSystem

```text
tongue

tongueHeight
tongueThickness
tongueOffset

tongueClamp*

tongueGroove*

tongueRoundingRadius
```

---

## PCBSystem

```text
pcb

pcbDimensions

pcbOffset

pcbSocket*
```

Modes:

```text
none
clips
sockets
```

---

## GrilleSystem

```text
grille

grilleDepth
grilleCount

grilleInverted
```

Modes:

```text
none
x
y
```

---

## TextSystem

```text
text

textFace
textOffset

textFont

textSize
textSpacing

textAlign

textDepth

textColor
```

---

## SvgSystem

```text
svg

svgFace
svgOffset

svgDimensions

svgScale

svgDepth

svgColor
```

---

## SurfacePatternSystem

```text
surfacePattern

surfacePatternDimensions

surfacePatternOffset

surfacePatternScale

surfacePatternDepth

surfacePatternColor
```

Important:

```text
surfacePatternDepth <= 0
```

Surface patterns are always engraved.

---

# 10. Geometry Model

Two concepts must be kept separate.

## Spatial Contract

Defined by:

```text
size
direction
align
offset
```

Used by:

```text
editor
snapping
layout
composite placement
```

---

## Physical Geometry

Defined by:

```text
sizeMod
crop
bevel
slope
roundingRadius
```

Important:

```text
sizeMod does not change the spatial contract.
crop does not change the spatial contract.
```

Geometry may extend beyond the size-defined space.

---

# 11. Calibration Model

Calibration values are printer/material specific.

They are not part of the design intent.

Examples:

```text
sizeAdjustment

baseAdjustment

recessAdjustment

studDiameterAdjustment

holeXYZDiameterAdjustment
```

Recommended editor group:

```text
Calibration
```

---

# 12. Editor Groups

Recommended top-level editor groups:

```text
Layout

Geometry

Features

Connections

Surface

Rendering

Calibration

Composite
```

---

# 13. Future Work (v0.2+)

Out of scope for this document:

```text
Pattern Library

Device Chassis Library

Channel Pattern

Battery Holders

Cable Guides

Ventilation Systems

MBML XML Mapping

TypeScript Code Generation

Java Code Generation

Validation Rules

Editor Property Panels
```
