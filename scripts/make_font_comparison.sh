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
    elif [[ -z "$optCharDir" ]]
    then
        optCharDir="$arg"
    else
        echo "I have no idea what $arg means"
        exit 1
    fi
done

# echo "optControlFont: $optControlFont"
# echo "optNewFont: $optNewFont"
# echo "optOutPath: $optOutPath"
# echo "optCharDir: $optCharDir"

if [[ -z "$optControlFont" || -z "$optNewFont" || -z "$optOutPath" ]]
then
    echo "missing required args"
    exit 1
elif [[ ! -f "$optControlFont" || ! -f "$optNewFont" ]]
then
    echo "font files are missing:"
    echo "$optControlFont"
    echo "$optNewFont"
    exit 1
fi

newFontName="$(basename "$optNewFont")"
newFontName="${newFontName%.*}"

pointsize=48
charGenPointsize=400
padding=20

tempDir="$TEMP/font_comparison"
tempOutPath="$tempDir/output.png"

rm -rf "$tempDir"
mkdir -p "$tempDir"

measure() {
    # TODO test w upper and lower case
    # as fonts w o upper wont be sized right
    magick -font "$1" -pointsize "$2" label:W \
        -format "%w %h" info:
}

writeChar() {
    char="$1"
    charFont="$2"
    charOutPath="$3"

    # function passes error code of the last command within
    
    magick -size ${cell_w}x${cell_h} xc:white \
        -font "${charFont//%/}" \
        -pointsize $pointsize \
        -gravity center \
        -fill black \
        -annotate 0 "$char" \
        -stroke black -strokewidth 1 -fill none -draw "rectangle 0,0 $((cell_w-1)),$((cell_h-1))" \
        "$charOutPath"
}

getPercDiff(){
    magick compare -trim -colorspace gray "$1" "$2" null: 2>&1 | grep -iPo '(?<=\()[\d\.\-]+(?=\))' || true
}

read w1 h1 <<< "$(measure "$optNewFont" "$pointsize")"
read w2 h2 <<< "$(measure "$optControlFont" "$pointsize")"
if [[ -n "$optCharDir" ]]
then
    read wc1 hc1 <<< "$(measure "$optNewFont" "$charGenPointsize")"
fi

cell_w=$(( (w1 > w2 ? w1 : w2) + padding ))
cell_h=$(( (h1 > h2 ? h1 : h2) + padding ))

# basic behaviour
controlCharSetsStrings=("A..Z" "a..z" "0..9")
newCharSetsStrings=()

echo "font: $newFontName"

# specific sets for specific fonts
if [[ "$newFontName" =~ (TPHylian\-GCNRegular|ss\-ancient\-hylian\-sarinilli|sga_2|standard-galactic-alphabet|Dwemer|Falmer|Halo\ Covenant|GerudoTypography) ]]
then
    controlCharSetsStrings=("A..Z")
elif [[ "$newFontName" =~ (vykhya) ]]
then
    controlCharSetsStrings=("A..Z" "a..z")
elif [[ "$newFontName" =~ (Daedra|Clynese_Hand) ]]
then
    controlCharSetsStrings=("A..Z" "0..9")
elif [[ "$newFontName" =~ (FFXYevon|steelAlphabet_-_Aligned) ]]
then
    # use lowercase for the new font but upper for the old
    controlCharSetsStrings=("A..Z" "0..9")
    newCharSetsStrings=("a..z" "0..9")
fi

# default the new char set to match the control unless otherwise specified
if [[ "${#newCharSetsStrings[@]}" -eq 0 ]]
then
    newCharSetsStrings=("${controlCharSetsStrings[@]}")
fi

for iCharSet in "${!controlCharSetsStrings[@]}"
do

    controlChars=()
    newChars=()
    # gotta use eval to get the expansion syntax to work from a variable
    eval "controlChars=( {${controlCharSetsStrings[$iCharSet]}} )"
    eval "newChars=( {${newCharSetsStrings[$iCharSet]}} )"

    tempDirSet="$tempDir/$iCharSet"
    mkdir -p "$tempDirSet"

    for iChar in "${!controlChars[@]}"
    do

        # echo "line: $LINENO"
        # echo "iChar: $iChar"
        # echo "iCharSet: $iCharSet"
        echo -n "${newChars[$iChar]}"

        if ! writeChar "${newChars[$iChar]}" "$optNewFont" \
            "$tempDirSet/new_$(printf '%02d' "$iChar").png"
        then
            echo "font is missing char ${newChars[$iChar]}"
            continue
        elif [[ -n "$optCharDir" ]]
        then
            charFontDir="$optCharDir/$newFontName"
            mkdir -p "$charFontDir"

            magick \
                -size "$((wc1+padding))x$((hc1+padding))" xc:none \
                -fill white \
                -gravity center \
                -font "$optNewFont" \
                -pointsize "$charGenPointsize" \
                -annotate 0 "${newChars[$iChar]}" \
                "$charFontDir/${newChars[$iChar]}.png"

        fi

        writeChar "${controlChars[$iChar]}" "$optControlFont" \
            "$tempDirSet/control_$(printf '%02d' "$iChar").png"

        writeChar " " "$optControlFont" \
            "$tempDirSet/blank_$(printf '%02d' "$iChar").png"
    done
    
    if [[ -f "$tempOutPath" ]]
    then
        tempOutPathIfExists=("$tempOutPath")
    else
        tempOutPathIfExists=()
    fi

    # this will occur if the font doesn't have anything in this character set, ie no lowercase letters
    if ! ls "$tempDirSet/new_"*.png > /dev/null 2>&1
    then
        continue
    fi

    # put the chars together into one row
    magick "$tempDirSet/control_"*.png \
        +append \
        "$tempDirSet/control_row.png"

    # put the chars together into one row
    magick "$tempDirSet/new_"*.png \
        +append \
        "$tempDirSet/new_row.png"

    # put the chars together into one row
    magick "$tempDirSet/blank_"*.png \
        +append \
        "$tempDirSet/blank_row.png"
    
    # compare current new row and previous new row here
    # if they match, don't add
    # this removes the lower case line for languages with no separate lowercase letters
    skipachu=0
    if [[ "$iCharSet" -gt 0 ]]
    then
        firstRowNewPath="$tempDir/0/new_row.png"
        percDiff="$(getPercDiff "$tempDirSet/new_row.png" "$firstRowNewPath")"

        # skip if difference is < 10%
        # vorlon and minecraft sga both report < 8% difference, no clue why
        if [[ "$(echo "$percDiff < 0.1" | bc -l)" == 1 ]]
        then
            skipachu=1
        fi
    fi

    # compare to the blank row and skip if blank
    percDiff="$(getPercDiff "$tempDirSet/new_row.png" "$tempDirSet/blank_row.png")"

    if [[ "$(echo "$percDiff < 0.05" | bc -l)" == 1 ]]
    then
        skipachu=1
    fi

    # mash the rows onto the output image
    if [[ "$skipachu" == 0 ]]
    then
        magick \
            "${tempOutPathIfExists[@]}" \
            "$tempDirSet/new_row.png" \
            "$tempDirSet/control_row.png" \
            -append \
            "$tempOutPath"
    fi
done

echo

if [[ -f "$tempOutPath" ]]
then
    mv "$tempOutPath" "$optOutPath"
else
    magick -size 100x100 xc:white \
        -fill black \
        -gravity center \
        -font "$optControlFont" \
        caption:":(" \
        -flatten \
        "$optOutPath"
fi

rm -r "$tempDir"

# echo "optOutPath: $optOutPath"


