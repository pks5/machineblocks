import json
import os 
import re
import argparse

parser = argparse.ArgumentParser("create-examples")
parser.add_argument("example_file", help="A JSON file with examples to create.", type=str)
args = parser.parse_args()

#dir_path = os.path.dirname(os.path.realpath(__file__))
#example_file_path = os.path.abspath(os.path.join(dir_path, args.example_file))

example_file_path = os.path.abspath(os.path.relpath(args.example_file, start=os.curdir))

if(not os.path.exists(example_file_path)):
    print("Cannot open file: " + example_file_path)
    exit(0)

with open(example_file_path) as f:
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
        for param in brick['parameters']:
            val = brick['parameters'][param]
            if(isinstance(val, str)):
                print('Replaced string param ' + param + ' with value ' + str(val))
                scad = re.sub(param + r'\s*=\s*\"[a-zA-Z0-9\.\-_\s]+\"\s*;', param + ' = "' + str(val) + '";', scad)
            elif(isinstance(val, bool)):
                print('Replaced bool param ' + param + ' with value ' + str(val).lower())
                scad = re.sub(param + r'\s*=\s*((true)|(false))\s*;', param + ' = ' + str(val).lower() + ';', scad)
            elif(isinstance(val, int)):
                print('Replaced integer param ' + param + ' with value ' + str(val))
                scad = re.sub(param + r'\s*=\s*[0-9\.]+\s*;', param + ' = ' + str(val) + ';', scad)
            
        f = open(target_dir + "/" + file_name, "w")
        f.write(scad)
        f.close()
        print("Wrote " + file_name)