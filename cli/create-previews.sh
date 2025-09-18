#!/bin/bash

#Parameters

PATH_TO_MAGICK="magick"

IMAGE_WIDTH=2400
IMAGE_HEIGHT=1800
IMAGE_BORDER=60

# END Parameters

# TODO Support Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
   PATH_TO_OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
else
   PATH_TO_OPENSCAD="C:/Program Files/OpenSCAD/openscad.exe"
fi

IMAGE_WIDTH_FULL=$((IMAGE_WIDTH + 2 * IMAGE_BORDER))
IMAGE_HEIGHT_FULL=$((IMAGE_HEIGHT + 2 * IMAGE_BORDER))
IMAGE_WIDTH_HALF=$((IMAGE_WIDTH_FULL / 2))

if [ "$#" -lt 1 ]; then
    echo "Usage: bash create-previews.sh [diretory1] [directory2] ..."
    exit 1
fi

curDir=$(pwd)

cd "$(dirname "$0")"

for i in "$@"
do
   echo
   echo "Creating preview images for folder '$i' ..."
   echo

   find "$i" -name "*.scad" -print0 | while read -d $'\0' file
        do
            echo "Creating preview for ${file} ..."
            label="$(basename ${file})"
            label=${label//-/ }
            label=${label/.scad/}
            label=`python -c "print('${label}'[:32].title())"`
            image_file="${file/scad/png}"

            "$PATH_TO_OPENSCAD" --o "$image_file" --p "preview-parameters.json" --P BestQuality --csglimit 3000000 --imgsize ${IMAGE_WIDTH},${IMAGE_HEIGHT} --autocenter "$file"
            
            "$PATH_TO_MAGICK" \
             \( "$image_file" -bordercolor '#e5e5ce' -border ${IMAGE_BORDER} \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 140 -gravity northwest -font 'RBNo3.1-Book' -annotate '+120 +120' "${label}" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 70 -gravity northwest -font 'RBNo3.1-Book' -annotate '+120 +290' "STL / 3MF Model" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 140 -gravity southwest -font 'RBNo3.1-Book' -annotate '+120 +120' "MachineBlocks" \) \
             \( -size ${IMAGE_WIDTH_FULL}x${IMAGE_HEIGHT_FULL} canvas:none -fill '#000000d0' -pointsize 70 -gravity southwest -font 'RBNo3.1-Book' -annotate '+120 +290' "generated with" \) \
             -layers flatten -resize ${IMAGE_WIDTH_HALF} -quality 80 "${file/scad/webp}"

             rm "$image_file"
             echo "Created preview ${image_file} for scad file ${file}"
        done
done

cd $curDir
