#!/bin/bash

#PATH_TO_OPENSCAD="C:/Program Files/OpenSCAD/openscad.exe"
PATH_TO_OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

PATH_TO_MAGICK="magick"

DIR_SETS="../sets"
DIR_EXAMPLES="../examples"
DIR_CLASSIC="../examples/classic"
DIR_TECHNIC="../examples/technic"
DIR_BOXES="../examples/boxes"
DIR_TEXT="../examples/text"
DIR_CUSTOM="../examples/custom"
DIR_CORNER="../examples/corner"
DIR_SLANTED="../examples/slanted"

IMAGE_WIDTH=1200
IMAGE_HEIGHT=900
IMAGE_BORDER=30
IMAGE_WIDTH_FULL=$((IMAGE_WIDTH + 2 * IMAGE_BORDER))
IMAGE_HEIGHT_FULL=$((IMAGE_HEIGHT + 2 * IMAGE_BORDER))

declare -a arr=("$DIR_SLANTED" "$DIR_TEXT")

echo
echo Creating preview images ...
echo

curDir=$(pwd)

cd "$(dirname "$0")"

for i in "${arr[@]}"
do
   find "$i" -name "*.scad" -print0 | while read -d $'\0' file
        do
            label="$(basename ${file})"
            label=${label//-/ }
            label=${label/.scad/}

            "$PATH_TO_OPENSCAD" --o "${file/scad/png}" --csglimit 3000000 --imgsize ${IMAGE_WIDTH},${IMAGE_HEIGHT} --autocenter "$file"
            
            "$PATH_TO_MAGICK" \
             \( "${file/scad/png}" -fill '#000000d0' -pointsize 70 -gravity northeast -bordercolor '#e5e5ce' -border ${IMAGE_BORDER} -font 'RBNo3.1-Book' -annotate '+60 +60' 'STL' \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 35 -gravity northeast -font 'RBNo3.1-Book' -annotate '+60 +140' "3D printable" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 70 -gravity northwest -font 'RBNo3.1-Book' -annotate '+60 +60' "${label}" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 35 -gravity northwest -font 'RBNo3.1-Book' -annotate '+60 +140' "LEGO® compatible" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 70 -gravity southwest -font 'RBNo3.1-Book' -annotate '+60 +60' "MachineBlocks.com" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 35 -gravity southwest -font 'RBNo3.1-Book' -annotate '+60 +140' "generated with" \) \
             -layers flatten -quality 80 "${file/scad/webp}"

             rm "${file/scad/png}"
        done
done

cd $curDir
