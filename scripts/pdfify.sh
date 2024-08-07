#!/usr/bin/env bash

gitRoot="$(git rev-parse --show-toplevel)"
destDir="$gitRoot/docs/pdfs"
imageDir="$gitRoot/docs/images"

set -e

files="$(find "$gitRoot/docs/cheatsheets" "$gitRoot/docs/checklists" -type f -iname '*.md')"
files="$(echo "$files" | grep -Piv '_template\.md$')"

mkdir -p "$destDir"

echo "$files" | while read -r src
do
	# TODO check if source image, md, or this script are newer than the pdf
	# otherwise, skip

	filename="$(basename "$src")"
	filename="${filename%%.*}"
	dirName="$(dirname "$src")"
	dirName="$(basename "$dirName")"
	outPath="$destDir/$filename.pdf"
	imageName="$(echo "$filename" | sed 's/_print_version//g')"
	imagePath="$imageDir/$imageName.png"
	dirImagePath="$imageDir/$dirName.png"
	if [[ ! -f "$imagePath" && -f "$dirImagePath" ]]
	then
		imagePath="$dirImagePath"
	fi

	# echo "imagePath: $imagePath"
	# echo "dirImagePath: $dirImagePath"


	if [[ ! ( "$src" -nt "$outPath" || "$imagePath" -nt "$outPath" ) ]]
	then
		continue
	fi

	# don't make pdfs of files that *also* have a print version
	if echo "$files" | grep -Fiq "${filename}_print_version.md"
	then
		continue
	fi

	docString="$(cat "$src")"
	# docString="${docString//..\/images\//$imageDir\/}"
	docString="$(echo "$docString" | perl -pe "s|(?<=\()(\.\./?)*?/images/|$imageDir/|g")"
	docString="$(echo "$docString" | perl -pe 's/<!-- (!\[header\].+?) -->/$1/g')"

	# determine what to use for newline replacement
	# guess whether or not we're replacing in a table and try to force line wrap instead
	# since regular newline will break a markdown table
	nl="\n"
	if echo "$docString" | grep -Fiq -- '---|---'
	then
		nl="                             "
	fi

	docString="$(echo "$docString" | perl -pe "s|<br ?/?>|$nl|g")"

	# hide spoilers
	docString="$(echo "$docString" | perl -pe "s|<details>.*?<summary>|[|g" | perl -pe 's|</summary>.+?</details>|]|g')"

	# add the header to the doc string if the file exists and it doesn't already contain one
	if [[ -f "$imagePath" ]] && ! echo "$docString" | grep -Fiq '![header]'
	then
		headerString="![header]($imagePath)\ "
		docString="$headerString"$'\n\n'"$docString"
	fi

	# can't go bigger than 20pt
 	fontsize="10pt"
	if echo "$docString" | grep -iq "pdfzoom"
	then
		fontsize="17pt"
		echo "big font: $filename"
	fi
	orientation="portrait"
	if echo "$docString" | grep -iq "pdflandscape"
	then
		orientation="landscape"
		echo "landscape: $filename"
	fi

	echo "$docString" | pandoc -f markdown+link_attributes+footnotes -t latex -o "$outPath" --pdf-engine=lualatex \
		   -V documentclass=extarticle -V fontsize="$fontsize" \
		   -V pagestyle=empty \
		   -V papersize=A4 \
		   -V geometry:top=1cm -V geometry:bottom=1.5cm \
		   -V geometry:top=1cm -V geometry:left=1.5cm \
		   -V geometry:top=1cm -V geometry:right=1.5cm \
		   -V geometry:"$orientation" \
		   -M lang=en

		   # -V geometry:mag=2000 \ # literally just defaults to zoomed in
		   # -V geometry:top=1cm -V geometry:bottom=2cm -V geometry:left=1cm -V geometry:right=1cm\

	# sucks
	# echo "$docString" | pandoc --from=gfm --to=pdf --output "$outPath" --pdf-engine=weasyprint
	# echo "$docString" | pandoc --from=gfm --to=pdf -t html --output "$outPath" --pdf-engine-opt="--zoom" --pdf-engine-opt="10"
done
