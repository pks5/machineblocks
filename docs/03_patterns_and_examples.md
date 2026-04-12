# MachineBlocks — Patterns and Examples

version: 1.1.0

## Purpose of this Document

This document defines the Block File structure, customizer conventions, config handling, and Block Module patterns. Each pattern is accompanied by concrete, production-ready examples.

> For all parameter definitions see `09_api_parameters_1_0_1.yml`.
> For terminology (Block Module, Block File) see `01_system.md`.

---

# Block File Structure

Every Block File follows a mandatory structure. The sections must appear in this order. Comments and headers are optional but recommended as the standard for AI-generated code.

```scad
/**
 * Header (optional but recommended)
 */

/* Imports */

/* Customizer Variables */

/* Main Module Call */

/* Main Module Definition */

/* Optional Sub-Modules */

/* Optional Global Functions */
```

## Complete Block File Template

```scad
/**
* MachineBlocks Block File
*
* Name: My Block
* Filename: mb_block__my__package__my_block.scad
* Package: my.package.my_block
*/

/*
* Imports
*/
use <../../../machineblocks/lib/block.scad>;
include <../../config/mb_config.scad>;

/*
* Customization
*/

/* [Geometry] */

// Size
size = [4, 2, 3]; // [1:1:16]

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

**Library import** using `use` (loads only module definitions, ignores customizer variables):

```scad
use <../../../machineblocks/lib/block.scad>;
```

**Config import** using `include` (executes the file, making `mb_config` available as a variable):

```scad
include <../../config/mb_config.scad>;
```

Local paths vary by project structure. AI IDEs like Cursor can resolve them automatically. The Online Editor converts paths on upload:

```text
use <../../../machineblocks/lib/block.scad>  →  use <machineblocks/lib/block.scad>
include <../../config/mb_config.scad>        →  include </mb_config.scad>
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
        config = config,  // config parameter, not mb_config
        settings = [...]
    );
}
```

> `mb_config` exists only at file level. Inside modules, always use the `config` parameter.

---

# OpenSCAD Customizer Syntax

The customizer section defines variables that appear in the OpenSCAD Customizer UI. Only variables with direct value assignments are shown in the customizer. Computed or derived values are not displayed.

## Tabs

Variables are grouped into tabs using special comments:

```scad
/* [Geometry] */
size = [4, 2, 3]; // [1:1:16]

/* [Appearance] */
baseColor = "#ff0000";
```

`/* [Hidden] */` hides all variables below it from the customizer. Use this for computed values and helper assignments.

`/* [Global] */` shows variables in all tabs simultaneously.

Without any tab comments, all variables appear in a single default tab.

## Input Types

**String** — free text input:

```scad
// Label Text
myText = "Hello";
```

**Number with range** — slider:

```scad
// Speed
speed = 50; // [0:1:160]
```

Format: `// [min:step:max]`

**Number with step** — spinbox:

```scad
// Radius
radius = 0.5; // .25
```

Format: `// .step`

**Boolean** — checkbox:

```scad
// Enable Studs
studs = true;
```

**Enum** — combobox:

```scad
// Direction
direction = "west"; // [west, north, east, south]
```

**Enum with labels** — combobox with display names:

```scad
// Assembly
assembly = "unassembled"; // [unassembled:Unassembled, assembled:Assembled, merged:Merged]
```

**Enum with numbers** — combobox:

```scad
// Count
count = 4; // [4, 5, 6]
```

**Array with range** — multi-field input with sliders:

```scad
// Size
size = [4, 2, 3]; // [1:1:16]
```

Arrays with up to 4 integer fields support range syntax for slider/input display.

## Important Rules

Customizer variables do not need to map 1:1 to `mb_block` parameters. Complex parameter values often require multiple customizer variables that are combined in the module. The customizer only supports primitive types — numbers, strings, and booleans.

Only direct value assignments appear in the customizer:

```scad
a = 5;     // shown in customizer
b = a;     // NOT shown in customizer
c = a + 1; // NOT shown in customizer
```

Computed values and helper assignments must be placed under `/* [Hidden] */` to avoid appearing as empty entries in the customizer.

---

# Block Module Patterns

Block Modules follow three patterns based on their internal complexity.

## Pattern 1 — Primitive Wrapper

A pass-through wrapper around `mb_block()` or another block module. No own logic, no parameter mapping — `config` and `settings` are forwarded directly.

