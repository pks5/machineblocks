# MachineBlocks MBOM Type System

## Generic Type Representation & SCAD Mapping

### Version 0.1 Draft

---

# 1. Purpose

This document explains how MachineBlocks MBOM types can be represented in TypeScript or Java using generic type syntax, and how these canonical MBOM values are serialized to the SCAD renderer target.

Core rule:

```text
MBOM is canonical.
SCAD is a renderer serialization.
```

---

# 2. Generic Type Principle

Many MachineBlocks types are generic containers.

Examples:

```text
Vector3<FloatUnitGrid>
AxisXYZ<FloatMbu>
PerSide4<FloatUnitGrid>
SelectiveGrid<BooleanOr<StudType>>
FaceMap<AdjustmentMm>
AutoOr<FloatMbu>
```

This allows the type system to express both:

```text
structure
```

and:

```text
unit / value semantics
```

Example:

```text
AxisXYZ<FloatMbu>
```

means:

```text
A value distributed over x/y/z axes, where each value is a length in mbu.
```

---

# 3. TypeScript Representation

## Primitive / Atomic Types

```ts
type BooleanValue = boolean;
type Integer = number;
type Float = number;
type StringValue = string;

type FloatMm = number;
type FloatMbu = number;
type FloatUnitGrid = number;
type FloatPt = number;
type FloatDeg = number;

type Axis = "x" | "y" | "z";

type Face =
  | "x-"
  | "x+"
  | "y-"
  | "y+"
  | "z-"
  | "z+";

type Direction =
  | "west"
  | "north"
  | "east"
  | "south";

type AlignValue =
  | "start"
  | "center"
  | "end";

type Color = string | [number, number, number] | [number, number, number, number];
type ColorOrInherit = Color | "inherit";

type StudType = "solid" | "hollow";
type HoleType = "pin" | "axle";

type BlockId = string;
type FilePath = string;
type FontFamily = string;
```

---

## Generic Containers

```ts
type Vector2<T> = {
  x: T;
  y: T;
};

type Vector3<T> = {
  x: T;
  y: T;
  z: T;
};

type AxisXY<T> = {
  x: T;
  y: T;
};

type AxisXYZ<T> = {
  x: T;
  y: T;
  z: T;
};

type PerSide4<T> = {
  "x-": T;
  "x+": T;
  "y-": T;
  "y+": T;
};

type FaceVector6<T> = {
  "x-": T;
  "x+": T;
  "y-": T;
  "y+": T;
  "z-": T;
  "z+": T;
};

type FaceMap<T> = Partial<Record<Face, T>>;

type AutoOr<T> = "auto" | T;
type FalseOr<T> = false | T;
type NoneOr<T> = "none" | T;
type BooleanOr<T> = boolean | T;
```

---

## SelectiveGrid

```ts
type GridRegion = {
  from: Vector2<Integer>;
  to: Vector2<Integer>;
};

type GridOverride<T> = {
  region: GridRegion;
  value: T;
};

type SelectiveGrid<T> = {
  default: T;
  overrides?: Array<GridOverride<T>>;
};
```

Example:

```ts
type StudSelection = SelectiveGrid<BooleanOr<StudType>>;
type HoleSelection = SelectiveGrid<BooleanOr<HoleType>>;
```

---

# 4. Java Representation

Java would typically use records, enums and generics.

## Atomic Types

```java
enum Axis {
    X, Y, Z
}

enum Face {
    X_MINUS,
    X_PLUS,
    Y_MINUS,
    Y_PLUS,
    Z_MINUS,
    Z_PLUS
}

enum Direction {
    WEST,
    NORTH,
    EAST,
    SOUTH
}

enum AlignValue {
    START,
    CENTER,
    END
}

enum StudType {
    SOLID,
    HOLLOW
}

enum HoleType {
    PIN,
    AXLE
}
```

Unit-specific float types may be modeled as value objects:

```java
record FloatMm(double value) {}
record FloatMbu(double value) {}
record FloatUnitGrid(double value) {}
record FloatPt(double value) {}
record FloatDeg(double value) {}
```

---

## Generic Containers

```java
record Vector2<T>(T x, T y) {}

record Vector3<T>(T x, T y, T z) {}

record AxisXY<T>(T x, T y) {}

record AxisXYZ<T>(T x, T y, T z) {}

record PerSide4<T>(
    T xMinus,
    T xPlus,
    T yMinus,
    T yPlus
) {}

record FaceVector6<T>(
    T xMinus,
    T xPlus,
    T yMinus,
    T yPlus,
    T zMinus,
    T zPlus
) {}
```

---

## SelectiveGrid

