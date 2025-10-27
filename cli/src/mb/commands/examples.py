import json
import os
import re
from typing import List

override_config_variables = """/* [Override Config] */
// Whether to override global config
overrideConfig=false;
// Scale of the brick
overrideScale = 1.0; // [0.1:0.1:128]

// Adjustment of base height
overrideBaseHeightAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of sides
overrideBaseSideAdjustment = -0.1; // [-10.0:0.1:10.0]
// Adjustment of wall thickness
overrideBaseWallThicknessAdjustment = -0.1; // [-10.0:0.1:10.0]
// Clamp thickness
overrideBaseClampThickness = 0.1; // [-10.0:0.1:10.0]

// Adjustment of tube X diameter
overrideTubeXDiameterAdjustment = -0.1; // [-10.0:0.1:10.0]
// Adjustment of tube Y diameter
overrideTubeYDiameterAdjustment = -0.1; // [-10.0:0.1:10.0]
// Adjustment of tube Z diameter
overrideTubeZDiameterAdjustment = -0.1; // [-10.0:0.1:10.0]

// Adjustment of hole X diameter
overrideHoleXDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]
// Adjustment of hole X inset thickness
overrideHoleXInsetThicknessAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole X inset depth
overrideHoleXInsetDepthAdjustment = 0.0; // [-10.0:0.1:10.0]

// Adjustment of hole Y diameter
overrideHoleYDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset thickness
overrideHoleYInsetThicknessAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of hole Y inset depth
overrideHoleYInsetDepthAdjustment = 0.0; // [-10.0:0.1:10.0]

// Adjustment of hole Z diameter
overrideHoleZDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]

// Adjustment of pin diameter
overridePinDiameterAdjustment = 0.0; // [-10.0:0.1:10.0]

// Adjustment of stud diameter
overrideStudDiameterAdjustment = 0.2; // [-10.0:0.1:10.0]
// Adjustment of stud height
overrideStudHeightAdjustment = 0.0; // [-10.0:0.1:10.0]
// Adjustment of stud hole diameter
overrideStudHoleDiameterAdjustment = 0.3; // [-10.0:0.1:10.0]
// Adjustment of stud cutout
overrideStudCutoutAdjustment = [0.2, 0.4]; // [-10.0:0.1:10.0]

// Whether to render in preview mode
overridePreviewRender = true;
// Quality of preview rendering
overridePreviewQuality = 0.5; // [0.1:0.1:1.0]

// Rounding resolution of final rendering
overrideRoundingResolution = 64; // [16:1:512]
"""

preset_params = """unitMbu=unitMbu,
unitGrid=unitGrid,
scale=overrideConfig ? overrideScale : scale,

baseHeightAdjustment=overrideConfig ? overrideBaseHeightAdjustment : baseHeightAdjustment,
baseWallThicknessAdjustment=overrideConfig ? overrideBaseWallThicknessAdjustment : baseWallThicknessAdjustment,
baseClampThickness=overrideConfig ? overrideBaseClampThickness : baseClampThickness,

tubeXDiameterAdjustment=overrideConfig ? overrideTubeXDiameterAdjustment : tubeXDiameterAdjustment,
tubeYDiameterAdjustment=overrideConfig ? overrideTubeYDiameterAdjustment : tubeYDiameterAdjustment,
tubeZDiameterAdjustment=overrideConfig ? overrideTubeZDiameterAdjustment : tubeZDiameterAdjustment,

holeXDiameterAdjustment=overrideConfig ? overrideHoleXDiameterAdjustment : holeXDiameterAdjustment,
holeXInsetThicknessAdjustment=overrideConfig ? overrideHoleXInsetThicknessAdjustment : holeXInsetThicknessAdjustment,
holeXInsetDepthAdjustment=overrideConfig ? overrideHoleXInsetDepthAdjustment : holeXInsetDepthAdjustment,

holeYDiameterAdjustment=overrideConfig ? overrideHoleYDiameterAdjustment : holeYDiameterAdjustment,
holeYInsetThicknessAdjustment=overrideConfig ? overrideHoleYInsetThicknessAdjustment : holeYInsetThicknessAdjustment,
holeYInsetDepthAdjustment=overrideConfig ? overrideHoleYInsetDepthAdjustment : holeYInsetDepthAdjustment,

holeZDiameterAdjustment=overrideConfig ? overrideHoleZDiameterAdjustment : holeZDiameterAdjustment,

pinDiameterAdjustment=overrideConfig ? overridePinDiameterAdjustment : pinDiameterAdjustment,

studDiameterAdjustment=overrideConfig ? overrideStudDiameterAdjustment : studDiameterAdjustment,
studHeightAdjustment=overrideConfig ? overrideStudHeightAdjustment : studHeightAdjustment,
studHoleDiameterAdjustment=overrideConfig ? overrideStudHoleDiameterAdjustment : studHoleDiameterAdjustment,
studCutoutAdjustment=overrideConfig ? overrideStudCutoutAdjustment : studCutoutAdjustment,

previewRender=overrideConfig ? overridePreviewRender : previewRender,
previewQuality=overrideConfig ? overridePreviewQuality : previewQuality,

baseRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
holeRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
studRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution,
pillarRoundingResolution=overrideConfig ? overrideRoundingResolution : roundingResolution"""

