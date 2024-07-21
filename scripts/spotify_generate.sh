#!/usr/bin/env bash

# app link example
# spotify:playlist:5H33qeoCtEfYlWfct5La2N

# TODO find a way to not update images unless they've changed

gitRoot="$(git rev-parse --show-toplevel)"

imageDestDir="$gitRoot/docs/images/spotify"
files="$(find "$gitRoot/docs/" -type f -iname "*_template.md" | grep -Pi '(spotify|playlist)')"

if [[ -z "$files" ]]
then
	echo "no files found"
	exit 1
fi

mkdir -p "$imageDestDir"

while read -r src
do
	filename="$(basename "$src")"
	echo
	echo "found file $filename"

	fileText="$(cat "$src")"
	outPath="$(echo "$src" | perl -pe 's/_template//g')"
	urls="$(echo "$fileText" | grep -iPo 'https?://(www\.)?(open\.)?spotify\.com/playlist\S+')"

	# https://open.spotify.com/playlist/5mM1MjgcOBJcQfVlqWG9FJ?si=VpS-YIxtS_qeXLH4lcMmWg&pt=175b5dcb375fdbd7cd77083e52350436

	if [[ -z "$urls" ]]
	then
		echo "no urls found"
		continue
	fi

	while read -r url
	do

		echo "found url $url" | cut -c -"$COLUMNS"

		source="$(curl --silent "$url")"
		id="$(echo "$url" | grep -iPo "(?<=/)[a-zA-Z0-9]+(?=(\?|\s|$))")"
		appLink="spotify:playlist:$id"

		# echo "$source" > source.html
		thumbnailPathLocal="$imageDestDir/$id.png"

		thumbnailUrl="$(echo "$source" | grep -iPo '[^"]+(mosaic|image-cdn)[^"]+/[^"]+' | head -n 1)"
		desc="$(echo "$source" | grep -iPo 'description.+?content="[^"]+' | grep -iPo '(?<=content=").+' | head -n1)"
		desc1="$(echo "$desc" | grep -iPo '^.+?(?= . playlist)')"
		desc2="$(echo "$desc" | grep -iPo '(?<= playlist . ).+?$' | perl -pe 's/ \· /<br\/>/g')"

		# TODO transform to relative path
		thumbnailPathMd="${thumbnailPathLocal//$gitRoot\/docs/..}"

		echo "thumbnailUrl: $thumbnailUrl" | cut -c -"$COLUMNS"

		curl --silent "$thumbnailUrl" --output "$thumbnailPathLocal"
		if [[ ! -f "$thumbnailPathLocal" ]]
		then
			echo "failed to download thumbnail"
			# continue
			exit 1
		fi
		convert -resize '150x150' "$thumbnailPathLocal" "$thumbnailPathLocal"

		mdOut="[![playlist thumbnail]($thumbnailPathMd)]($appLink)|[$desc1]($url)|$desc2"
		fileText="${fileText//$url/$mdOut}"


	done < <( echo "$urls" )

	echo "$fileText" > "$outPath"

done < <( echo "$files" )
