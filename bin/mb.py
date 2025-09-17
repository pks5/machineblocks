import json
import os
import re
import argparse
import sys
from typing import List

USAGE_TEMPLATE = """
USAGE:
  {prog} examples render <path>
      Render .scad files from a JSON file or recursively from all JSON files in a directory.

  {prog} thumbnails generate <path>
      Generate thumbnails (dummy implementation).

Examples:
  {prog} examples render ./examples.json
  {prog} examples render ./examples/
  {prog} thumbnails generate ./assets
"""

quality_variables = """// Quality of the preview in relation to the final rendering.
    previewQuality = 0.5; // [0.1:0.1:1]
    // Number of drawn fragments for roundings in the final rendering.
    roundingResolution = 64; // [16:8:128]"""

quality_params = """previewQuality = previewQuality,
    baseRoundingResolution = roundingResolution,
    holeRoundingResolution = roundingResolution,
    knobRoundingResolution = roundingResolution,
    pillarRoundingResolution = roundingResolution,"""

preset_params = """baseHeightAdjustment = baseHeightAdjustment,
    knobSize = knobSize,
    wallThickness = wallThickness,
    tubeZSize = tubeZSize,
    pinSize = pinSize"""

base_variables = """// Color of the brick
    baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]"""

base_params = """baseColor = baseColor,"""

def process_examples_file(example_file_path: str):
    if not os.path.exists(example_file_path):
        print("Cannot open file: " + example_file_path)
        return

    with open(example_file_path, "r", encoding="utf-8") as f:
        try:
            d = json.load(f)
        except json.JSONDecodeError as e:
            print(f"Invalid JSON in {example_file_path}: {e}")
            return

    if 'type' not in d or d['type'] != 'com.machineblocks.examples':
        print(f"No valid examples file: {example_file_path}")
        return
    
    if 'examples' not in d or not isinstance(d['examples'], list):
        print(f"No 'examples' list found in {example_file_path}")
        return

    for example in d['examples']:
        target_dir = os.path.abspath(os.path.join(example_file_path, '..', example['targetDirectory']))
        url = example['url']
        template_file_path = os.path.abspath(os.path.join(example_file_path, '..', example['template']))

        try:
            with open(template_file_path, "r", encoding="utf-8") as file:
                brick_template = file.read()
        except OSError as e:
            print(f"Cannot open template '{template_file_path}': {e}")
            continue

        # Ensure target dir exists
        os.makedirs(target_dir, exist_ok=True)

        for brick in example['bricks']:
            file_name = brick['name'].lower().replace(' ', '-') + '.scad'
            scad = brick_template.replace('{URL}', url)
            scad = scad.replace('{BRICK_NAME}', brick['name'])
            scad = scad.replace('/*{QUALITY_VARIABLES}*/', quality_variables)
            scad = scad.replace('/*{QUALITY_PARAMETERS}*/', quality_params)
            scad = scad.replace('/*{PRESET_PARAMETERS}*/', preset_params)
            scad = scad.replace('/*{BASE_VARIABLES}*/', base_variables)
            scad = scad.replace('/*{BASE_PARAMETERS}*/', base_params)

            for param in brick['parameters']:
                val = brick['parameters'][param]
                if isinstance(val, str):
                    try:
                        print('Replaced string param ' + param + ' with value: ' + val)
                    except UnicodeEncodeError:
                        print('Replaced string param ' + param + ' with unicode value')

                    scad = re.sub(param + r'\s*=\s*\"[a-zA-Z0-9\.\-_\s]+\"\s*;', param + ' = "' + val + '";', scad)
                elif isinstance(val, bool):
                    print('Replaced bool param ' + param + ' with value: ' + str(val).lower())
                    scad = re.sub(param + r'\s*=\s*((true)|(false))\s*;', param + ' = ' + str(val).lower() + ';', scad)
                elif isinstance(val, (int, float)):
                    print('Replaced integer param ' + param + ' with value: ' + str(val))
                    scad = re.sub(param + r'\s*=\s*((\"auto\")|([0-9\.\-]+))\s*;', param + ' = ' + str(val) + ';', scad)
                elif isinstance(val, list):
                    print('Replaced list param ' + param + ' with value: ' + json.dumps(val))
                    scad = re.sub(param + r'\s*=\s*((\[[\[\]0-9\.\,\s]*\])|(\"[a-zA-Z0-9\.\-_\s]+\")|([0-9\.\-]+)|((true)|(false)))\s*;', param + ' = ' + json.dumps(val) + ';', scad)
                else:
                    print('Did not replace param ' + param + ': unknown type!')

            out_path = os.path.join(target_dir, file_name)
            try:
                with open(out_path, "w", encoding="utf-8") as f:
                    f.write(scad)
                print("Wrote " + out_path)
            except OSError as e:
                print(f"Failed to write '{out_path}': {e}")