base_variables = """// Color of the brick
baseColor = "#EAC645"; // [#58B99D:Turquoise, #4A9E86:Green Sea, #65C97A:Emerald, #55AB68:Nephritis, #5296D5:Peter River, #437EB4:Belize Hole, #925CB1:Amethyst, #8548A8:Wisteria, #38485C:Wet Asphalt, #303D4E:Midnight Blue, #EAC645:Sun Flower, #E7A03C:Orange, #D4813A:Carrot, #C05A23:Pumpkin, #D65745:Alizarin, #B14434:Pomegranate, #EDF0F1:Clouds, #BEC3C6:Silver, #98A4A6:Concrete, #98A4A6:Asbestos]
surfacePatternScale = 0.2; // [0:0.001:1]
surfacePattern = "none"; // [none:None, ../pattern/honeycombs.svg:Honeycombs, ../pattern/squares.svg:Squares, ../pattern/squares-diagonal.svg:Squares Diagonal, ../pattern/diamonds.svg:Diamonds, ../pattern/textile.svg:Textile, ../pattern/card-background.svg:Card Background, ../pattern/dots.svg:Dots, ../pattern/circuit-board.svg:Circuit Board]"""

base_params = """baseColor = baseColor,
surfacePattern = surfacePattern,
surfacePatternScale = surfacePatternScale,"""

stud_variables = """// Whether to render icons on the studs
studIcon = "../pattern/bolt-solid-full.svg"; // [none:None, ../pattern/anchor-solid-full.svg:Anchor, ../pattern/bell-solid-full.svg:Bell, ../pattern/bolt-solid-full.svg:Bolt, ../pattern/bomb-solid-full.svg:Bomb, ../pattern/bullhorn-solid-full.svg:Bullhorn, ../pattern/car-side-solid-full.svg:CarSide, ../pattern/car-solid-full.svg:Car, ../pattern/cat-solid-full.svg:Cat, ../pattern/certificate-solid-full.svg:Certificate, ../pattern/circle-radiation-solid-full.svg:CircleRadiation, ../pattern/circle-solid-full.svg:Circle, ../pattern/diamond-solid-full.svg:Diamond, ../pattern/dog-solid-full.svg:Dog, ../pattern/earth-americas-solid-full.svg:EarthAmericas, ../pattern/face-flushed-solid-full.svg:FaceFlushed, ../pattern/face-grin-hearts-solid-full.svg:FaceGrinHearts, ../pattern/face-laugh-solid-full.svg:FaceLaugh, ../pattern/face-smile-solid-full.svg:FaceSmile, ../pattern/fish-solid-full.svg:Fish, ../pattern/flag-solid-full.svg:Flag, ../pattern/flask-solid-full.svg:Flask, ../pattern/football-solid-full.svg:Football, ../pattern/frog-solid-full.svg:Frog, ../pattern/futbol-solid-full.svg:Futbol, ../pattern/ghost-solid-full.svg:Ghost, ../pattern/graduation-cap-solid-full.svg:GraduationCap, ../pattern/hand-middle-finger-solid-full.svg:HandMiddleFinger, ../pattern/hand-solid-full.svg:Hand, ../pattern/heart-solid-full.svg:Heart, ../pattern/horse-head-solid-full.svg:HorseHead, ../pattern/key-solid-full.svg:Key, ../pattern/leaf-solid-full.svg:Leaf, ../pattern/lightbulb-solid-full.svg:Lightbulb, ../pattern/microphone-solid-full.svg:Microphone, ../pattern/moon-solid-full.svg:Moon, ../pattern/plane-solid-full.svg:Plane, ../pattern/plug-solid-full.svg:Plug, ../pattern/poo-solid-full.svg:Poo, ../pattern/puzzle-piece-solid-full.svg:PuzzlePiece, ../pattern/robot-solid-full.svg:Robot, ../pattern/rocket-solid-full.svg:Rocket, ../pattern/sack-dollar-solid-full.svg:SackDollar, ../pattern/skull-solid-full.svg:Skull, ../pattern/square-solid-full.svg:Square, ../pattern/star-solid-full.svg:Star, ../pattern/thumbs-down-solid-full.svg:ThumbsDown, ../pattern/thumbs-up-solid-full.svg:ThumbsUp, ../pattern/tooth-solid-full.svg:Tooth, ../pattern/tree-solid-full.svg:Tree, ../pattern/trophy-solid-full.svg:Trophy]"""

