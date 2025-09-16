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

parser = argparse.ArgumentParser("create-examples")
parser.add_argument("example_file", help="A JSON file with examples to create.", type=str)
args = parser.parse_args()

#dir_path = os.path.dirname(os.path.realpath(__file__))
#example_file_path = os.path.abspath(os.path.join(dir_path, args.example_file))

example_file_path = os.path.abspath(os.path.relpath(args.example_file, start=os.curdir))

if(not os.path.exists(example_file_path)):
    print("Cannot open file: " + example_file_path)
    exit(0)

with open(example_file_path, "r", encoding="utf-8") as f:
    d = json.load(f)

for example in d['examples']:
    target_dir = os.path.abspath(os.path.join(example_file_path, '..', example['targetDirectory']))
    url = example['url']

    template_file_path = os.path.abspath(os.path.join(example_file_path, '..', example['template']))

    file = open(template_file_path, "r")
    brick_template = file.read()
    file.close()

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
            if(isinstance(val, str)):
                try:
                    print('Replaced string param ' + param + ' with value: ' + val)
                except(UnicodeEncodeError):
                    print('Replaced string param ' + param + ' with unicode value')
                    
                scad = re.sub(param + r'\s*=\s*\"[a-zA-Z0-9\.\-_\s]+\"\s*;', param + ' = "' + val + '";', scad)
            elif(isinstance(val, bool)):
                print('Replaced bool param ' + param + ' with value: ' + str(val).lower())
                scad = re.sub(param + r'\s*=\s*((true)|(false))\s*;', param + ' = ' + str(val).lower() + ';', scad)
            elif(isinstance(val, (int, float))):
                print('Replaced integer param ' + param + ' with value: ' + str(val))
                scad = re.sub(param + r'\s*=\s*((\"auto\")|([0-9\.\-]+))\s*;', param + ' = ' + str(val) + ';', scad)
            elif(isinstance(val, list)):
                print('Replaced list param ' + param + ' with value: ' + json.dumps(val))
                scad = re.sub(param + r'\s*=\s*((\[[\[\]0-9\.\,\s]*\])|(\"[a-zA-Z0-9\.\-_\s]+\")|([0-9\.\-]+)|((true)|(false)))\s*;', param + ' = ' + json.dumps(val) + ';', scad)
            else:
                print('Did not replace param ' + param + ': unknown type!')

        f = open(target_dir + "/" + file_name, "w", encoding="utf-8")
        f.write(scad)
        f.close()
        print("Wrote " + file_name)