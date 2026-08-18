# MachineBlocks V3 (Alpha)

Toolkit for designing and 3D printing LEGO® compatible building blocks.

This repository is the **alpha** of MachineBlocks V3. The V3 library is still in alpha. The website at [machineblocks.com](https://machineblocks.com) currently documents the **V2** library.

## Two ways to use V3

### 1. Standalone OpenSCAD library

Use V3 as a standalone SCAD library, the same way V2 was used. Open the examples in [OpenSCAD](https://openscad.org):

- `blocks/com/machineblocks/scad`

### 2. BML (pre-alpha)

The new **BML** syntax is a second authoring path. BML is both:

- the **single source of truth** for the library (types, bricks, and documentation are written in BML)
- a new way to write MachineBlocks bricks

BML is **pre-alpha**: there is no renderer yet that converts BML to SCAD. You can still read the BML sources, ask an LLM about them, and generate SCAD from that understanding.

Start here:

- `blocks/com/machineblocks/bml/README.bml` — reading entry point
- `blocks/com/machineblocks/bml/Library.bml` — library catalog

## Recommended: open this project in an LLM IDE

Open the repo in an LLM IDE such as [Cursor](https://cursor.com) or [Claude Code](https://claude.com/claude-code). The assistant can read the BML files, answer questions about the library, and generate SCAD examples.

Install the BlockML core package first. It provides the base blocks and syntax that MachineBlocks BML builds on:

```bash
npm install
```

This installs `@blockml/core` (see `package.json`).

## Community

Ask questions about the V3 library, alpha progress, and how to use it on [Discord](https://discord.gg/x9nunaJykA).

Follow MachineBlocks on [TikTok](https://tiktok.com/@machineblocks.com) and [Instagram](https://instagram.com/machineblocks).

## License

[Apache License 2.0](LICENSE)
