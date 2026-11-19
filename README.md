# MachineBlocks Core

This repository is `@machineblocks/core`: the MachineBlocks BML core and the OpenSCAD library that renders it. It exists so those two can be developed together.

A project of your own starts from the [V3 Alpha guide](https://machineblocks.com/v3-alpha). This repository is the place to change the core and the library.

## Create a project

The [V3 Alpha guide](https://machineblocks.com/v3-alpha) is the setup for designing bricks: a coding agent, Node.js, and an OpenSCAD development snapshot. In an empty folder, initialize a project with a fully qualified name. The name reverses a domain and includes a `bml` segment. `com.acme.bml.test` is only an example:

```bash
npx @machineblocks/cli init com.acme.bml.test
```

Open that folder in the agent and describe the brick. The agent writes the BlockML file, and the MachineBlocks compiler renders the matching OpenSCAD file. Cloning this repository is separate from that setup.

## What this repository contains

MachineBlocks authors bricks in BML. A compiler renders BML to a target, and OpenSCAD is the reference target: OpenSCAD Desktop turns the generated files into STL or 3MF.

This package currently holds both layers:

- **BML core** in `blocks/com/machineblocks/bml` — types, native parameters, documentation, and example bricks. BML is the source of truth.
- **OpenSCAD library** in `lib/` — `mb_block()` and the modules behind it. Compiled bricks under `blocks/com/machineblocks/scad` call this library. The compiler replaces the `bml` segment of a fully qualified name with `scad`.

The two layers share this repository while OpenSCAD is the only renderer. A further renderer would be its own library, and the BML core would stay separate from it. Work here to change the BML core, change the OpenSCAD library, or add example bricks beside that core.

## Compile BML to OpenSCAD

Examples in this repository are BML files. The MachineBlocks CLI renders them. Node.js 20 or newer is required. From the repository root:

```bash
npm install
npx machineblocks validate
npx machineblocks compile com.machineblocks.bml.examples.Connector
```

`validate` checks the model. `compile` renders selected Block and Set types to OpenSCAD under `blocks`, using the `machineblocks-v3-scad` target. The command above writes `blocks/com/machineblocks/scad/examples/Connector.scad`.

A package selector compiles every Block and Set in that package. Quote `*` so the shell leaves it alone:

```bash
npx machineblocks compile "com.machineblocks.bml.examples.*"
```

`npx machineblocks compile --help` lists the selector rules and the optional `--source-package` / `--target-package` mapping. Search and inspection stay on `npx blockml`.

## Regenerate AGENTS.md

`AGENTS.md` is generated. `npx blockml agents-md generate` rewrites it from AgentInstructions in this repository and in direct dependencies that publish a BlockML library, including `@blockml/cli` and `@machineblocks/cli`. A CLI update can change those instructions. After updating either CLI, regenerate the file:

```bash
npx blockml agents-md generate
```

The command overwrites `AGENTS.md` when it finds at least one section or rule.

## License

[Apache License 2.0](LICENSE)
