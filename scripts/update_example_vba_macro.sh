#!/usr/bin/env bash

set -e

gitRoot="$(git rev-parse --show-toplevel)"

# load templates
templatePath="$gitRoot/docs/cheatsheets/example_vba_macro_template.md"
outPath="$gitRoot/docs/cheatsheets/example_vba_macro.md"
xlsmPath="$gitRoot/docs/misc/ExampleMacro.xlsm"
fileName="$(basename "$xlsmPath")"
fileName="${fileName%.*}"
templateString="$(cat "$templatePath")"

tempDir="$TEMP"
tempCsvPath="$tempDir/${fileName}.csv"

if [[ "$outPath" -nt "$xlsmPath" ]]
then
	exit 0
fi

if ! type olevba > /dev/null 2>&1
then
	echo "olevba not installed; cannot update example_vba_macro.md"
	exit 0
elif ! type libreoffice > /dev/null 2>&1
then
	echo "libreoffice not installed; cannot update example_vba_macro.md"
	exit 0
elif ! type libreoffice > /dev/null 2>&1
then
	echo "pandoc not installed; cannot update example_vba_macro.md"
	exit 0
fi

echo "updating example_vba_macro.md"

# extract vba code
# remove headers / footers
# escape ampersands for bash string replacement
# trim blank lines
macroCode="$( \
	olevba --loglevel error --code "$xlsmPath" \
	| perl -pe 's/^(olevba|={3,}|\-{3,}|\- \- \- |VBA MACRO|in file:|FILE:|Type:|\(empty macro\)).*$//g' \
	| perl -pe 's/&/\\&/g' \
	| perl -0777pe 's/(^\s+|\s+$)//g' \
	)"

# convert xlsx file to csv
libreoffice --headless --convert-to csv --outdir "$tempDir" "$xlsmPath" > /dev/null
# convert csv to markdown table
spreadsheetTable="$(pandoc --from csv --to gfm "$tempCsvPath")"
rm "$tempCsvPath"

# populate file strings
templateString="${templateString/\{macro_code\}/$macroCode}"
templateString="${templateString/\{spreadsheet_table\}/$spreadsheetTable}"

# write files
echo "$templateString" > "$outPath"
