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

tempDir="$TEMP/font_comparison"
tempOutPath="$tempDir/output.png"

mkdir -p "$tempDir"

measure() {
    magick -font "$1" -pointsize $pointsize label:W \
        -format "%w %h" info:
}

read w1 h1 <<< "$(measure "$optNewFont")"
read w2 h2 <<< "$(measure "$optControlFont")"

cell_w=$(( (w1 > w2 ? w1 : w2) + padding ))
cell_h=$(( (h1 > h2 ? h1 : h2) + padding ))

iCharSet=0
while [[ "$iCharSet" -le 2 ]]
do
    if [[ "$iCharSet" -eq 0 ]]
    then
        chars=( {A..Z} )
    elif [[ "$iCharSet" -eq 1 ]]
    then
        chars=( {a..z} )
    elif [[ "$iCharSet" -eq 2 ]]
    then
        chars=( {0..9} )
    fi

    iChar=0
    for c in "${chars[@]}"; do

        magick -size ${cell_w}x${cell_h} xc:white \
            -font "$optNewFont" \
            -pointsize $pointsize \
            -gravity center \
            -annotate 0 "$c" \
            -stroke black -strokewidth 1 -fill none -draw "rectangle 0,0 $((cell_w-1)),$((cell_h-1))" \
            "$tempDir/control_$(printf '%02d' "$iChar").png"

        magick -size ${cell_w}x${cell_h} xc:white \
            -font "$optControlFont" \
            -pointsize $pointsize \
            -gravity center \
            -annotate 0 "$c" \
            -stroke black -strokewidth 1 -fill none -draw "rectangle 0,0 $((cell_w-1)),$((cell_h-1))" \
            "$tempDir/new_$(printf '%02d' "$iChar").png"

        iChar=$((iChar+1))
    done

    if [[ -f "$tempOutPath" ]]
    then
        tempOutPathIfExists=("$tempOutPath")
    else
        tempOutPathIfExists=()
    fi

    magick "$tempDir/control_"*.png \
        +append \
        "$tempDir/control_row.png"

    magick "$tempDir/new_"*.png \
        +append \
        "$tempDir/new_row.png"

    # echo "tempOutPathIfExists: ${tempOutPathIfExists[*]}"
    # echo "tempOutPath: $tempOutPath"

    magick \
        "${tempOutPathIfExists[@]}" \
        "$tempDir/control_row.png" \
        "$tempDir/new_row.png" \
        -append \
        "$tempOutPath"

    rm "$tempDir/new_"*.png
    rm "$tempDir/control_"*.png
    iCharSet=$((iCharSet+1))
done

mv "$tempOutPath" "$optOutPath"
rm -r "$tempDir"

# echo "optOutPath: $optOutPath"


