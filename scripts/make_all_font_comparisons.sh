#!/usr/bin/env bash

set -e

gitRoot="$(git rev-parse --show-toplevel)"
docsDir="$gitRoot/docs"
imageDir="$gitRoot/docs/images/fonts"
makePath="$gitRoot/scripts/make_font_comparison.sh"
pagePath="$gitRoot/docs/cheatsheets/swap_languages.md"
pageText="$(cat "$pagePath")"
localFontDir="$gitRoot/fonts"
fontFileTypeRegex="otf|ttf"

tempDlDir="$TEMP/font_dls"

sections="$(echo "$pageText" | perl -0777p -e 's/[\r\n]+/@/g;' -e 's/###/\n/g;'i | tail -n +2)"

# TODO make this better
controlFont="$(find "$HOME/.config/mintty" -type f -iname '*.ttf' | head -n1 || true)"

announcedTitle=0
title=''
announceTitle(){
	if [[ "$announcedTitle" == 0 ]]
	then
		echo "$title"
		announcedTitle=1
	fi
}

getFileName(){
	# use a regex to remove path and file extension
	echo "$1" | perl -p -e 's/^.+\///g;' -e 's/\.[a-zA-Z0-9]{3,4}$//g'
}
getSafeFontName(){
	echo "$1" | perl -p -e 's/[\. \[\]\(\)]/_/g;' -e 's/%\d[0-9a-zA-Z]/_/g;'
}
fontSort(){
	local input
	input="$(cat)"
	local criteria
	criteria="(bold|italic|itliac|wii)"

	echo "$input" | grep -viP "$criteria" | sort || true
	echo "$input" | grep  -iP "$criteria" | sort || true
}

# echo "sections: $sections"
# echo

while read -r section
do
	title="$(echo "$section" | grep -iPo "^.+?(?=@)")"
	fontLink="$(echo "$section" | grep -iPo '(?<=\()http.+?\.(otf|ttf|zip|font)(?=\))' | head -n1 || true)"

	if [[ -z "$fontLink" ]]
	then
		fontLink="$(echo "$section" | grep -iPo '(?<=\()http.+?(fontstruct).+?(?=\))' | head -n1 || true)"
	fi

	imageLink="$(echo "$section" | grep -iPo '(?<=\()[^\(]+?\.(png)(?=\))' | head -n1 || true)"
	imageFileName="$(basename "$imageLink")"
	imageFileName="${imageFileName%.*}"
	localFontPath=''
	imagePath=''
	fontName=''
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
		localFontPath="$(find "$localFontDir" -type f -iname "${imageFileName}*" -regextype posix-extended -iregex ".*\.($fontFileTypeRegex)$" | head -n1 || true)" 

		# otherwise, nothing we can do
		if [[ ! -f "$localFontPath" ]]
		then
			continue
		fi
	fi

	fontName="$(getFileName "$fontLink")"

	# if there's an image link, build the local image path
	if [[ -n "$imageLink" ]]
	then
		imagePath="$gitRoot/docs${imageLink}"
	# otherwise predict the path
	elif [[ -n "$fontName" ]]
	then
		imagePath="$imageDir/$(getSafeFontName "$fontName").png"
	fi

	# if there's a font but no image, make the image
	if [[ -n "$imagePath" && ! -f "$imagePath" ]] && [[ -n "$fontLink" || -n "$localFontPath" ]]
	then
		announceTitle
		# echo "title: $title"
		# echo "fontLink: $fontLink"
		# echo "imageLink: $imageLink"
		# echo "imagePath: $imagePath"

		mkdir -p "$tempDlDir"

		fontLinkExt="${fontLink##*.}"
		fontLinkExt="${fontLinkExt,,}"
		fontLinkDomain="$(echo "$fontLink" | grep -iPo '^(?:https?:\/\/)?(?:www\.)?\K([^\/\?]+)' || true)"
		
		# default referer
		fontReferer="https://$fontLinkDomain"

		tempFontPath="$tempDlDir/$fontName.$fontLinkExt"

		# use a local font if we have one, but prefer a linked one
		if [[ -z "$fontLink" && -f "$localFontPath" ]]
		then
			tempFontPath="$localFontPath"
		elif [[ "$fontLinkExt" =~ (zip|font) || "$fontLinkDomain" =~ (fontstruct\.com) ]]
		then

			# dafont support
			if [[ "$fontLinkExt" == "font" ]]
			then
				if [[ "$fontLinkDomain" == "dafont.com" ]]
				then
					fontDownloadLink="https://dl.${fontLinkDomain}/dl/?f=${fontName//-/_}"
				# elif [[ "$fontLinkDomain" == "fonts2u.com" ]]
				# then
				# fonts2u format is a halfway decent fallback
				else
					fontDownloadLink="https://${fontLinkDomain}/download/${fontName}.font"
				fi
			elif [[ "$fontLinkDomain" == "fontstruct.com" ]]
			then
				id="$(echo "$fontLink" | grep -iPo '(?<=/)\d+\b' || true)"

				if [[ -z "$id" ]]
				then
					echo "bad fontstruct id"
					exit 1
				fi

				fontDownloadLink="https://fontstruct.com/font_archives/download/$id/otf"
				fontReferer="https://fontstruct.com/fontstructions/download/$id"
			else
				fontDownloadLink="$fontLink"
			fi

			tempZipPath="$tempDlDir/font.zip"

			# echo "$fontDownloadLink"
			# echo "$fontLinkDomain"

			# dafont, fonts2u, and fontstruct all require referers of various sorts
			# all output zips
			curl --clobber --referer "$fontReferer" -s "$fontDownloadLink" -o "$tempZipPath"

			"$HOME/bin/xunzip" "$tempZipPath" > /dev/null
			tempFontPath="$(find "$tempDlDir" -type f -regextype posix-extended -iregex ".*\.($fontFileTypeRegex)$" | fontSort | head -n1 || true)"

			# update the font name and image path to match the actual font name inside the zip
			# UNLESS we got the path from section's imagelink
			# coz then we'll be stuck in a loop
			newFileName="$(getFileName "$tempFontPath")"
			if [[ ! "${newFileName,,}" =~ (font) && -z "$imageLink" ]]
			then
				fontName="$newFileName"
				imagePath="$imageDir/$(getSafeFontName "$fontName").png"
			fi
		else
			curl --clobber --referer "$fontReferer" -s "$fontLink" -o "$tempFontPath"
		fi

		# TODO hardcode specific charset exceptions here
		# like plain ol' numbers in some fonts

		# do work
		"$makePath" "$controlFont" "$tempFontPath" "$imagePath"

		rm -rf "$tempDlDir"
	fi

	# slap the link in the page
	if [[ -f "$imagePath" && -z "$imageLink" ]]
	then
		announceTitle

		imagePathWeb="${imagePath#$docsDir}"
		imageLine="[![${fontName}]($imagePathWeb)]($imagePathWeb)"
		
		lineNum="$(grep -n -Fi "### $title" "$pagePath" | cut -d: -f1 | head -n1)"
		lineNum=$((lineNum + 1))
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
