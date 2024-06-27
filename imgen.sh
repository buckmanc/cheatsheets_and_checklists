#!/usr/bin/env bash

gitRoot="$(git rev-parse --show-toplevel)"
destDir="$gitRoot/docs/images"
sourceDir="$gitRoot/source_images"
tempPath="$destDir/temp.png"
basePath="$destDir/base.png"
width=2000
height=200
designHeight=$((height*75/100))
designMargin=$(((height-designHeight)/2))

centerTrimPath="$HOME/bin/centertrim"

mkdir -p "$destDir"

# TODO scoot the gradient center right
# TODO reduce the size of the gradient portion, leaving more solid color on the left
convert -alpha on -background none -size "${width}x$height" -define gradient:angle=90 gradient:#AAAAAA-none "PNG64:$basePath"

# convert \( -size "${width}x${height}" "xc:$defaultColor" \) "$tempPath" -compose CopyOpacity -composite "PNG64:$tempPath"

make_header()
{
	inPath="$1"
	outPath="$2"

	if [[ ! -f "$inPath" ]]
	then
		echo "source image missing: $(basename "$inPath")"
		exit 1
	elif [[ -f "$destDir/$outPath" ]]
	then
		return
	fi
	inPathExt="${inPath##*.}"
	inPathExt="${inPathExt,,}"
	if [[ "$inPathExt" == "svg" ]]
	then
		rsvg-convert --keep-aspect-ratio --background-color transparent --width "1000" --format png --output "$tempPath" -- "$inPath" 
		inPath="$tempPath"
	fi

	# punch out shape in base
	# convert -background none -alpha on "$basePath" \( "$inPath" -alpha on -background none -resize "x$designHeight" -geometry +$designMargin+$designMargin \) -compose dst-out -composite "PNG64:$destDir/$outPath"

	# fill shape in black: this one doesn't work well
	# convert -background none -alpha on "$basePath" \( "$inPath" -alpha on -background none -resize "x$designHeight" -geometry +$designMargin+$designMargin \) -fill black -composite "PNG64:$destDir/$outPath"

	convert \( -size "1000x1000" "xc:black" \) "$inPath" -resize "1000x1000" -gravity center -compose CopyOpacity -composite "PNG64:$tempPath"

	# thanks Fred
	# https://www.fmwconcepts.com/imagemagick/centertrim/index.php
	if [[ -f "$centerTrimPath" ]]
	then
		"$centerTrimPath" "$tempPath" "$tempPath"
	fi

	convert -background none -alpha on "$basePath" \( "$tempPath" -alpha on -background none -resize "x$designHeight" -geometry +$designMargin+$designMargin \) -composite "PNG64:$destDir/$outPath"
}

make_header "$sourceDir/caffeine_wikipedia.svg" "caffeine.png"
make_header "$sourceDir/hourglass-svgrepo-com.svg" "world_history_timeline.png"
make_header "$sourceDir/walkie-talkie-svgrepo-com.svg" "nato_alphabet.png"
make_header "$sourceDir/bucket_thicc.png" "bucket_list_games.png"
make_header "$sourceDir/Hard-drive_wikimedia.svg" "linux_new_drive_steps.png"
make_header "$sourceDir/Printable_ASCII_characters_wikimedia.svg" "ascii.png"
make_header "$sourceDir/ten_commandments.png" "ten_commandments.png"
if [[ -f "$tempPath" ]]
then
	rm "$tempPath"
fi

if [[ -f "$basePath" ]]
then
	rm "$basePath"
fi