Purpose: Expose a specific set of `mb_block` parameters through the customizer UI.

```scad
use <../../../machineblocks/lib/block.scad>;
include <../../config/mb_config.scad>;

// Size
size = [3, 1, 1]; // [1:1:16]

// Color
baseColor = "#ff0000";

// Direction
direction = "west"; // [west, north, east, south]

// Studs
studs = true;

mb_block__my__package__primitive_wrapper(
    config = mb_config,
    settings = [
        ["size", size],
        ["baseColor", baseColor],
        ["direction", direction],
        ["studs", studs]
    ]
);

module mb_block__my__package__primitive_wrapper(config = undef, settings = undef){
    mb_block(
        config = config,
        settings = settings
    );
}
```

## Pattern 2 — Simple Block

Own customizer variables, own parameter mapping, optional logic inside the module. Translates semantic or simplified parameters into `mb_block` parameters.

Purpose: Create reusable semantic blocks with domain-specific interfaces. Useful for giving AI systems simpler, purpose-named modules to choose from.

### Example — Text Plate with Unit Conversion

```scad
use <../../../machineblocks/lib/block.scad>;
include <../../config/mb_config.scad>;

// Size Mode
sizeMode = "small"; // [small, large]

// Speed MPH
speedMph = 50; // [0:1:160]

mb_block__my__package__simple_text_plate(
    config = mb_config,
    settings = [
        ["sizeMode", sizeMode],
        ["speedMph", speedMph]
    ]
);

module mb_block__my__package__simple_text_plate(config = undef, settings = undef){
    sizeMode = mb_params_resolve(config, settings, "sizeMode", "small");
    speedMph = mb_params_resolve(config, settings, "speedMph", 0);

    mb_block(
        config = config,
        settings = [
            ["size", sizeMode == "small" ? [4, 2, 1] : [8, 4, 1]],
            ["studs", false],
            ["text", str(mb_block__my__package__simple_text_plate__mph_to_kmh(speedMph))],
            ["textSide", 5],
            ["textSize", 12]
        ]
    );
}

function mb_block__my__package__simple_text_plate__mph_to_kmh(mph) = 1.6 * mph;
```

### Example — Semantic Naming (Round Brick)

Wraps a complex `mb_block` parameter (`baseRoundingRadius` with array format) behind a simple semantic interface (`roundingRadiusZ` as a single float).

```scad
use <../../../machineblocks/lib/block.scad>;
include <../../config/mb_config.scad>;

// Size
size = [4, 2, 3]; // [1:1:64]

// Rounding Radius
roundingRadiusZ = 0.5; // [0:0.25:2]

mb_block__my__package__simple_round_brick(
    config = mb_config,
    settings = [
        ["size", size],
        ["roundingRadiusZ", roundingRadiusZ]
    ]
);

module mb_block__my__package__simple_round_brick(config = undef, settings = undef){
    size = mb_params_resolve(config, settings, "size", [4, 2, 3]);
    roundingRadiusZ = mb_params_resolve(config, settings, "roundingRadiusZ", 0.5);

    mb_block(
        config = config,
        settings = [
            ["size", size],
            ["baseRoundingRadius", [0, 0, roundingRadiusZ]]
        ]
    );
}
```

## Pattern 3 — Composite Block

Multiple `mb_block()` calls inside a wrapper block. Creates complex geometry from several sub-blocks. The wrapper block uses `base = false` and `studs = false` — it only defines the bounding box and contains children.

Purpose: Build structures that cannot be expressed by a single `mb_block()` — panels, corners, enclosures, multi-part printable blocks.

### Assembly System

Composite blocks typically support three assembly states controlled by the `assembly` parameter:

`unassembled` — parts are visually separated for printing. `assembled` — parts are shown in their connected position. `merged` — parts are fused into a single body (no tongue/groove).

The `mb_assembly_offset()` library function calculates the visual separation offset respecting the current `direction`.

### Example — Wall Panel (Tongue + Groove)

A wall panel split into two printable parts: a lower block with recess and tongue, and an upper block with groove. The assembly parameter controls visualization.

