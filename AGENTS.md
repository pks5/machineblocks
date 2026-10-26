# BlockML Project Instructions

This is a [Block Machine](bml:org.blockml.bml.documentation.BlockMachine). Its BlockML model defines the intended semantics and is the source of truth. BML is the editable source; the BOM is its canonical parsed representation. Blocks are identified by fully qualified names (FQNs), including in `bml:` links.

The effective model includes local BML and BlockML libraries from npm, as well as local packages declaring `blockml.library`. The `blockml.library` entry in `package.json` identifies the Block Machine's root Library, which anchors the machine in the model. Its `readMe` documents that Library.

The purpose and workflows of this particular Block Machine are defined by additional instructions in this document. Look up definitions and semantics in the model. Never invent types, syntax, or capabilities.

A Block Machine may contain or produce arbitrary companion artifacts, such as TypeScript, Java, OpenSCAD, tests, documentation, or other files. There is no default companion language or product platform. Whether generated or edited directly, companion artifacts must remain consistent with the semantics defined in BML. Never define model semantics exclusively in companion artifacts.

BlockML uses Node/npm for its toolchain and typically distributes libraries as npm packages. This does not imply that the product itself is an npm package or a Node.js application. Dependencies in `package.json` may belong to the toolchain, BlockML libraries, the product, or several of these simultaneously. Do not assume `package.json` describes the product.

# Tools

Use the project-local CLI:

```bash
npx blockml <command>
```

Do not install or upgrade `@blockml/cli` unless asked. If the CLI is missing, run `npm ci` or `npm install`. If `@blockml/cli` is not a project dependency, report that and stop.

Run `npx blockml --help` for commands, workflow, and flags. Run `npx blockml <command> --help` before first use of a command (search, scan, inspect, graph, new, init, validate, compile, transform).

Search answers where something is. Scan answers which packages or types match selectors (set membership, not full-text search; quote `*` / `**`). Inspect answers: give me this Block already resolved. Graph answers how it connects.

Generic grep, find, and file reads remain allowed. They are not the first way into the model.

# Workflow

```text
task → search or scan → FQNs → inspect (graph if structure) → targeted BML read → smallest BML edit → validate
 → update companions to match (compile and/or edit)
```

If syntax is unclear: inspect the type Block, then similar existing BML, then change. Do not guess.

Treat in-BML documentation as searchable knowledge. After dependency changes, rebuild `search index` if results look incomplete.

Leave the model valid: run `npx blockml validate` after edits. Do not finish with a red model unless the user asked for an incomplete change.

# MachineBlocks CLI

`machineblocks` extends the BlockML CLI; it does not replace it.

```bash
npx machineblocks <command>
```

Use `machineblocks` for `validate`, `compile`, and `init`. Use `blockml` for model discovery, inspection, transformations, and other generic operations.

Run `npx machineblocks --help` and the command-specific `--help` before first use. Do not install or upgrade `@machineblocks/cli` unless asked. If the CLI is missing, report it and stop.

## Validation and Compilation

- After editing BML, run `npx machineblocks validate`.
- Use `npx machineblocks compile` to generate OpenSCAD Block Files from BML.
- **Never generate or modify SCAD files directly with the LLM unless explicitly requested.** SCAD is a compiler output, not the source of truth.
- Do not use `blockml compile` for MachineBlocks SCAD generation; it handles generic BlockML compilation targets.

# Building a MachineBlock

MachineBlocks are authored in MBML. Use the model as the source of truth.

Start with these references:

- [DecisionFramework](bml:com.machineblocks.bml.documentation.concept.DecisionFramework) — choose the modeling approach.
- [AuthoringPatterns](bml:com.machineblocks.bml.documentation.mbml.AuthoringPatterns) — implement the model.
- [NativeBlock](bml:com.machineblocks.bml.core.NativeBlock) — authoritative reference for native parameters, types, and defaults.

Discover additional documentation and model definitions using the BlockML CLI.

# Rules

- Change BML first. Then update companions from that BML (compile or direct edit). Companions are never SSOT.
- Prefer existing Blocks over new duplicates. Keep the change scoped.
- Report gaps instead of inventing unsupported solutions.
- Do not edit `node_modules`.
- Do not commit, push, reset, or rewrite user git state unless asked.
- Start with the modeling intent, not with parameters.
  Consult DecisionFramework before choosing an implementation.
- Never invent native parameters, types, or defaults.
  Inspect NativeBlock for their authoritative definitions.
- Do not extend NativeBlock. Extend Block or CompositeBlock.
- Prefer MBML for new domain content.
  OpenSCAD Block Files are a render target.
