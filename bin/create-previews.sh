#!/bin/bash

#PATH_TO_OPENSCAD="C:/'Program Files'/OpenSCAD/openscad.exe"
PATH_TO_OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

echo
echo Creating preview images ...
echo

curDir=$(pwd)

cd "$(dirname "$0")"

find ../sets -name "*.scad" -print0 | while read -d $'\0' file
do
    "$PATH_TO_OPENSCAD" --o "${file/scad/png}" --imgsize 1600,1200 --autocenter "$file"
done

find ../examples -name "*.scad" -print0 | while read -d $'\0' file
do
    "$PATH_TO_OPENSCAD" --o "${file/scad/png}" --imgsize 1600,1200 --autocenter "$file"
done

cd $curDir