```java
record GridRegion(
    Vector2<Integer> from,
    Vector2<Integer> to
) {}

record GridOverride<T>(
    GridRegion region,
    T value
) {}

record SelectiveGrid<T>(
    T defaultValue,
    List<GridOverride<T>> overrides
) {}
```

Example:

```java
SelectiveGrid<BooleanOr<StudType>> studs;
SelectiveGrid<BooleanOr<HoleType>> holeX;
```

In Java, `BooleanOr<T>` would usually be modeled as a sealed interface:

```java
sealed interface BooleanOr<T> {}

record BoolValue<T>(boolean value) implements BooleanOr<T> {}
record TypedValue<T>(T value) implements BooleanOr<T> {}
```

---

# 5. SCAD Mapping Principle

SCAD output is generated from canonical MBOM values.

The SCAD format may be shorter, more compact, or legacy-compatible.

Example:

```text
MBOM:
AxisXYZ<FloatMbu> = { x: 5, y: 5, z: 3 }

SCAD:
[5, 3]
```

Because `[xy,z]` is a valid short form.

---

# 6. Mapping Examples

## 6.1 Size3D

MBOM:

```json
{
  "size": {
    "x": 4,
    "y": 2,
    "z": 3
  }
}
```

SCAD:

```scad
["size", [4, 2, 3]]
```

---

## 6.2 UnitGridToMbu

MBOM canonical:

```json
{
  "unitGridToMbu": {
    "x": 5,
    "y": 5,
    "z": 2
  }
}
```

SCAD compact form:

```scad
["unitGridToMbu", [5, 2]]
```

If X and Y differ:

```json
{
  "unitGridToMbu": {
    "x": 5,
    "y": 6,
    "z": 2
  }
}
```

SCAD:

```scad
["unitGridToMbu", [5, 6, 2]]
```

---

## 6.3 AxisXYZ<FloatMbu>

Example: `holeXYZDiameter`

MBOM:

```json
{
  "holeXYZDiameter": {
    "x": "auto",
    "y": "auto",
    "z": "auto"
  }
}
```

SCAD:

```scad
["holeXYZDiameter", "auto"]
```

MBOM:

```json
{
  "holeXYZDiameter": {
    "x": 3,
    "y": 3,
    "z": 4
  }
}
```

SCAD:

```scad
["holeXYZDiameter", [3, 4]]
```

MBOM:

```json
{
  "holeXYZDiameter": {
    "x": 3,
    "y": 3.2,
    "z": 4
  }
}
```

SCAD:

```scad
["holeXYZDiameter", [3, 3.2, 4]]
```

---

## 6.4 AxisXY<FloatMbu>

Example: `holeXYGridOffsetZ`

MBOM:

```json
{
  "holeXYGridOffsetZ": {
    "x": 3.625,
    "y": 3.625
  }
}
```

SCAD:

```scad
["holeXYGridOffsetZ", 3.625]
```

MBOM:

```json
{
  "holeXYGridOffsetZ": {
    "x": 3.5,
    "y": 4
  }
}
```

SCAD:

```scad
["holeXYGridOffsetZ", [3.5, 4]]
```

---

## 6.5 PerSide4<FloatUnitGrid>

Example: `recessWallThickness`

MBOM:

```json
{
  "recessWallThickness": {
    "x-": 0.333,
    "x+": 0.333,
    "y-": 0.333,
    "y+": 0.333
  }
}
```

SCAD:

```scad
["recessWallThickness", 0.333]
```

MBOM:

```json
{
  "recessWallThickness": {
    "x-": 0.5,
    "x+": 0.5,
    "y-": 0.25,
    "y+": 0.25
  }
}
```

SCAD:

```scad
["recessWallThickness", [0.5, 0.25]]
```

MBOM:

```json
{
  "recessWallThickness": {
    "x-": 0.5,
    "x+": 0.4,
    "y-": 0.25,
    "y+": 0.2
  }
}
```

SCAD:

```scad
["recessWallThickness", [0.5, 0.4, 0.25, 0.2]]
```

---

## 6.6 FaceVector6<FloatUnitGrid>

Example: `sizeMod`

MBOM:

```json
{
  "sizeMod": {
    "x-": 0,
    "x+": 0.5,
    "y-": 0,
    "y+": 0,
    "z-": 0,
    "z+": 0
  }
}
```

SCAD:

```scad
["sizeMod", [0, 0.5, 0, 0, 0, 0]]
```

---

## 6.7 Crop

Crop uses a negative FaceVector6.

MBOM:

```json
{
  "crop": {
    "x-": 0,
    "x+": -0.5,
    "y-": 0,
    "y+": 0,
    "z-": 0,
    "z+": -1
  }
}
```

SCAD:

```scad
["crop", [0, -0.5, 0, 0, 0, -1]]
```

