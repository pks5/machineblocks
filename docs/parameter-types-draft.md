# MachineBlocks MBML Typensystem – Arbeitsstand V1

## Ziel

Dieses Dokument beschreibt den aktuellen Stand der MBML-Typisierung basierend auf den existierenden SCAD-Parametern.

Wichtig:

* SCAD-Formate sind historisch gewachsen und nicht maßgeblich.
* MBML ist das Zielmodell.
* MBOM soll später die kanonische, eindeutig typisierte Repräsentation darstellen.
* Dieses Dokument beschreibt primär die Semantik der Typen, nicht die endgültige XML-Syntax.

---

# 1. Primitive Types

## Boolean

Logischer Wahrheitswert.

Werte:

```text
true
false
```

---

## String

Beliebige Zeichenkette.

Beispiele:

```text
"my-block"
"Arial"
"icons/stud.svg"
```

---

## Float

Dezimalzahl.

Beispiele:

```text
0.5
1.6
-0.25
```

---

## Integer

Ganzzahl.

Beispiele:

```text
1
2
10
```

---

## Enum

Wert aus einer festen Wertemenge.

Beispiel:

```text
Direction

west
north
east
south
```

---

## Color

Farbwert.

Erlaubte Formate:

```text
#RRGGBB
#RRGGBBAA
rgba(...)
```

Sonderwert:

```text
inherit
```

---

# 2. Units

Einheiten sind unabhängig vom Datentyp.

Aktuell identifiziert:

```text
none
mm
mbu
grid
degree
```

---

# 3. Common Enums

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

---

## Alignment

```text
start
center
end
```

---

## Axis

```text
x
y
z
```

---

# 4. Position & Dimension Types

## Position2D

```text
[x,y]
```

Einheit abhängig vom Parameter.

---

## Dimensions2D

```text
[width,height]
```

Beispiel:

```text
svgDimensions
```

---

## Dimensions3D

```text
[x,y,z]
```

Beispiel:

```text
pcbDimensions
```

---

## GridPosition3D

Position im MachineBlocks Grid.

```text
[x,y,z]
```

Grid:

```text
x = 5 mbu
y = 5 mbu
z = 2 mbu
```

---

## GridSize3D

Größe im MachineBlocks Grid.

```text
[x,y,z]
```

---

## FaceOffset2D

2D-Offset auf einer Face.

```text
[u,v]
```

Interpretation abhängig von Face.

```text
z-face => xy
x-face => yz
y-face => xz
```

---

# 5. Composite Types

## Alignment3D

Canonical:

```text
[start|center|end,
 start|center|end,
 start|center|end]
```

Shortcuts:

```text
start
center
end

ccs
ece
...
```

---

## Rotation3D

```text
[x,y,z]
```

Einheit:

```text
degree
```

---

## AxisScale3D

Beispiel:

```text
unitGridToMbu
```

Canonical:

```text
[x,y,z]
```

Kurzform:

```text
[xy,z]
```

Normalisierung:

```text
[5,2]
=> [5,5,2]
```

---

# 6. Side-Based Types

## SideDelta3D

Canonical:

```text
{
  x-: value
  x+: value
  y-: value
  y+: value
  z-: value
  z+: value
}
```

Offene Frage:

Alternative Canonical Form:

```text
[[x-,y-,z-],[x+,y+,z+]]
```

Noch nicht entschieden.

---

## Crop3D

Spezialisierung von SideDelta3D.

Einheit:

```text
grid
```

Regel:

```text
nur <= 0
```

---

## SideAdjustment3D

Spezialisierung von SideDelta3D.

Einheit:

```text
mm
```

Positive und negative Werte erlaubt.

---

## SizeMod3D

Spezialisierung von SideDelta3D.

Einheit:

```text
grid
```

Positive und negative Werte erlaubt.

---

## Padding2D

Canonical:

```text
{
  x-: value
  x+: value
  y-: value
  y+: value
}
```

Einheit:

```text
grid
```

Verwendung:

```text
studPadding
surfacePatternPadding
```

---

## Slope2D

Aktuell SCAD:

```text
[x-,x+,y-,y+]
```

Bedeutung:

```text
>0 normale Schräge
<0 Overhang
0 keine Schräge
```

Offene Canonical-Form.

---

# 7. Corner Types

## BevelCorners2D

Canonical:

```text
{
  sw: [x,y]
  nw: [x,y]
  ne: [x,y]
  se: [x,y]
}
```

Regeln:

```text
x >= 0
y >= 0
```

Offsets immer nach innen.

---

## CornerRounding3D

Noch in Ausarbeitung.

Vermutliche Corner IDs:

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

Soll einfache und komplexe Rundungen unterstützen.

Kurzformen geplant:

```text
0.5

{ z+: 0.5 }

{ sw+: 0.5 }
```

---

# 8. Selection Types

## GridArea2D

Canonical:

```text
[
  [x0,y0],
  [x1,y1]
]
```

---

## GridElementSelection<T>

Steuert Elemente auf einem Grid.

Beispiele:

```text
studs
holes
pillars
```

Canonical:

```text
{
  default: value,
  overrides: [
    {
      area: GridArea2D,
      value: value
    }
  ]
}
```

---

# 9. Record Types

## WallGap

```text
{
  face
  start
  length
}
```

---

## WallGapList

Liste von WallGap.

Zusätzliche Kurzformen:

```text
x-
x+
y-
y+

x
y
xy
```

---

## ScrewHole

```text
{
  face
  offset

  diameter?
  depth?

  insetDiameter?
  insetDepth?
}
```

---

## Connector

```text
{
  face
  axis

  gender
  align

  paddingLeft
  paddingRight
}
```

Gender:

```text
male
female
```

---

# 10. PCB Types

## pcbSockets

```text
List<Position2D>
```

Einheit:

```text
mm
```

---

# 11. Port Types

## Port

```text
{
  face
  anchor

  offset
  rotation

  shapes

  depth
}
```

---

## PortShape

Basistyp.

Aktuell:

```text
rect
circle
```

---

### RectPortShape

```text
{
  offset
  rotation

  size
  radius
}
```

---

### CirclePortShape

```text
{
  offset
  rotation

  diameter
}
```

---

# 12. Embedded Types

## CutoutBlock

Reduzierte Blockdefinition.

Erlaubt:

```text
size
offset
rotation
align
crop
bevel
rounding
slope
...
```

Nicht erlaubt:

```text
studs
holes
pillars
tongue
groove
connectors
...
```

Zusätzliche Cutout-Parameter:

```text
cutoutWall
...
```

---

# 13. Assembly

## AssemblyMode

```text
unassembled
assembled
merged
```

---

## AssemblyContext

Canonical:

```text
{
  mode

  outerSize?
  outerDirection?
}
```

Wird primär intern zwischen Composite Blocks propagiert.

---

# 14. Special Values

## null

Kein Wert vorhanden.

Beispiele:

```text
svg
surfacePattern
```

---

## auto

Automatische Ableitung.

Beispiele:

```text
topPlateHelperHeight

baseCutoutRoundingRadius
```

---

## inherit

Wert vom Parent übernehmen.

Beispiele:

```text
textColor
```

---

# 15. Renderer-Specific Parameters

Nicht Teil der eigentlichen Blocksemantik.

Beispiele:

```text
qualityFactor
previewQuality
previewRender
```

Sollen später wahrscheinlich in einen renderer-spezifischen Bereich ausgelagert werden.
