# MachineBlocks — MBOM Type System & SCAD Mapping

version: 3.1.0

> **Render Output / commentary** — not the type or parameter inventory.
> Sole SSOT: `com.machineblocks.bml.type.*` and `NativeBlock.bml`.
> Doc SSOT for strategy: `scad.TypesAndSerialization` (Draft).
> Future builds may regenerate SCAD-facing notes from BML. Change BML first.

## Purpose of this Document

SCAD-facing **serialization commentary** for MBOM values — compact forms, array
shapes, and emit examples. It does **not** define the canonical type system or
parameter inventory.

| Audience | Use this doc for | SSOT for types / params |
|---|---|---|
| Renderer implementors | emit rules & examples | `type/*.bml` · `NativeBlock.bml` |
| Direct SCAD / AI | accepted SCAD shapes | same — open BML for defaults/docs |

> MBOM is canonical. SCAD is a renderer serialization.
> Do not design MBOM around SCAD arrays.

**Naming:** XY / XYZ / AB — see `docs/04_types.md` — Naming convention.

For parameter definitions (names, defaults, constraints) see `NativeBlock.bml` + type BML.
`09_api_parameters.yml` is a pointer stub only (no inventory).
For architecture context see `01_system.md`.

---

## Status

Maturity uses **status Block references** — see `02_mbml.md` / `concept.StatusConvention`. Default `Stable`; declare only when deviating. Bare names are valid at `<status>` / `bml:status` sites. This mirror and `scad.TypesAndSerialization` are **Draft**.

---

# 1–5. Type inventory → BML (SSOT)

Do not maintain enum/struct catalogs in this Markdown file.

```text
domains/machineblocks/mbom/blocks/com/machineblocks/bml/type/*.bml
domains/machineblocks/mbom/blocks/com/machineblocks/bml/core/NativeBlock.bml
docs/04_types.md          — parse/serialize conventions (unions, Map, XY/AB)
```

Sections below keep SCAD serialization rules and mapping examples only.

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

MBOM Face keys are enum member ids; SCAD emit uses Face `scad:value` strings.

```text
MBOM: { XNeg:0.333, XPos:0.333, YNeg:0.333, YPos:0.333 }
SCAD: ["recessWallThickness", 0.333]

MBOM: { XNeg:0.5, XPos:0.5, YNeg:0.25, YPos:0.25 }
SCAD: ["recessWallThickness", [0.5, 0.25]]

MBOM: { XNeg:0.5, XPos:0.4, YNeg:0.25, YPos:0.2 }
SCAD: ["recessWallThickness", [0.5, 0.4, 0.25, 0.2]]
```

## FaceMapXYZ — sizeMod

```text
MBOM: { XNeg:0, XPos:0.5, YNeg:0, YPos:0, ZNeg:0, ZPos:0 }
SCAD: ["sizeMod", [0, 0.5, 0, 0, 0, 0]]
```

## FaceMapXYZ — baseCrop

V2 name was `crop`. Positive = cut geometry, negative = extend. Does not change bounding box.

```text
MBOM: { XNeg:0.5, XPos:0.5, YNeg:0, YPos:0, ZNeg:0, ZPos:0 }
SCAD: ["baseCrop", [0.5, 0.5, 0, 0, 0, 0]]

MBOM: { XNeg:0, XPos:0, YNeg:0, YPos:0, ZNeg:0, ZPos:1 }
SCAD: ["baseCrop", [0, 0, 0, 0, 0, 1]]
```

## FaceMap\<FloatMm\> — baseAdjustment

```text
MBOM: { XNeg: -0.1, XPos: -0.1, ZPos: 0.05 }
SCAD: ["baseAdjustment", [["x-", -0.1], ["x+", -0.1], ["z+", 0.05]]]
```

Namespaced composite forwarding (SCAD keys keep dotted face strings):

```text
MBOM / SCAD bridge: { "pbx.x+": 0.01, "pty.z+": 0.1 }
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

## RecessWallGap[] — recessWallGaps

Type is `RecessWallGap[]` (extends `WallGap` with `padStart` / `padEnd`, default `Auto`).

```text
MBOM:
[
  { face: XPos, pos: 0, len: Auto, padStart: Auto, padEnd: Auto },
  { face: YNeg, pos: 2, len: 3 }
]

SCAD: ["recessWallGaps", [["x+"], ["y-", 2, 3]]]
```

`baseWallGaps` uses plain `WallGap[]` (no pads) — same SCAD tuple shape for face/pos/len.

## ConnectorList — connectors

```text
MBOM:
[
  { face: XPos, axis: Z, gender: Male, align: Center, paddingStart:1, paddingEnd:1 },
  { face: ZPos, axis: X, gender: Female }
]

SCAD: ["connectors", [["x+", "z", "male", "center", 1, 1], ["z+", "x", "female"]]]
```

## ScrewHoleList — screwHoles

```text
MBOM:
[
  { face: ZPos, position:{x:2,y:2} },
  { face: YPos, position:{x:4,y:3}, diameter:2.1, depth:4, insetThickness:0.5, insetDepth:0.6 }
]

SCAD: ["screwHoles", [["z+", [2,2]], ["y+", [4,3], 2.1, 4, 0.5, 0.6]]]
```
