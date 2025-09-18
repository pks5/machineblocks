import json
import os
import re
from typing import List

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
            scad = scad.replace('/*{IMPORTS}*/', "use <" + d['config']['lib'] + "/block.scad>;\ninclude <" + d['config']['presets'] + ">;\n")

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
        dirs.sort()
        files.sort()
        for name in files:
            if name.lower().endswith(".json"):
                collected.append(os.path.abspath(os.path.join(current_root, name)))
    seen = set()
    unique: List[str] = []
    for p in collected:
        if p not in seen:
            seen.add(p)
            unique.append(p)
    return unique

def process_examples_clean(example_file_path: str):
    """
    Öffnet eine examples-JSON, prüft sie und listet alle .scad-Dateien in den
    dort referenzierten targetDirectories auf. Für jede Datei wird der absolute
    Pfad ausgegeben; darunter steht ein auskommentierter Löschbefehl.
    """
    if not os.path.exists(example_file_path):
        print("Cannot open file: " + example_file_path)
        return

    try:
        with open(example_file_path, "r", encoding="utf-8") as f:
            d = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Invalid JSON in {example_file_path}: {e}")
        return
    except OSError as e:
        print(f"Cannot open file '{example_file_path}': {e}")
        return

    if 'type' not in d or d['type'] != 'com.machineblocks.examples':
        print(f"No valid examples file: {example_file_path}")
        return

    if 'examples' not in d or not isinstance(d['examples'], list):
        print(f"No 'examples' list found in {example_file_path}")
        return

    for example in d['examples']:
        # targetDirectory relativ zur JSON-Datei -> zu absolutem Pfad auflösen
        target_dir_rel = example.get('targetDirectory', '')
        target_dir = os.path.abspath(os.path.join(example_file_path, '..', target_dir_rel))

        if not os.path.isdir(target_dir):
            print("Target directory does not exist (skip): " + target_dir)
            continue

        try:
            entries = os.listdir(target_dir)
        except OSError as e:
            print(f"Cannot list target directory '{target_dir}': {e}")
            continue

        scad_files = []
        for name in entries:
            full = os.path.join(target_dir, name)
            if os.path.isfile(full) and name.lower().endswith(".scad"):
                scad_files.append(os.path.abspath(full))

        if not scad_files:
            print("No .scad files found in: " + target_dir)
        else:
            for scad_path in sorted(scad_files):
                print(scad_path)
                # Zum Löschen einer Datei, folgende Zeile auskommentieren:
                # os.remove(scad_path)


def _handle_examples(args, unknown, usage_printer):
    if args.examples_cmd is None:
        if unknown:
            usage_printer(f"Error: unknown 'examples' subcommand '{unknown[0]}'.")
        usage_printer("Error: no 'examples' subcommand provided.")
        return

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

    elif args.examples_cmd == "clean":
        target_path = os.path.abspath(os.path.relpath(args.path, start=os.curdir))
        if not os.path.exists(target_path):
            print("Path does not exist: " + target_path)
        elif os.path.isfile(target_path):
            print("Cleaning targets for examples file: " + target_path)
            process_examples_clean(target_path)
        elif os.path.isdir(target_path):
            json_files = _collect_json_files_recursive(target_path)
            if not json_files:
                print("No JSON files to process in directory: " + target_path)
            else:
                for path in json_files:
                    print("Cleaning targets for examples file: " + path)
                    process_examples_clean(path)
        else:
            print("Unsupported path type: " + target_path)

    else:
        usage_printer(f"Error: unknown 'examples' subcommand '{args.examples_cmd}'.")


def register_examples(lvl1):
    p_examples = lvl1.add_parser(
        "examples",
        help="Work with example JSONs (render .scad files, etc.)."
    )
    ex_sub = p_examples.add_subparsers(dest="examples_cmd")

    p_ex_render = ex_sub.add_parser(
        "render",
        help="Render .scad files from a JSON file or recursively from all JSON files in a directory."
    )
    p_ex_render.add_argument(
        "path",
        help="Path to a JSON file or a directory that will be searched recursively for JSON files.",
        type=str,
    )

    # Neuer Subcommand: examples clean
    p_ex_clean = ex_sub.add_parser(
        "clean",
        help="List .scad files inside targetDirectories defined in an examples JSON (or all JSONs in a directory)."
    )
    p_ex_clean.add_argument(
        "path",
        help="Path to a JSON file or a directory that will be searched recursively for JSON files.",
        type=str,
    )

    p_examples.set_defaults(command_handler=_handle_examples)