def _collect_json_files_recursive(root_dir: str) -> List[str]:
    """Return a sorted list of absolute paths to all .json files under root_dir (recursive)."""
    collected: List[str] = []
    for current_root, dirs, files in os.walk(root_dir):
        # Make traversal deterministic
        dirs.sort()
        files.sort()
        for name in files:
            if name.lower().endswith(".json"):
                collected.append(os.path.abspath(os.path.join(current_root, name)))
    # de-duplicate while preserving order
    seen = set()
    unique: List[str] = []
    for p in collected:
        if p not in seen:
            seen.add(p)
            unique.append(p)
    return unique


if __name__ == "__main__":
    prog = os.path.basename(__file__)
    USAGE = USAGE_TEMPLATE.format(prog=prog)

    def _print_usage_and_exit(msg: str = None, code: int = 2):
        if msg:
            print(msg)
        print(USAGE)
        sys.exit(code)

    parser = argparse.ArgumentParser("create-examples", add_help=True)
    # Do NOT require subparsers at parse time; we want to show a custom USAGE if missing/invalid
    lvl1 = parser.add_subparsers(dest="command")

    # =====================
    # Top-level: examples
    # =====================
    p_examples = lvl1.add_parser(
        "examples",
        help="Work with example JSONs (render .scad files, etc.).")
    ex_sub = p_examples.add_subparsers(dest="examples_cmd")

    # examples render <path>
    p_ex_render = ex_sub.add_parser(
        "render",
        help="Render .scad files from a JSON file or recursively from all JSON files in a directory.")
    p_ex_render.add_argument(
        "path",
        help="Path to a JSON file or a directory that will be searched recursively for JSON files.",
        type=str,
    )

    # =====================
    # Top-level: thumbnails
    # =====================
    p_thumbs = lvl1.add_parser(
        "thumbnails",
        help="Manage thumbnails (placeholder).")
    th_sub = p_thumbs.add_subparsers(dest="thumbs_cmd")

    # thumbnails generate <path>
    p_th_generate = th_sub.add_parser(
        "generate",
        help="Generate thumbnails (dummy implementation).")
    p_th_generate.add_argument(
        "path",
        help="Path to a file or directory (not used yet).",
        type=str,
    )

    # Parse while keeping unknowns so we can provide friendly errors
    args, unknown = parser.parse_known_args()

    # No top-level command provided
    if args.command is None:
        if unknown and not unknown[0].startswith("-"):
            _print_usage_and_exit(f"Error: unknown command '{unknown[0]}'.")
        _print_usage_and_exit("Error: no command provided.")

    if args.command == "examples":
        # No subcommand or invalid subcommand under 'examples'
        if args.examples_cmd is None:
            if unknown:
                _print_usage_and_exit(f"Error: unknown 'examples' subcommand '{unknown[0]}'.")
            _print_usage_and_exit("Error: no 'examples' subcommand provided.")

        if args.examples_cmd == "render":
            target_path = os.path.abspath(os.path.relpath(args.path, start=os.curdir))

            if not os.path.exists(target_path):
                print("Path does not exist: " + target_path)
            elif os.path.isfile(target_path):
                print("Processing examples file: " + target_path)
                process_examples_file(target_path)
            elif os.path.isdir(target_path):
                json_files = _collect_json_files_recursive(target_path)
                if not json_files:
                    print("No JSON files to process in directory: " + target_path)
                else:
                    for path in json_files:
                        print("Processing examples file: " + path)
                        process_examples_file(path)
            else:
                print("Unsupported path type: " + target_path)
        else:
            _print_usage_and_exit(f"Error: unknown 'examples' subcommand '{args.examples_cmd}'.")

    elif args.command == "thumbnails":
        # No subcommand or invalid subcommand under 'thumbnails'
        if args.thumbs_cmd is None:
            if unknown:
                _print_usage_and_exit(f"Error: unknown 'thumbnails' subcommand '{unknown[0]}'.")
            _print_usage_and_exit("Error: no 'thumbnails' subcommand provided.")

        if args.thumbs_cmd == "generate":
            abs_path = os.path.abspath(os.path.relpath(args.path, start=os.curdir))
            print(f"[thumbnails/generate] Not implemented yet. Would process: {abs_path}")
        else:
            _print_usage_and_exit(f"Error: unknown 'thumbnails' subcommand '{args.thumbs_cmd}'.")
