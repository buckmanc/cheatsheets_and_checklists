#!/usr/bin/env bash

set -e

for arg in "$@"
do
    if [[ -z "$optControlFont" ]]
    then
        optControlFont="$arg"
    elif [[ -z "$optNewFont" ]]
    then
        optNewFont="$arg"
    elif [[ -z "$optOutPath" ]]
    then
        optOutPath="$arg"
    else
        echo "I have no idea what $arg means"
        exit 1
    fi


done


pointsize=48
padding=20

chars=( {A..Z} {a..z} {0..9} )
cols=${#chars[@]}
# rows=2

tempDir="$TEMP/font_comparison"
mkdir -p "$tempDir"

measure() {
    magick -font "$1" -pointsize $pointsize label:W \
        -format "%w %h" info:
}

read w1 h1 <<< "$(measure "$optNewFont")"
read w2 h2 <<< "$(measure "$optControlFont")"

cell_w=$(( (w1 > w2 ? w1 : w2) + padding ))
cell_h=$(( (h1 > h2 ? h1 : h2) + padding ))

i=0
for c in "${chars[@]}"; do

    magick -size ${cell_w}x${cell_h} xc:white \
        -font "$optNewFont" \
        -pointsize $pointsize \
        -gravity center \
        -annotate 0 "$c" \
        -stroke black -strokewidth 1 -fill none -draw "rectangle 0,0 $((cell_w-1)),$((cell_h-1))" \
        "$tempDir/control_$(printf '%02d' "$i").png"

    magick -size ${cell_w}x${cell_h} xc:white \
        -font "$optControlFont" \
        -pointsize $pointsize \
        -gravity center \
        -annotate 0 "$c" \
        -stroke black -strokewidth 1 -fill none -draw "rectangle 0,0 $((cell_w-1)),$((cell_h-1))" \
        "$tempDir/new_$(printf '%02d' "$i").png"

    i=$((i+1))
done

magick montage "$tempDir/control_"*.png \
    -tile ${cols}x1 \
    -geometry +0+0 \
    "$tempDir/control_row.png"

magick montage "$tempDir/new_"*.png \
    -tile ${cols}x1 \
    -geometry +0+0 \
    "$tempDir/new_row.png"

magick montage \
    "$tempDir/control_row.png" \
    "$tempDir/new_row.png" \
    -tile 1x2 \
    -geometry +0+0 \
    "$optOutPath"

rm -r "$tempDir"

echo "optOutPath: $optOutPath"


