# Examples

## Overview

This document provides **concrete reference examples** for the AI and developers.

Examples demonstrate:

- correct pattern usage
- parameter combinations
- design vs structure separation
- printability strategies

---

## Example Structure

Each example follows:

```

Intent → Pattern → Structure → Parameters → Notes

```

---

# 1. Simple Brick

## Intent

Basic LEGO-like block.

---

## Pattern

None (single block)

---

## Structure

```

mb_block only

````

---

## Parameters

```scad
mb_block(
    config = config,
    settings = [
        ["size", [4,2,3]]
    ]
);
````

---

## Notes

* simplest possible valid block
* baseline for all other constructions

---

# 2. Simple Panel

## Intent

Create a wall element.

---

## Pattern

Panel

---

## Structure

```
recess-based
1 wall active
```

---

## Parameters

```scad
mb_block(
    config = config,
    settings = [
        ["size", [4,1,5]],
        ["recess", true],
        ["recessWallThickness", [1,0,0,0]]
    ]
);
```

---

## Notes

* minimal panel configuration
* one wall only

---

# 3. Channel

## Intent

Create a cable path.

---

## Pattern

Channel

---

## Structure

```
recess
2 opposite walls open
```

---

## Parameters

```scad
mb_block(
    config = config,
    settings = [
        ["size", [6,2,4]],
        ["recess", true],
        ["recessWallGaps", [[0,1],[2,1]]]
    ]
);
```

---

## Notes

* uses gaps instead of thickness=0
* ensures clean geometry

---

# 4. Composite Panel (Printable)

## Intent

Create a panel that can be printed without supports.

---

## Pattern

Composite Panel

---

## Structure

```
2 blocks
tongue + groove
```

---

## Parameters (simplified)

```scad
// Part A
mb_block(
    config = config,
    settings = [
        ["recess", true],
        ["tongue", true]
    ]
);

// Part B
mb_block(
    config = config,
    settings = [
        ["recess", true],
        ["baseCutoutType", "groove"]
    ]
);
```

---

## Notes

* both parts printed separately
* assembled after print

---

# 5. Corner Panel

## Intent

Create an L-shaped wall corner.

---

## Pattern

Corner Panel

---

## Structure

```
2 panels combined
underside corrected
```

---

## Key Parameters

```scad
["baseWallGapsX", [[0,1]]],
["baseWallGapsY", [[0,1]]]
```

---

## Notes

* prevents underside collisions
* keeps grid compatibility

---

# 6. Enclosure (Basic)

## Intent

Create a simple device housing.

---

## Pattern

Enclosure

---

## Structure

```
base plate
+ 4 corner panels
+ 4 wall panels
+ lid
```

---

## Example Composition

```scad
// Floor
mb_block(size=[10,10,1]);

// Walls (conceptual)
panel(...)
corner_panel(...)

// Lid
mb_block(size=[10,10,1]);
```

---

## Notes

* standard enclosure layout
* modular and printable

---

# 7. Multi-Part Block (Hidden Split)

## Intent

Create a visually single block that prints in parts.

---

## Pattern

Composite (hidden)

---

## Structure

```
split geometry
tongue + groove
```

---

## Notes

* used for complex geometry
* improves printability
* visually appears as one block

---

# 8. Side Feature Block

## Intent

Add studs on a vertical surface.

---

## Pattern

Layered Block

---

## Structure

```
base block
+ rotated feature block
```

---

## Parameters

```scad
// Base
mb_block(...);

// Side studs
mb_block(
    settings = [
        ["base", false],
        ["studs", true],
        ["rotation", [0,90,0]]
    ]
);
```

---

## Notes

* uses base=false for feature layer
* demonstrates transformation usage

---

# 9. Internal Structure Optimization

## Intent

Reduce print time and material.

---

## Pattern

Composite Optimization

---

## Structure

```
inner blocks → no underside
outer blocks → full structure
```

---

## Parameters

```scad
["baseCutoutType", "none"]
```

---

## Notes

* important for large enclosures
* improves efficiency

---

# 10. Assembly Visualization

## Intent

Show different fabrication states.

---

## Pattern

Assembly

---

## Structure

```
same block
different assembly modes
```

---

## Parameters

```scad
["assembly", "unassembled"]
["assembly", "assembled"]
["assembly", "merged"]
```

---

## Notes

* critical for UI and preview
* separates design from fabrication

---

# Final Notes

## Key Insight

> Examples are the bridge between rules and real usage.

---

## AI Usage

The AI should:

* learn patterns from examples
* reuse structures
* avoid inventing new patterns unnecessarily

---

## Principle

> If a problem matches an example, reuse the example structure.

```