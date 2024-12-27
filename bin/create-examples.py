import json
import os 
import re
dir_path = os.path.dirname(os.path.realpath(__file__))

file = open(dir_path + '/brick-template.scad', "r")
brick_template = file.read()
file.close()

with open(dir_path + '/examples.json') as f:
    d = json.load(f)

for example in d['examples']:
    target_dir = example['targetDirectory']
    url = example['url']

    for brick in example['bricks']:
        scad = brick_template.replace('{URL}', url)
        scad = scad.replace('{BRICK_NAME}', brick['name'])
        for param in brick['parameters']:
            val = brick['parameters'][param]
            if(isinstance(val, str)):
                print(param + ' is string param!')
                scad = re.sub(param + '\s*=\s*\"[a-zA-Z0-9\.\-_\s]+\"\s*;', param + ' = "' + str(val).lower() + '";', scad)
            elif(isinstance(val, bool)):
                print(param + ' is boolean param!')
                scad = re.sub(param + '\s*=\s*((true)|(false))\s*;', param + ' = ' + str(val).lower() + ';', scad)
            elif(isinstance(val, int)):
                print(param + ' is integer param!')
                scad = re.sub(param + '\s*=\s*[0-9\.]+\s*;', param + ' = ' + str(val) + ';', scad)
            
        f = open(target_dir + "/" + brick['name'].replace(' ', '-') + '.scad', "w")
        f.write(scad)
        f.close()