```scad
use <../../machineblocks/lib/block.scad>;
include <../config/mb_config.scad>;

// Size (Bounding Box)
size = [1, 8, 8]; // [1:1:16]

// Assembly
assembly = "unassembled"; // [unassembled:Unassembled, assembled:Assembled, merged:Merged]

// Color
baseColor = "#303D4E"; // [#58B99D:Turquoise, #303D4E:Midnight Blue, #EAC645:Sun Flower, #D65745:Alizarin, #EDF0F1:Clouds]

mb_block__mm__anyclosure__wall(
    config = mb_config,
    settings = [
        ["size", size],
        ["assembly", assembly],
        ["baseColor", baseColor]
    ]
);

module mb_block__mm__anyclosure__wall(config = undef, settings = undef){
    size = mb_params_get(settings, "size", default=[1, 8, 8]);
    offset = mb_params_get(settings, "offset", default=[0, 0, 0]);
    direction = mb_params_get(settings, "direction", default="west");
    assembly = mb_params_get(settings, "assembly", default="unassembled");
    assemblyOffset = mb_params_get(settings, "assemblyOffset", default=[-1.5, 0, 0]);
    align = mb_params_get(settings, "align", default="start");
    baseColor = mb_params_get(settings, "baseColor", default="#EDF0F1");

    mb_block(
        config = config,
        settings = [
            ["base", false],
            ["studs", false],
            ["assembly", assembly],
            ["size", size],
            ["align", align],
            ["offset", offset],
            ["direction", direction]
        ]
    ){
        // Lower part — recess + tongue
        mb_block(
            config = config,
            settings = [
                ["size", [size[0], size[1], size[2] - 1]],
                ["align", align],
                ["recess", true],
                ["tongue", assembly != "merged"],
                ["recessWallGaps", [[1,0,0]]],
                ["baseColor", baseColor]
            ]
        );

        // Upper part — groove
        mb_block(
            config = config,
            settings = [
                ["size", [size[0], size[1], 1]],
                ["align", align],
                ["offset", assembly == "unassembled"
                    ? mb_assembly_offset(assemblyOffset, direction)
                    : [0, 0, size[2] - 1]],
                ["recessWallGaps", [[1,0,0]]],
                ["baseCutoutType", assembly == "merged" ? "none" : "groove"],
                ["baseColor", baseColor]
            ]
        );
    }
}
```

### Example — Corner Panel

Two panels intersecting in an L-shape. Each panel consists of 2 blocks (tongue + groove), totaling 4 blocks. Uses `baseWallGapsX`/`baseWallGapsY` at crossing points for grid compatibility.

```scad
use <../../machineblocks/lib/block.scad>;
include <../config/mb_config.scad>;

// Size (Bounding Box)
size = [4, 4, 9]; // [1:1:16]

// Assembly
assembly = "unassembled"; // [unassembled:Unassembled, assembled:Assembled, merged:Merged]

// Corner Rounding
cornerRounding = 0.5; // .25

mb_block__mm__anyclosure__corner(
    config = mb_config,
    settings = [
        ["size", size],
        ["assembly", assembly],
        ["cornerRounding", cornerRounding]
    ]
);

module mb_block__mm__anyclosure__corner(config = undef, settings = undef){
    size = mb_params_get(settings, "size", default=[4,4,9]);
    offset = mb_params_get(settings, "offset", default=[0, 0, 0]);
    direction = mb_params_get(settings, "direction", default="west");
    align = mb_params_get(settings, "align", default="start");
    assembly = mb_params_get(settings, "assembly", default="unassembled");
    assemblyOffset = mb_params_get(settings, "assemblyOffset", default=[-1.5, -1.5, 0]);
    baseColor = mb_params_get(settings, "baseColor", default="#EDF0F1");
    cornerRounding = mb_params_get(settings, "cornerRounding", default=0.5);
    wallThickness = mb_params_get(settings, "wallThickness", default=1);

    mb_block(
        config = config,
        settings = [
            ["base", false],
            ["studs", false],
            ["assembly", assembly],
            ["size", size],
            ["align", align],
            ["offset", offset],
            ["direction", direction]
        ]
    ){
        // Panel 1 — along Y axis
        mb_block(
            config = config,
            settings = [
                ["size", [size[0], wallThickness, size[2] - 1]],
                ["baseWallGapsX", [[0,1]]],
                ["offset", [0,0,0]],
                ["recess", true],
                ["tongue", assembly != "merged"],
                ["recessWallGaps", [[3,0,0]]],
                ["tongueClampThickness", 0.1],
                ["baseRoundingRadius", [0,0,[cornerRounding,0,0,0]]],
                ["baseColor", baseColor]
            ]
        );

        mb_block(
            config = config,
            settings = [
                ["size", [size[0], wallThickness, 1]],
                ["baseWallGapsX", [[0,1]]],
                ["offset", assembly == "unassembled"
                    ? mb_assembly_offset(assemblyOffset, direction)
                    : [0, 0, size[2] - 1]],
                ["recessWallGaps", [[3,0,0]]],
                ["tongueClampThickness", 0.1],
                ["baseCutoutType", assembly == "merged" ? "none" : "groove"],
                ["baseRoundingRadius", [0,0,[cornerRounding,0,0,0]]],
                ["baseColor", baseColor]
            ]
        );

        // Panel 2 — along X axis
        mb_block(
            config = config,
            settings = [
                ["size", [wallThickness, size[1], size[2] - 1]],
                ["baseWallGapsY", [[0,1]]],
                ["offset", [0, 0, 0]],
                ["recess", true],
                ["tongue", assembly != "merged"],
                ["recessWallGaps", [[1,0,0]]],
                ["tongueClampThickness", 0.1],
                ["baseRoundingRadius", [0,0,[cornerRounding,0,0,0]]],
                ["baseColor", baseColor]
            ]
        );

        mb_block(
            config = config,
            settings = [
                ["size", [wallThickness, size[1], 1]],
                ["baseWallGapsY", [[0,1]]],
                ["offset", assembly == "unassembled"
                    ? mb_assembly_offset(assemblyOffset, direction)
                    : [0, 0, size[2] - 1]],
                ["recessWallGaps", [[1,0,0]]],
                ["tongueClampThickness", 0.1],
                ["baseCutoutType", assembly == "merged" ? "none" : "groove"],
                ["baseRoundingRadius", [0,0,[cornerRounding,0,0,0]]],
                ["baseColor", baseColor]
            ]
        );
    }
}
```

