#!/usr/bin/env bash

set -e

gitRoot="$(git rev-parse --show-toplevel)"
imageDir="$gitRoot/docs/images/fonts"
makePath="$gitRoot/scripts/make_font_comparison.sh"
pagePath="$gitRoot/docs/cheatsheets/swap_languages.md"
pageText="$(cat "$pagePath")"

tempDlDir="$TEMP/font_dls"

sections="$(echo "$pageText" | perl -0777p -e 's/[\r\n]+/@/g;' -e 's/##/\n/g;')"

# TODO make this better
controlFont="$(find "$HOME/.config/mintty" -type f -iname '*.ttf' -print)"

while read -r section
do

	title="$(echo "$section" | grep -iPo "^.+?(?=@)")"
	fontLink="$(echo "$section" | grep -iPo '(?<=\()http.+?\.(ttf|zip)(?=\))' | head -n1 || true)"
	imageLink="$(echo "$section" | grep -iPo '(?<=\()[^\(]+?\.(png)(?=\))' | head -n1 || true)"

	if [[ -z "$fontLink" ]]
	then
		continue
	fi

	if [[ -n "$imageLink" ]]
	then
		imagePath="$gitRoot/docs${imageLink}"
	else
		fontName="$(echo "$fontLink" | grep -iPo '[^/]+(?=\.[a-zA-Z]{3,4}$)')"
		imagePath="$imageDir/${fontName}.png"
	fi

	if [[ -f "$imagePath" ]]
	then
		continue
	fi

	echo "title: $title"
	echo "fontLink: $fontLink"
	echo "imageLink: $imageLink"

	mkdir -p "$tempDlDir"

	tempFontPath="$tempDlDir/font.ttf"

	if [[ "${fontLink,,}" == *.zip ]]
	then
		tempZipPath="$tempDlDir/font.zip"
		curl --clobber -s "$fontLink" -o "$tempZipPath"
		"$HOME/bin/xunzip" "$tempZipPath"
		tempFontPath="$(find "$tempDlDir" -type f -iname '*.ttf')"
	else
		curl -s "$fontLink" -o "$tempFontPath"
	fi

	"$makePath" "$controlFont" "$tempFontPath" "$imagePath"

	# slap the link in the page
	if [[ -z "$imageLink" ]]
	then
		imageLine="![${fontName}](/images/fonts/${fontName}.png)"
		
		lineNum="$(grep -n -Fi "## $title" "$pagePath" | cut -d: -f1)"
		lineNum=$((lineNum+1))
		sed -i "${lineNum}i $imageLine" "$pagePath"
		perl -i -pe "s/\r//g" "$pagePath"
	fi

	rm -rf "$tempDlDir"

done < <(echo "$sections")
