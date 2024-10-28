#!/bin/bash

echo
echo Creating preview images ...
echo

curDir=$(pwd)

cd "$(dirname "$0")"

find ../sets -name "*.scad" -print0 | while read -d $'\0' file
do
    C:/'Program Files'/OpenSCAD/openscad --o "${file/scad/png}" --imgsize 1024,768 --autocenter "$file"
done

find ../examples -name "*.scad" -print0 | while read -d $'\0' file
do
    C:/'Program Files'/OpenSCAD/openscad --o "${file/scad/png}" --imgsize 1024,768 --autocenter "$file"
done

cd $curDir

#