### Example — Enclosure Lid

A complex composite block: 4 edge strips forming an outer ring with grid-compatible underside, a solid center plate with branding, and an optional opener mechanism. Demonstrates selective pillars, conditional geometry, and per-corner rounding.

```scad
use <../../machineblocks/lib/block.scad>;
include <../config/mb_config.scad>;

// Brand Name
brandName = "MachineBlocks";

// Lid Opener
opener = true;

// Opener Aid
openerAid = true;

mb_block__mm__anyclosure__lid(
    config = mb_config,
    settings = [
        ["brandName", brandName],
        ["opener", opener],
        ["openerAid", openerAid]
    ]
);

module mb_block__mm__anyclosure__lid(config = undef, settings = undef){
    size = mb_params_get(settings, "size", default=[16, 16, 2]);
    offset = mb_params_get(settings, "offset", default=[0, 0, 0]);
    align = mb_params_get(settings, "align", default="start");
    baseRoundingRadius = mb_params_get(settings, "baseRoundingRadius", default=0.5);
    studs = mb_params_get(settings, "studs", default=false);
    studType = mb_params_get(settings, "studType", default="classic");
    cutoutWidth = mb_params_get(settings, "cutoutWidth", default=2);
    opener = mb_params_get(settings, "opener", default=true);
    openerAid = mb_params_get(settings, "openerAid", default=true);
    baseColor = mb_params_get(settings, "baseColor", default="#EDF0F1");
    brandName = mb_params_get(settings, "brandName", default="MachineBlocks");
    brandFont = mb_params_get(settings, "brandFont", default="RBNo3.1");
    brandTextOffset = mb_params_get(settings, "brandTextOffset", default=[0, -7]);
    previewRender = mb_params_get(settings, "previewRender", default=true);

    mb_block(
        config = config,
        settings = [
            ["size", size],
            ["base", false],
            ["studs", false],
            ["align", align],
            ["alignChildren", "ccs"],
            ["offset", offset]
        ]
    ){
        union(){
            // 4 edge strips forming outer ring
            // Each strip gets only the matching corners rounded
            // baseWallGaps at corners for grid compatibility

            mb_block(config = config, settings = [
                ["size", [size[0], cutoutWidth, 1]],
                ["align", "ccs"],
                ["baseWallGapsX", [[0, 0, cutoutWidth], [size[0]-cutoutWidth, 0, cutoutWidth]]],
                ["offset", [0, 0.5*(size[1] - cutoutWidth), 0]],
                ["studs", studs], ["studType", studType],
                ["pillars", openerAid
                    ? [true, [0.5*(size[0]-4),0, 0.5*size[0],0, false]]
                    : true],
                ["baseRoundingRadius", [0, 0, [0,baseRoundingRadius,baseRoundingRadius,0]]],
                ["baseColor", baseColor],
                ["previewRender", previewRender]
            ]);

            mb_block(config = config, settings = [
                ["size", [cutoutWidth, size[1], 1]],
                ["align", "ccs"],
                ["baseWallGapsY", [[0, 0, cutoutWidth], [size[1]-cutoutWidth, 0, cutoutWidth]]],
                ["offset", [0.5*(size[0] - cutoutWidth), 0, 0]],
                ["studs", studs], ["studType", studType],
                ["baseRoundingRadius", [0, 0, [0,0,baseRoundingRadius,baseRoundingRadius]]],
                ["baseColor", baseColor],
                ["previewRender", previewRender]
            ]);

            mb_block(config = config, settings = [
                ["size", [cutoutWidth, size[1], 1]],
                ["align", "ccs"],
                ["baseWallGapsY", [[0, 1, cutoutWidth], [size[1]-cutoutWidth, 1, cutoutWidth]]],
                ["offset", [-0.5*(size[0] - cutoutWidth), 0, 0]],
                ["studs", studs], ["studType", studType],
                ["baseRoundingRadius", [0, 0, [baseRoundingRadius,baseRoundingRadius,0,0]]],
                ["baseColor", baseColor],
                ["previewRender", previewRender]
            ]);

            mb_block(config = config, settings = [
                ["size", [size[0], cutoutWidth, 1]],
                ["align", "ccs"],
                ["baseWallGapsX", [[0, 1, cutoutWidth], [size[0]-cutoutWidth, 1, cutoutWidth]]],
                ["offset", [0, -0.5*(size[1] - cutoutWidth), 0]],
                ["studs", studs], ["studType", studType],
                ["baseRoundingRadius", [0, 0, [baseRoundingRadius,0,0,baseRoundingRadius]]],
                ["baseColor", baseColor],
                ["previewRender", previewRender]
            ]);

            // Center plate — solid underside, branding
            mb_block(config = config, settings = [
                ["size", [size[0]-2*cutoutWidth, size[1]-2*cutoutWidth, 1]],
                ["align", "ccs"],
                ["baseCutoutType", "none"],
                ["baseSideAdjustment", 0.2],
                ["studs", studs], ["studType", studType],
                ["text", brandName],
                ["textSide", 5], ["textSize", 4],
                ["textFont", brandFont],
                ["textDepth", 0.4], ["textSpacing", 1.1],
                ["textOffset", brandTextOffset],
                ["baseColor", baseColor],
                ["previewRender", previewRender]
            ]);

            // Optional opener
            if(opener){
                mb_block(config = config, settings = [
                    ["align", "ccs"],
                    ["baseHeight", 1.6],
                    ["baseSideAdjustment", [-0.1,-0.1,0.1,-6.4]],
                    ["baseRoundingRadius", [0,0,[0,0.8,0.8,0]]],
                    ["baseCutoutType", "none"],
                    ["baseColor", baseColor],
                    ["size", [2,1,1]],
                    ["offset", [0, 0.5*(size[1]+1), 0]],
                    ["studs", false],
                    ["previewRender", previewRender]
                ]);
            }
        }
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

A panel with two opposing open walls, creating a continuous path for cables, airflow, or routing. Variants include straight channels, corner channels (90° bend), and T-channels (branching).

## Enclosure

A complete housing structure: base plate, wall panels, corner panels, and lid. The lid is always a separate block. Inner parts should use `baseCutoutType = "none"` for optimization.

## Connection Patterns

**Tongue + Groove** — continuous connection, strong and precise. Can be used with or without recess.

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

# Critical Implementation Rules

**Wall Removal:** Always use `recessWallGaps`, never `recessWallThickness = 0`.

**Connection Interaction:** `recessWallGaps` creates matching openings in tongue and groove automatically.

**Underside Consistency:** Use `baseWallGapsX`/`baseWallGapsY` in composite blocks where blocks cross to maintain grid compatibility.

**Printability:** Complex structures should be split into printable parts using tongue/groove or connectors.

**Config Propagation:** Every `mb_block()` call inside a module must receive the `config` parameter.

**Assembly Toggling:** Use the `assembly` parameter to control tongue/groove generation (`assembly != "merged"`) and part offset (`assembly == "unassembled"`).
