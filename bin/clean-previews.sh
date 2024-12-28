#!/bin/bash

echo
echo Removing preview images ...
echo

curDir=$(pwd)

cd "$(dirname "$0")"

find ../sets -name "*.webp" -print0 | while read -d $'\0' file
do
    rm "${file}"
done

find ../examples -name "*.webp" -print0 | while read -d $'\0' file
do
    rm "${file}"
done

cd $curDir