stud_params = """studIcon = studIcon,"""

hidden_params = """bSideAdjustment = overrideConfig ? overrideBaseSideAdjustment : baseSideAdjustment;"""

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
            scad = scad.replace('/*{OVERRIDE_CONFIG_VARIABLES}*/', override_config_variables)
            scad = scad.replace('/*{PRESET_PARAMETERS}*/', preset_params)
            scad = scad.replace('/*{HIDDEN_PARAMETERS}*/', hidden_params)
            scad = scad.replace('/*{BASE_VARIABLES}*/', base_variables)
            scad = scad.replace('/*{BASE_PARAMETERS}*/', base_params)
            scad = scad.replace('/*{STUD_VARIABLES}*/', stud_variables)
            scad = scad.replace('/*{STUD_PARAMETERS}*/', stud_params)
            scad = scad.replace('/*{IMPORTS}*/', "use <" + d['config']['lib'] + "/block.scad>;\ninclude <" + d['config']['presets'] + ">;\n")

            for param in brick['parameters']:
                val = brick['parameters'][param]
                if isinstance(val, str):
                    try:
                        print('Replaced string param ' + param + ' with value: ' + val)
                    except UnicodeEncodeError:
                        print('Replaced string param ' + param + ' with unicode value')
                    scad = re.sub(param + r'\s*=\s*\"[a-zA-Z0-9\.\-_\s]*\"\s*;', param + ' = "' + val + '";', scad)
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
    
    print(f"Processing {d['name']} ...")

    for example in d['examples']:
        # targetDirectory relativ zur JSON-Datei -> zu absolutem Pfad auflösen
        target_dir_rel = example.get('targetDirectory', '')
        target_dir = os.path.abspath(os.path.join(example_file_path, '..', target_dir_rel))

        if not os.path.isdir(target_dir):
            print("[examples/clean] Target directory does not exist (skip): " + target_dir)
            continue

        try:
            entries = os.listdir(target_dir)
        except OSError as e:
            print(f"[examples/clean] Cannot list target directory '{target_dir}': {e}")
            continue

        scad_files = []
        for name in entries:
            full = os.path.join(target_dir, name)
            if os.path.isfile(full) and name.lower().endswith(".scad"):
                scad_files.append(os.path.abspath(full))

        print(f"[examples/clean] Found {len(scad_files)} .scad files to delete in {target_dir} and subdirectories.")

        if not scad_files:
            print("[examples/clean] No .scad files found in: " + target_dir)
        else:
            for scad_path in sorted(scad_files):
                os.remove(scad_path)
                print(f"[examples/clean] Deleted {scad_path}")

        print(f"[examples/clean] Deleted {len(scad_files)} .scad files in {target_dir} and subdirectories.")
        print(f"[thumbnails/clean] DONE - Have a nice day!")

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

