import json
import os
import re
import argparse

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

if __name__ == "__main__":
    parser = argparse.ArgumentParser("create-examples")
    # Make example_file optional so --examples_dir alleine funktioniert
    parser.add_argument("example_file", nargs="?", help="A JSON file with examples to create.", type=str)
    parser.add_argument("--examples_dir", "-d", help="A directory containing JSON files with examples to create.", type=str)
    args = parser.parse_args()

    if not args.example_file and not args.examples_dir:
        parser.error("You must provide either example_file or --examples_dir.")

    files_to_process = []

    if args.example_file:
        example_file_path = os.path.abspath(os.path.relpath(args.example_file, start=os.curdir))
        files_to_process.append(example_file_path)

    if args.examples_dir:
        examples_dir_path = os.path.abspath(os.path.relpath(args.examples_dir, start=os.curdir))
        if not os.path.isdir(examples_dir_path):
            print("examples_dir is not a directory: " + examples_dir_path)
        else:
            # Alle .json Dateien (nicht rekursiv)
            for name in sorted(os.listdir(examples_dir_path)):
                if name.lower().endswith(".json"):
                    files_to_process.append(os.path.join(examples_dir_path, name))

    # Duplikate entfernen (z.B. gleicher Pfad zweimal angegeben)
    seen = set()
    unique_files = []
    for p in files_to_process:
        ap = os.path.abspath(p)
        if ap not in seen:
            seen.add(ap)
            unique_files.append(ap)

    if not unique_files:
        print("No JSON files to process.")
    else:
        for path in unique_files:
            print("Processing examples file: " + path)
            process_examples_file(path)
