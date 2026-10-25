# BlockML Project Instructions

This repository contains a BlockML model. BML is the editable source of truth. The BOM is the canonical parsed representation.

The effective model includes local BML and BlockML libraries from npm (and any local packages that declare `blockml.library`). Identify Blocks by FQN. Look up semantics in the model. Do not invent types, syntax, or capabilities.

Start at this project's library: `package.json` → `blockml.library` → that Library's `readMe`. Domain vocabulary and project-specific rules live there.

A BlockML repository may contain anything besides BML — TypeScript, Java, OpenSCAD, tests, docs, a song, or any other files. There is no default companion language. Those files are not the model. Change BML first, then update companions to match the new BML: `blockml compile` when a target exists, or edit them directly (including by an LLM). Never invent model semantics only in companions, and never update companions first and retrofit BML.

BML libraries are packaged as npm packages by default. The BlockML toolchain is Node/npm. That is the *host* for models and tools — not the repository's product. Output, when a repo has one, is a companion artifact built from BML. It might be a Spring application, OpenSCAD, an npm package, or anything else; npm output is common, not required. An npm tree in the repo may be toolchain, BML libraries, product output, or several of these at once. Do not assume `package.json` is the product.

## Tools

Use the project-local CLI:

```bash
npx blockml <command>
```

Do not install or upgrade `@blockml/cli` unless asked. If the CLI is missing, run `npm ci` or `npm install`. If `@blockml/cli` is not a project dependency, report that and stop.

Run `npx blockml --help` for commands, workflow, and flags. Run `npx blockml <command> --help` before first use of a command (search, scan, inspect, graph, new, init, validate, compile, transform).

Search answers where something is. Scan answers which packages or types match selectors (set membership, not full-text search; quote `*` / `**`). Inspect answers: give me this Block already resolved. Graph answers how it connects.

Generic grep, find, and file reads remain allowed. They are not the first way into the model.

## Workflow

```text
task → search or scan → FQNs → inspect (graph if structure) → targeted BML read → smallest BML edit → validate
     → update companions to match (compile and/or edit)
```

If syntax is unclear: inspect the type Block, then similar existing BML, then change. Do not guess.

Treat in-BML documentation as searchable knowledge. After dependency changes, rebuild `search index` if results look incomplete.

Leave the model valid: run `npx blockml validate` after edits. Do not finish with a red model unless the user asked for an incomplete change.

## Rules

- Change BML first. Then update companions from that BML (compile or direct edit). Companions are never SSOT.
- Prefer existing Blocks over new duplicates. Keep the change scoped.
- Do not edit `node_modules`.
- Do not commit, push, reset, or rewrite user git state unless asked.
- Report gaps instead of inventing unsupported solutions.
