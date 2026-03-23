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

    tempDirSet="$tempDir/$iCharSet"
    mkdir -p "$tempDirSet"

    iChar=0
    for c in "${chars[@]}"; do

        magick -size ${cell_w}x${cell_h} xc:white \
            -font "$optNewFont" \
            -pointsize $pointsize \
            -gravity center \
            -annotate 0 "$c" \
            -stroke black -strokewidth 1 -fill none -draw "rectangle 0,0 $((cell_w-1)),$((cell_h-1))" \
            "$tempDirSet/control_$(printf '%02d' "$iChar").png"

        magick -size ${cell_w}x${cell_h} xc:white \
            -font "$optControlFont" \
            -pointsize $pointsize \
            -gravity center \
            -annotate 0 "$c" \
            -stroke black -strokewidth 1 -fill none -draw "rectangle 0,0 $((cell_w-1)),$((cell_h-1))" \
            "$tempDirSet/new_$(printf '%02d' "$iChar").png"

        iChar=$((iChar+1))
    done

    if [[ -f "$tempOutPath" ]]
    then
        tempOutPathIfExists=("$tempOutPath")
    else
        tempOutPathIfExists=()
    fi

    # put the chars together into one row
    magick "$tempDirSet/control_"*.png \
        +append \
        "$tempDirSet/control_row.png"

    # put the chars together into one row
    magick "$tempDirSet/new_"*.png \
        +append \
        "$tempDirSet/new_row.png"
    
    # compare current new row and previous new row here
    # if they match, don't add
    # this removes the lower case line for languages with no separate lowercase letters
    skipachu=0
    if [[ "$iCharSet" == 1 ]]
    then
        firstRowNewPath="$tempDir/0/control_row.png"
        percDiff="$(magick compare -trim -colorspace gray "$tempDirSet/control_row.png" "$firstRowNewPath" null: 2>&1 | grep -iPo '(?<=\()[\d\.\-]+(?=\))' || true)"

        # skip if difference is < 10%
        # vorlon and minecraft sga both report < 8% difference, no clue why
        if [[ "$(echo "$percDiff < 0.1" | bc -l)" == 1 ]]
        then
            skipachu=1
        fi
    fi

    # mash the rows onto the output image
    if [[ "$skipachu" == 0 ]]
    then
        magick \
            "${tempOutPathIfExists[@]}" \
            "$tempDirSet/control_row.png" \
            "$tempDirSet/new_row.png" \
            -append \
            "$tempOutPath"
    fi

    iCharSet=$((iCharSet+1))
done

mv "$tempOutPath" "$optOutPath"
rm -r "$tempDir"

# echo "optOutPath: $optOutPath"


