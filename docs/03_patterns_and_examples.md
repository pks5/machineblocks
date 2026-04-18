# MachineBlocks — Patterns and Examples

version: 2.0.0

## Purpose of this Document

This document defines the Block File structure, customizer conventions, config handling, and Block Module patterns. Each pattern is accompanied by concrete, production-ready examples.

> For all parameter definitions see `09_api_parameters_1_0_1.yml`.
> For terminology (Block Module, Block File) see `01_system.md`.

---

# Block File Structure

Every Block File follows a mandatory structure. The sections must appear in this order and each section must be marked with a `/* Section Name */` comment.

```scad
/**
 * Mandatory Header
 */

/* Imports */

/* Customization */

/* Main Module Call */

/* Main Module Definition */

/* Optional Sub Modules */

/* Optional Helper Modules */

/* Optional Global Functions */
```

## Mandatory Header

The header comment is mandatory. The first line inside the header must be exactly `MachineBlocks.com Block File`. The following fields are required: `Name:`, `Filename:`, `Package:`. Copyright, license, and visit lines are optional.

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: My Block
 * Filename: mb_block__my__package__my_block.scad
 * Package: my.package.my_block
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Visit machineblocks.com for more information.
 */
```

## Complete Block File Template

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: My Block
 * Filename: mb_block__my__package__my_block.scad
 * Package: my.package.my_block
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Visit machineblocks.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */

/* [Geometry] */

// Brick size (grid)
size = [4, 2, 3]; // [1:0.25:32]

// Direction
direction = "west"; // [west, north, east, south]

/* [Appearance] */

// Color
baseColor = "#EAC645";

/* [Hidden] */

// (computed values go here)

/*
 * Main Module Call
 */
mb_block__my__package__my_block(
    config = mb_config,
    settings = [
        ["size", size],
        ["direction", direction],
        ["baseColor", baseColor]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__my__package__my_block(config = undef, settings = undef){
    mb_block(
        config = config,
        settings = settings
    );
}
```

---

# Imports

Every Block File must have two imports.

**Library import** using `use` (loads only module definitions):

```scad
use <../../../../machineblocks/lib/block.scad>;
```

**Config import** using `include` (executes the file, making `mb_config` available):

```scad
include <../../../config/mb_config.scad>;
```

Paths are relative to the block file's location. The path depth depends on how many package segments the block has. The AI calculates paths based on the assumption that `machineblocks/` is a sibling library. See `01_system.md` for the library structure and path rules.

The Online Editor converts paths on upload:

```text
use <../../../../machineblocks/lib/block.scad>  →  use <machineblocks/lib/block.scad>
include <../../../config/mb_config.scad>        →  include </mb_config.scad>
```

---

# Config Handling

## File Level

The Block File includes `mb_config.scad` which provides the `mb_config` variable. This variable is passed to the Main Module Call:

```scad
mb_block__my__package__my_block(
    config = mb_config,
    settings = [...]
);
```

## Module Level

Inside the module definition, the `config` parameter (not `mb_config`) is passed to all `mb_block()` calls and all `mb_block__*()` sub-module calls:

```scad
module mb_block__my__package__my_block(config = undef, settings = undef){
    mb_block(
        config = config,  // always the config parameter, never mb_config
        settings = [...]
    );
}
```

> `mb_config` exists only at file level. Inside modules, always use the `config` parameter.

---

# OpenSCAD Customizer Syntax

The customizer section defines variables that appear in the OpenSCAD Customizer UI.

## Customizer Slider Defaults

When no explicit range is specified for a parameter, the following defaults apply:

| Unit      | Step   | Min | Max       |
|-----------|--------|-----|-----------|
| unitGrid  | 0.25   | 0   | 32 (size: min 1) |
| mbu (XY)  | 0.125  | 0   | 160       |
| mbu (Z)   | 0.125  | 0   | 64        |

These defaults can be overridden per parameter. Always use the range comment syntax:

```scad
// Brick size (grid)
size = [4, 2, 3]; // [1:0.25:32]

// Relief Cut Thickness (mbu)
baseReliefCutThickness = 0.375; // [0:0.125:160]

// HoleY Grid Offset Z (mbu)
holeYGridOffsetZ = 3.5; // [0:0.125:64]
```

## Tabs

```scad
/* [Geometry] */
size = [4, 2, 3]; // [1:0.25:32]

/* [Appearance] */
baseColor = "#ff0000";
```

`/* [Hidden] */` hides all variables below it. Use for computed values.

## Input Types

**String:**
```scad
myText = "Hello";
```

**Number with range (slider):**
```scad
speed = 50; // [0:1:160]
```

**Boolean (checkbox):**
```scad
studs = true;
```

**Enum (combobox):**
```scad
direction = "west"; // [west, north, east, south]
```

**Enum with labels:**
```scad
assembly = "unassembled"; // [unassembled:Unassembled, assembled:Assembled, merged:Merged]
```

**Array with range:**
```scad
size = [4, 2, 3]; // [1:0.25:32]
```

## Important Rules

Only direct value assignments appear in the customizer. Computed values must be placed under `/* [Hidden] */`.

```scad
a = 5;     // shown in customizer
b = a;     // NOT shown in customizer
c = a + 1; // NOT shown in customizer
```

---

# Parameter Access Rules

All block modules must follow these rules for reading parameters:

**Native parameters** (parameters used by `mb_block()`) — use the dedicated getter:
```scad
size = mb_param_size(config, settings);
direction = mb_param_direction(config, settings);
baseColor = mb_param_baseColor(config, settings);
```

An optional default can be passed as the third argument:
```scad
size = mb_param_size(config, settings, [4, 2, 3]);
```

**Custom parameters** (module-specific parameters) — use the generic getter:
```scad
myParam = mb_param(config, settings, "myParam", "myDefaultValue");
cornerRounding = mb_param(config, settings, "cornerRounding", 0.5);
```

> Never access the settings or config arrays directly. Always use the getter functions.

---

# Block Module Patterns

Block Modules follow three patterns based on their internal complexity.

## Pattern 1 — Primitive Wrapper

A pass-through wrapper around `mb_block()`. No own logic, no parameter mapping — `config` and `settings` are forwarded directly.

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: My Primitive Wrapper
 * Filename: mb_block__mm__examples__primitive_wrapper.scad
 * Package: mm.examples.primitive_wrapper
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Visit machineblocks.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */

// Bounding Box
size = [3, 1, 1]; // [1:0.25:32]

// Color
baseColor = "#ff0000";

// Direction
direction = "west"; // [west, north, east, south]

// Studs
studs = true;

/*
 * Main Module Call
 */
