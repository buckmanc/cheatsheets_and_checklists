#!/usr/bin/env bash

set -e

gitRoot="$(git rev-parse --show-toplevel)"
imageDir="$gitRoot/docs/images/fonts"
makePath="$gitRoot/scripts/make_font_comparison.sh"
pagePath="$gitRoot/docs/cheatsheets/swap_languages.md"
pageText="$(cat "$pagePath")"
localFontDir="$gitRoot/fonts"
fontFileTypeRegex="otf|ttf"

tempDlDir="$TEMP/font_dls"

sections="$(echo "$pageText" | perl -0777p -e 's/[\r\n]+/@/g;' -e 's/##/\n/g;')"

# TODO make this better
controlFont="$(find "$HOME/.config/mintty" -type f -iname '*.ttf' -print)"

announcedTitle=0
title=''
announceTitle(){
	if [[ "$announcedTitle" == 0 ]]
	then
		echo "$title"
		announcedTitle=1
	fi
}

# echo "sections: $sections"
# echo

while read -r section
do
	title="$(echo "$section" | grep -iPo "^.+?(?=@)")"
	fontLink="$(echo "$section" | grep -iPo '(?<=\()http.+?\.(otf|ttf|zip)(?=\))' | head -n1 || true)"
	imageLink="$(echo "$section" | grep -iPo '(?<=\()[^\(]+?\.(png)(?=\))' | head -n1 || true)"
	imageFileName="$(basename "$imageLink")"
	imageFileName="${imageFileName%.*}"
	localFontPath=''
	announcedTitle=0

	# if there's no font link...
	if [[ -z "$fontLink" ]]
	then
		# echo "$title"
		# echo "imageLink: $imageLink"
		# echo "imageFileName: $imageFileName"
		
		# ...check for a local one
		# doing this by assuming the image is named after the font
		# therefore to use a local font, save it in the fonts dir and name the image link after it
		localFontPath="$(find "$localFontDir" -type f -iname "${imageFileName}*" -regextype posix-extended -iregex ".*\.($fontFileTypeRegex)$")" 

		# otherwise, nothing we can do
		if [[ ! -f "$localFontPath" ]]
		then
			continue
		fi
	fi

	# if there's an image link, build the local image path
	if [[ -n "$imageLink" ]]
	then
		imagePath="$gitRoot/docs${imageLink}"
	# otherwise predict the path
	else
		fontName="$(echo "$fontLink" | grep -iPo '[^/]+(?=\.[a-zA-Z]{3,4}$)')"
		imagePath="$imageDir/${fontName}.png"
	fi

	# if there's a font but no image, make the image
	if [[ ! -f "$imagePath" ]] && [[ -n "$fontLink" || -n "$localFontPath" ]]
	then
		announceTitle
		# echo "title: $title"
		# echo "fontLink: $fontLink"
		# echo "imageLink: $imageLink"

		mkdir -p "$tempDlDir"

		fontLinkExt="${fontLink##*.}"
		fontLinkExt="${fontLinkExt,,}"

		tempFontPath="$tempDlDir/font.$fontLinkExt"

		# use a local font if we have one, but prefer a linked one
		if [[ -z "$fontLink" && -f "$localFontPath" ]]
		then
			cp "$localFontPath" "$tempFontPath"
		elif [[ "$fontLinkExt" == "zip" ]]
		then
			tempZipPath="$tempDlDir/font.zip"
			curl --clobber -s "$fontLink" -o "$tempZipPath"
			"$HOME/bin/xunzip" "$tempZipPath"
			tempFontPath="$(find "$tempDlDir" -type f -regextype posix-extended -iregex ".*\.($fontFileTypeRegex)$")"
		else
			curl -s "$fontLink" -o "$tempFontPath"
		fi

		# do work
		"$makePath" "$controlFont" "$tempFontPath" "$imagePath"

		rm -rf "$tempDlDir"
	fi

	# slap the link in the page
	if [[ -f "$imagePath" && -z "$imageLink" ]]
	then
		announceTitle

		imageLine="[![${fontName}](/images/fonts/${fontName}.png)](/images/fonts/${fontName}.png)"
		
		lineNum="$(grep -n -Fi "## $title" "$pagePath" | cut -d: -f1)"
		lineNum=$((lineNum+1))
		sed -i "${lineNum}i §$imageLine" "$pagePath"
		perl -i -pe "s/§/\n/g;" "$pagePath"
		perl -i -pe "s/\r//g;" "$pagePath"
	fi

	if [[ -f "$imagePath" && -n "$imageLink" ]] && ! echo "$section" | grep -Fiq -- '[!['
	then
		announceTitle

		echo "markdown image link malformed!"
	fi

done < <(echo "$sections")
