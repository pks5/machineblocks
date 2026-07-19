# MachineBlocks — MBOM Type System & SCAD Mapping

version: 3.1.0

> **Render Output / commentary** — not the type or parameter inventory.
> Sole SSOT: `com.machineblocks.bml.type.*` and `NativeBlock.bml`.
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

Maturity uses **status Block references** — see `02_mbml.md` — § Status. Default `status:Stable`; declare only when deviating.

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
