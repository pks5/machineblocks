# Positioning & Transformation Parameters

## Overview

Positioning & Transformation parameters define **how a block is placed, oriented, and transformed** in space.

They are applied **after geometry construction** and affect both:

- the block itself
- all child blocks

---

## Transformation Order (Critical)

The order of operations is:

```

1. Geometry build (size, slope, bevel, crop)
2. Children build
3. direction
4. align
5. rotation (with rotationOffset)
6. offset

```

---

## Fundamental Rule

> Positioning parameters never change geometry — they only transform it.

---

## Parameter Group

- `direction`
- `align`
- `alignChildren`
- `rotation`
- `rotationOffset`
- `rotationOffsetRevert`
- `offset`

---

# direction

## Definition

```

direction = "west" | "north" | "east" | "south"

```

---

## Semantics

Defines the **semantic grid orientation** of a block.

---

## Behavior

- Applied before alignment
- Rotates the block in 90° increments
- Affects interpretation of `size`

Example:

```

size = [4,2,3]
direction = north
→ effective footprint = [2,4,3]

```

---

## Important Rule

> Blocks are always designed in `west` orientation.

---

## Dual Role

- Primary: placement in grid
- Secondary: structural orientation in composite blocks

---

## Constraints

- Grid-safe (90° only)
- Does NOT affect:
  - side numbering
  - corner indexing

---

## Rule

> `direction` is placement-first, design-second.

---

# align

## Definition

```

align = "start" | "center" | "end"
align = ["start","center","end"]
align = "ccs"

```

---

## Semantics

Defines how a block is aligned **within its parent or global space**.

---

## Behavior

- Works per axis (X, Y, Z)
- Applies after `direction`
- Uses bounding box only

---

## Critical Rule

> Alignment is based strictly on the bounding box — not visible geometry.

---

## Ignored Factors

Alignment does NOT consider:

- studs
- slope
- bevel
- crop
- adjustments

---

## Special Note

Future extension may allow visual-based alignment, but currently:

```

align = bounding-box alignment only

```

---

# alignChildren

## Semantics

Defines the **origin inside a parent block** for child positioning.

---

## Behavior

- Default:
```

["start","start","start"]

```
- Can shift origin to:
- center
- end

---

## Example

```

alignChildren = "ccs"
align = "ccs"
→ child is centered in parent

```

---

## Important Rule

> `alignChildren` defines the reference frame — `align` positions within it.

---

# rotation

## Definition

```

rotation = [x, y, z]

```

---

## Semantics

Applies a **free geometric rotation**.

---

## Behavior

- Applied after alignment
- Rotates entire geometry and children

---

## Critical Property

> `rotation` is NOT grid-safe.

---

## Implications

- Can break alignment assumptions
- Can break connectivity
- Must be handled manually

---

## Usage

- Special cases (e.g. brackets)
- non-standard orientations

---

## Rule

> `rotation` is a last-resort transformation.

---

# rotationOffset

## Semantics

Defines the **pivot point for rotation**.

---

## Behavior

- Applied before rotation
- shifts origin for rotation

---

## rotationOffsetRevert

```

rotationOffsetRevert = true | false

```

- if true:
  - offset is reversed after rotation
- if false:
  - offset remains applied

---

## Rule

> `rotationOffset` controls rotation origin, not final placement.

---

# offset

## Definition

```

offset = [x, y, z]

```

---

## Semantics

Defines the **final displacement** of a block.

---

## Behavior

- Applied LAST in the transformation chain
- Acts in global or parent space

---

## Critical Rule

> `offset` positions the final result, not intermediate geometry.

---

## Special Case

If:

```

align = "start"

```

and no parent exists:

- `offset` acts as absolute positioning

---

# Summary

```

direction      → semantic orientation (grid-safe)
align          → bounding-box alignment
alignChildren  → parent origin definition
rotation       → free transform (unsafe)
rotationOffset → rotation pivot
offset         → final position

```

---

## Final Principle

> Positioning parameters transform geometry in a strict order, separating semantic orientation (direction) from physical transformation (rotation and offset).