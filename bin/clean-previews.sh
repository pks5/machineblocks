#!/bin/bash

echo
echo Removing preview images ...
echo

curDir=$(pwd)

cd "$(dirname "$0")"

find ../sets -name "*.png" -print0 | while read -d $'\0' file
do
    rm "${file}"
done

find ../examples -name "*.png" -print0 | while read -d $'\0' file
do
    rm "${file}"
done

cd $curDir