Rule:

```text
crop values must be <= 0
```

---

## 6.8 SelectiveGrid<BooleanOr<StudType>>

MBOM:

```json
{
  "studs": {
    "default": true,
    "overrides": [
      {
        "region": {
          "from": { "x": 0, "y": 0 },
          "to": { "x": 1, "y": 1 }
        },
        "value": false
      },
      {
        "region": {
          "from": { "x": 2, "y": 0 },
          "to": { "x": 3, "y": 1 }
        },
        "value": "hollow"
      }
    ]
  }
}
```

SCAD:

```scad
["studs", [
    true,
    [[0, 0, 1, 1], false],
    [[2, 0, 3, 1], "hollow"]
]]
```

---

## 6.9 WallGapList

MBOM:

```json
{
  "recessWallGaps": [
    {
      "face": "x+",
      "position": 0,
      "length": "full"
    },
    {
      "face": "y-",
      "position": 2,
      "length": 3
    }
  ]
}
```

SCAD:

```scad
["recessWallGaps", [
    ["x+"],
    ["y-", 2, 3]
]]
```

---

## 6.10 FaceMap<AdjustmentMm>

Example: `baseAdjustment`

MBOM:

```json
{
  "baseAdjustment": {
    "x-": -0.1,
    "x+": -0.1,
    "z+": 0.05
  }
}
```

SCAD:

```scad
["baseAdjustment", [
    ["x-", -0.1],
    ["x+", -0.1],
    ["z+", 0.05]
]]
```

Namespaced composite forwarding:

MBOM:

```json
{
  "baseAdjustment": {
    "pbx.x+": 0.01,
    "pty.z+": 0.1
  }
}
```

SCAD:

```scad
["baseAdjustment", [
    ["pbx.x+", 0.01],
    ["pty.z+", 0.1]
]]
```

---

## 6.11 ConnectorList

MBOM:

```json
{
  "connectors": [
    {
      "face": "x+",
      "axis": "z",
      "gender": "male",
      "align": "center",
      "paddingStart": 1,
      "paddingEnd": 1
    },
    {
      "face": "z+",
      "axis": "x",
      "gender": "female"
    }
  ]
}
```

SCAD:

```scad
["connectors", [
    ["x+", "z", "male", "center", 1, 1],
    ["z+", "x", "female"]
]]
```

---

## 6.12 ScrewHoleList

MBOM:

```json
{
  "screwHoles": [
    {
      "face": "z+",
      "position": { "x": 2, "y": 2 }
    },
    {
      "face": "y+",
      "position": { "x": 4, "y": 3 },
      "diameter": 2.1,
      "depth": 4,
      "insetThickness": 0.5,
      "insetDepth": 0.6
    }
  ]
}
```

SCAD:

```scad
["screwHoles", [
    ["z+", [2, 2]],
    ["y+", [4, 3], 2.1, 4, 0.5, 0.6]
]]
```

---

## 6.13 RoundingRadius

MBOM canonical structure:

```json
{
  "baseRoundingRadius": {
    "sw-": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 },
    "nw-": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 },
    "ne-": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 },
    "se-": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 },
    "sw+": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 },
    "nw+": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 },
    "ne+": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 },
    "se+": { "xy": 0, "xz": 0, "yx": 0, "yz": 0, "zx": 0, "zy": 0 }
  }
}
```

SCAD may use compact author forms where possible.

Example:

```scad
["baseRoundingRadius", 0.5]
```

or expanded SCAD target form, depending on renderer capability.

The compiler must normalize author forms to the canonical MBOM corner/radius structure before renderer serialization.

---

## 6.14 AssemblyMode

MBOM:

```json
{
  "assembly": "unassembled"
}
```

SCAD:

```scad
["assembly", "unassembled"]
```

When SCAD requires context propagation inside composite blocks, the SCAD renderer may emit:

```scad
["assembly", ["unassembled", [16, 16, 9], "north"]]
```

This extended form is renderer-context-only.

It is not the canonical MBOM representation.

---

# 7. Mapping Strategy

The SCAD compiler should follow this process:

```text
1. Read MBOM canonical value
2. Validate type
3. Normalize to renderer-neutral form
4. Choose shortest valid SCAD representation
5. Emit SCAD settings array
```

Example:

```text
AxisXYZ<T>
```

If:

```text
x == y == z
```

emit:

```scad
value
```

If:

```text
x == y && z differs
```

emit:

```scad
[xy,z]
```

Otherwise emit:

```scad
[x,y,z]
```

---

# 8. Important Rule

SCAD compact forms must never influence the canonical type system.

```text
Do not design MBOM around SCAD arrays.
Design SCAD arrays as serialization of MBOM.
```
