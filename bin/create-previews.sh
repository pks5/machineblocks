#!/bin/bash

PATH_TO_OPENSCAD="C:/Program Files/OpenSCAD/openscad.exe"
#PATH_TO_OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

PATH_TO_MAGICK="magick"

DIR_DOCS="../docs"
DIR_SETS="../sets"
DIR_EXAMPLES="../examples"
DIR_CLASSIC="../examples/classic"
DIR_TECHNIC="../examples/technic"
DIR_BOXES="../examples/boxes"
DIR_TEXT="../examples/text"
DIR_CUSTOM="../examples/custom"
DIR_CORNER="../examples/corner"
DIR_SLANTED="../examples/slanted"

IMAGE_WIDTH=2400
IMAGE_HEIGHT=1800
IMAGE_BORDER=60
IMAGE_WIDTH_FULL=$((IMAGE_WIDTH + 2 * IMAGE_BORDER))
IMAGE_HEIGHT_FULL=$((IMAGE_HEIGHT + 2 * IMAGE_BORDER))
IMAGE_WIDTH_HALF=$((IMAGE_WIDTH_FULL / 2))

declare -a arr=("$DIR_SETS" "$DIR_EXAMPLES")
#declare -a arr=("$DIR_BOXES")
#declare -a arr=("$DIR_CORNER")

echo
echo Creating preview images ...
echo

curDir=$(pwd)

cd "$(dirname "$0")"

for i in "${arr[@]}"
do
   find "$i" -name "*.scad" -print0 | while read -d $'\0' file
        do
            echo "Creating preview for ${file} ..."
            label="$(basename ${file})"
            label=${label//-/ }
            label=${label/.scad/}
            label=`python -c "print('${label}'.title())"`
            image_file="${file/scad/png}"

            "$PATH_TO_OPENSCAD" --o "$image_file" --p "preview-parameters.json" --P BestQuality --csglimit 3000000 --imgsize ${IMAGE_WIDTH},${IMAGE_HEIGHT} --autocenter "$file"
            
            "$PATH_TO_MAGICK" \
             \( "$image_file" -fill '#000000d0' -pointsize 140 -gravity northeast -bordercolor '#e5e5ce' -border ${IMAGE_BORDER} -font 'RBNo3.1-Book' -annotate '+120 +120' 'STL' \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 70 -gravity northeast -font 'RBNo3.1-Book' -annotate '+120 +280' "3D printable" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 140 -gravity northwest -font 'RBNo3.1-Book' -annotate '+120 +120' "${label}" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 70 -gravity northwest -font 'RBNo3.1-Book' -annotate '+120 +280' "LEGO® compatible" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 140 -gravity southwest -font 'RBNo3.1-Book' -annotate '+120 +120' "MachineBlocks" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 70 -gravity southwest -font 'RBNo3.1-Book' -annotate '+120 +280' "generated with" \) \
             -layers flatten -resize ${IMAGE_WIDTH_HALF} -quality 80 "${file/scad/webp}"

             rm "$image_file"
             echo "Created preview ${image_file} for scad file ${file}"
        done
done

cd $curDir