mb_block__mm__examples__primitive_wrapper(
    config = mb_config,
    settings = [
        ["size", size],
        ["baseColor", baseColor],
        ["direction", direction],
        ["studs", studs]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mm__examples__primitive_wrapper(config = undef, settings = undef){
    mb_block(
        config = config,
        settings = settings
    );
}

/*
 * Optional Sub Modules (not used in this example)
 * Sub modules are independent mb_block modules with the same (config, settings) signature.
 * Sub module names must NOT use 'func' or 'help'.
 * Package: mm.examples.primitive_wrapper.sub_module
 */

/*
 * Optional Helper Modules (not used in this example)
 * Helper modules may have any signature.
 * Package: mm.examples.primitive_wrapper.help.helper_name
 */

/*
 * Optional Global Functions (not used in this example)
 * Package: mm.examples.primitive_wrapper.func.func_name
 */
```

## Pattern 2 — Simple Block

Own customizer variables, own parameter mapping, optional logic inside the module.

### Example — Round Brick

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: Simple Round Brick
 * Filename: mb_block__mm__examples__simple_round_brick.scad
 * Package: mm.examples.simple_round_brick
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Visit machineblocks.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */

// Size
size = [4, 2, 3]; // [1:0.25:64]

// Rounding Radius
roundingRadiusZ = 0.5; // [0:0.25:2]

/*
 * Main Module Call
 */
mb_block__mm__examples__simple_round_brick(
    config = mb_config,
    settings = [
        ["size", size],
        ["roundingRadiusZ", roundingRadiusZ]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mm__examples__simple_round_brick(config = undef, settings = undef){
    // Native Parameters
    size = mb_param_size(config, settings, [4, 2, 3]);
    // Custom Parameters
    roundingRadiusZ = mb_param(config, settings, "roundingRadiusZ", 0.5);

    mb_block(
        config = config,
        settings = [
            ["size", size],
            ["baseRoundingRadius", [0, 0, roundingRadiusZ]]
        ]
    );
}

/*
 * Sub Module "alt"
 * mm.examples.simple_round_brick.alt
 */
module mb_block__mm__examples__simple_round_brick__alt(config = undef, settings = undef){
    // Native Parameters
    size = mb_param_size(config, settings, [4, 2, 3]);
    // Custom Parameters
    roundingRadiusZ = mb_param(config, settings, "roundingRadiusZ", 0.5);

    mb_block(
        config = config,
        settings = [
            ["size", size],
            ["baseRoundingRadius", [0.25, 0.25, roundingRadiusZ]]
        ]
    );
}
```

### Example — Text Plate with Helper and Function

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: Simple Text Plate
 * Filename: mb_block__mm__examples__simple_text_plate.scad
 * Package: mm.examples.simple_text_plate
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Published under license:
 * Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
 * https://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * Visit machineblocks.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */

// Size Mode
sizeMode = "small"; // [small, large]

// Speed MPH
speedMph = 50; // [0:1:160]

/*
 * Main Module Call
 */
mb_block__mm__examples__simple_text_plate(
    config = mb_config,
    settings = [
        ["sizeMode", sizeMode],
        ["speedMph", speedMph]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mm__examples__simple_text_plate(config = undef, settings = undef){
    // Custom Parameters
    sizeMode = mb_param(config, settings, "sizeMode", "small");
    speedMph = mb_param(config, settings, "speedMph", 0);

    mb_block__mm__examples__simple_text_plate__help__doit(10);

    mb_block(
        config = config,
        settings = [
            ["size", sizeMode == "small" ? [4, 2, 1] : [8, 4, 1]],
            ["studs", false],
            ["text", str(mb_block__mm__examples__simple_text_plate__func__mph_to_kmh(speedMph))],
            ["textSide", 5],
            ["textSize", 12]
        ]
    );
}

/*
 * Helper Module "doit"
 * mm.examples.simple_text_plate.help.doit
 */
module mb_block__mm__examples__simple_text_plate__help__doit(my_var = 5){
    echo(concat("My var: ", my_var));
}

/**
 * Global function "mph_to_kmh"
 * mm.examples.simple_text_plate.func.mph_to_kmh
 *
 * Converts MPH to KMH
 */
function mb_block__mm__examples__simple_text_plate__func__mph_to_kmh(mph) = 1.6 * mph;
```

## Pattern 3 — Composite Block

Multiple `mb_block()` calls inside a wrapper block. The wrapper uses `base = false` and `studs = false`. Composite blocks must implement `mb_assembly()` and `mb_base_side_adjustment()` when parts support assembly and when parts are adjacent without overlap.

### Example — Wall Panel (Tongue + Groove)

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: AnyClosure Wall
 * Filename: mb_block__mm__anyclosure__wall.scad
 * Package: mm.anyclosure.wall
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Visit martianmicro.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */

// Size (Bounding Box)
size = [1, 8, 8]; // [1:0.25:32]

// Direction
direction = "west"; // [west:West, north:North, east:East, south:South]

// Assembly
assembly = "unassembled"; // [unassembled:Unassembled, assembled:Assembled, merged:Merged]

// Color
baseColor = "#303D4E";

/*
 * Main Module Call
 */
mb_block__mm__anyclosure__wall(
    config = mb_config,
    settings = [
        ["size", size],
        ["assembly", assembly],
        ["baseColor", baseColor],
        ["direction", direction]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mm__anyclosure__wall(config = undef, settings = undef){
    // Native Parameters
    size = mb_param_size(config, settings);
    offset = mb_param_offset(config, settings);
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);
    baseColor = mb_param_baseColor(config, settings);

    // Resolve Base Side Adjustments
    panelSideAdjustment = mb_base_side_adjustment(config, settings, [[2, "start"], [3, "end"]]);

    // Resolve assembly
    assembly = mb_assembly(config, settings, size, direction);

    // Wrapper Block
    mb_block(
        config = config,
        settings = [
            ["base", false],
            ["studs", false],
            ["size", size],
            ["align", align],
            ["offset", offset],
            ["direction", direction]
        ]
    ){
        mb_block(
            config = config,
            settings = [
                ["size", [size[0], size[1], size[2] - 1]],
                ["align", align],
                ["recess", true],
                ["tongue", assembly[0] != "merged"],
                ["recessWallGaps", [[1, 0, 0]]],
                ["baseColor", baseColor],
                ["baseSideAdjustment", panelSideAdjustment]
            ]
        );

        mb_block(
            config = config,
            settings = [
                ["size", [size[0], size[1], 1]],
                ["align", align],
                ["offset", mb_assembly_offset(assembly, [0, 0, size[2] - 1])],
                ["recessWallGaps", [[1, 0, 0]]],
                ["baseCutoutType", assembly[0] == "merged" ? "none" : "groove"],
                ["baseColor", baseColor],
                ["baseSideAdjustment", panelSideAdjustment]
            ]
        );
    }
}
```

### Example — Corner Panel

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: AnyClosure Corner
 * Filename: mb_block__mm__anyclosure__corner.scad
 * Package: mm.anyclosure.corner
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Visit martianmicro.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;

/*
 * Customization
 */

// Size (Bounding Box)
size = [4, 4, 9]; // [1:0.25:32]

// Direction
direction = "west"; // [west:West, north:North, east:East, south:South]

// Assembly
assembly = "unassembled"; // [unassembled:Unassembled, assembled:Assembled, merged:Merged]

// Corner Rounding
cornerRounding = 0.5; // [0:0.25:2]

// Color
baseColor = "#303D4E";

/*
 * Main Module Call
 */
mb_block__mm__anyclosure__corner(
    config = mb_config,
    settings = [
        ["size", size],
        ["assembly", assembly],
        ["cornerRounding", cornerRounding],
        ["baseColor", baseColor],
        ["direction", direction]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mm__anyclosure__corner(config = undef, settings = undef){
    // Native Parameters
    size = mb_param_size(config, settings, [4, 4, 9]);
    offset = mb_param_offset(config, settings);
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);
    baseColor = mb_param_baseColor(config, settings);

    // Custom Parameters
    cornerRounding = mb_param(config, settings, "cornerRounding", 0.5);
    wallThickness = mb_param(config, settings, "wallThickness", 1);

    // Resolve Base Side Adjustments
    panelXSideAdjustment = mb_base_side_adjustment(config, settings, [[1, "start"]]);
    panelYSideAdjustment = mb_base_side_adjustment(config, settings, [[3, "end"]]);

    // Resolve assembly
    assembly = mb_assembly(config, settings, size, direction);

    // Wrapper Block
    mb_block(
        config = config,
        settings = [
            ["base", false],
            ["studs", false],
            ["size", size],
            ["align", align],
            ["offset", offset],
            ["direction", direction]
        ]
    ){
        // Panel X — lower
        mb_block(config = config, settings = [
            ["size", [size[0], wallThickness, size[2] - 1]],
            ["baseWallGapsX", [[0, 1]]],
            ["offset", [0, 0, 0]],
            ["recess", true],
            ["tongue", assembly[0] != "merged"],
            ["recessWallGaps", [[3, 0, 0]]],
            ["tongueClampThickness", 0.1],
            ["baseSideAdjustment", panelXSideAdjustment],
            ["baseRoundingRadius", [0, 0, [cornerRounding, 0, 0, 0]]],
            ["baseColor", baseColor]
        ]);

        // Panel X — groove
        mb_block(config = config, settings = [
            ["size", [size[0], wallThickness, 1]],
            ["baseWallGapsX", [[0, 1]]],
            ["offset", mb_assembly_offset(assembly, [0, 0, size[2] - 1])],
            ["recessWallGaps", [[3, 0, 0]]],
            ["tongueClampThickness", 0.1],
            ["baseCutoutType", assembly[0] == "merged" ? "none" : "groove"],
            ["baseSideAdjustment", panelXSideAdjustment],
            ["baseRoundingRadius", [0, 0, [cornerRounding, 0, 0, 0]]],
            ["baseColor", baseColor]
        ]);

        // Panel Y — lower
        mb_block(config = config, settings = [
            ["size", [wallThickness, size[1], size[2] - 1]],
            ["baseWallGapsY", [[0, 1]]],
            ["offset", [0, 0, 0]],
            ["recess", true],
            ["tongue", assembly[0] != "merged"],
            ["recessWallGaps", [[1, 0, 0]]],
            ["tongueClampThickness", 0.1],
            ["baseSideAdjustment", panelYSideAdjustment],
            ["baseRoundingRadius", [0, 0, [cornerRounding, 0, 0, 0]]],
            ["baseColor", baseColor]
        ]);

        // Panel Y — groove
        mb_block(config = config, settings = [
            ["size", [wallThickness, size[1], 1]],
            ["baseWallGapsY", [[0, 1]]],
            ["offset", mb_assembly_offset(assembly, [0, 0, size[2] - 1])],
            ["recessWallGaps", [[1, 0, 0]]],
            ["tongueClampThickness", 0.1],
            ["baseCutoutType", assembly[0] == "merged" ? "none" : "groove"],
            ["baseSideAdjustment", panelYSideAdjustment],
            ["baseRoundingRadius", [0, 0, [cornerRounding, 0, 0, 0]]],
            ["baseColor", baseColor]
        ]);
    }
}
```

### Example — Combined Wall (Composite of Composite Blocks)

Demonstrates `mb_parts_total_size()` and passing `assembly` through a tree of composite blocks.

```scad
/**
 * MachineBlocks.com Block File
 *
 * Name: AnyClosure Combined Wall
 * Filename: mb_block__mm__anyclosure__combined_wall.scad
 * Package: mm.anyclosure.combined_wall
 *
 * Copyright (c) 2022 - 2025 Jan Philipp Knoeller <pk@pksoftware.de>
 *
 * Visit martianmicro.com for more information.
 */

/*
 * Imports
 */
// MachineBlocks Library
use <../../../../machineblocks/lib/block.scad>;
// Global Config
include <../../../config/mb_config.scad>;
// Block Parts
use <../corner/mb_block__mm__anyclosure__corner.scad>;
use <../wall/mb_block__mm__anyclosure__wall.scad>;

/*
 * Customization
 */

// Assembly
assembly = "unassembled"; // [unassembled:Unassembled, assembled:Assembled, merged:Merged]

// Direction
direction = "west"; // [west:West, north:North, east:East, south:South]

// Color
baseColor = "#303D4E";

/*
 * Main Module Call
 */
mb_block__mm__anyclosure__combined_wall(
    config = mb_config,
    settings = [
        ["direction", direction],
        ["align", "start"],
        ["baseColor", baseColor],
        ["assembly", assembly]
    ]
);

/*
 * Main Module Definition
 */
module mb_block__mm__anyclosure__combined_wall(config = undef, settings = undef){
    // Native Parameters
    direction = mb_param_direction(config, settings);
    align = mb_param_align(config, settings);
    offset = mb_param_offset(config, settings);
    baseColor = mb_param_baseColor(config, settings);

    // Block Parts (size, direction, offset)
    parts = [
        [[4, 4, 9], "west",  [0, 0,  0]],
        [[1, 8, 9], "west",  [0, 4,  0]],
        [[4, 4, 9], "north", [0, 12, 0]]
    ];

    // Calculate the size of the composite block based on the parts
    size = mb_parts_total_size(parts);

    // Resolve assembly
    assembly = mb_assembly(config, settings, size, direction);

    // Wrapper Block
    mb_block(
        config = config,
        settings = [
            ["size", size],
            ["direction", direction],
            ["align", align],
            ["offset", offset],
            ["base", false],
            ["studs", false]
        ]
    ){
        // Part 1: Corner Front Left
        mb_block__mm__anyclosure__corner(
            config = config,
            settings = [
                ["size", parts[0][0]],
                ["direction", parts[0][1]],
                ["offset", parts[0][2]],
                ["namedSideAdjustments", [["end", 0.01]]],
                ["baseColor", baseColor],
                ["assembly", assembly]
            ]
        );

        // Part 2: Wall Left
        mb_block__mm__anyclosure__wall(
            config = config,
            settings = [
                ["size", parts[1][0]],
                ["direction", parts[1][1]],
                ["offset", parts[1][2]],
                ["namedSideAdjustments", [["start", 0.01], ["end", 0.01]]],
                ["baseColor", baseColor],
                ["assembly", assembly]
            ]
        );

        // Part 3: Corner Rear Left
        mb_block__mm__anyclosure__corner(
            config = config,
            settings = [
                ["size", parts[2][0]],
                ["direction", parts[2][1]],
                ["offset", parts[2][2]],
                ["namedSideAdjustments", [["start", 0.01]]],
                ["baseColor", baseColor],
                ["assembly", assembly]
            ]
        );
    }
}
```

---

# Structural Patterns

Structural patterns describe how blocks are combined to create functional structures. They are implemented using Block Module Pattern 3 (Composite Block).

## Panel

A surface with one or more vertical walls. Created using `recess = true` with wall control via `recessWallGaps` and `recessWallThickness`.

## Corner Panel

Two panels intersecting in an L-shape. Requires `baseWallGapsX`/`baseWallGapsY` at crossing points for grid compatibility.

## Channel

A panel with two opposing open walls. Variants include straight, corner (90° bend), and T-channel (branching).

## Enclosure

A complete housing: base plate, wall panels, corner panels, and lid. The lid is always a separate block. Inner parts should use `baseCutoutType = "none"`.

## Connection Patterns

**Tongue + Groove** — continuous, strong connection. Works with or without recess.

**Connectors** — segmented triangular connections for side-by-side and angled (90°) joints.

## Pattern Relationships

```text
Panel         → 1 open side
Channel       → 2 open sides
Corner Panel  → 2 panels combined
Corner Channel→ 2 channels combined
T-Channel     → 3 channels combined
Enclosure     → panels + corners + base + lid
```

---

# Set Files

Set files are generated SCAD files that combine multiple block instances into a complete assembly with assembly instructions. They are not authored manually. See `10_set_example.scad` for the current reference implementation.

A set file supports four rendering modes: `total` (fully assembled), `print` (individual parts for printing), `step` (step-by-step build instructions), and `instance` (single block). The `STEPS` array is the central data structure defining instance order, sizes, directions, and offsets. For each instance, a dedicated sub-module is generated. The generator must update both the `STEPS` array and all instance sub-modules when the set changes.

---

# Critical Implementation Rules

**Wall Removal:** Always use `recessWallGaps`, never `recessWallThickness = 0`.

**Connection Interaction:** `recessWallGaps` creates matching openings in tongue and groove automatically.

**Underside Consistency:** Use `baseWallGapsX`/`baseWallGapsY` in composite blocks where blocks cross.

**Printability:** Complex structures should be split into parts using tongue/groove or connectors.

**Config Propagation:** Every `mb_block()` call inside a module must receive the `config` parameter.

**Assembly Toggling:** Use `assembly[0]` to check mode after resolving via `mb_assembly()`. Use `assembly[0] != "merged"` for tongue, `assembly[0] == "merged"` for baseCutoutType switching.

**Parameter Access:** Always use `mb_param_*()` for native parameters and `mb_param()` for custom parameters. Never access arrays directly.

**studSink:** Set to 0 only when a sub-block has `base = false` but still renders studs (e.g. stud-only decorative layers in composite blocks).
