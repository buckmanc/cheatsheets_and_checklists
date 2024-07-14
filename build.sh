#!/usr/bin/env bash

gitRoot="$(git rev-parse --show-toplevel)"

# TODO check for changes first?

pipages="$(pip list)"

if ! echo "$pipages" | grep -Piq '^mkdocs\s'
then
	pip install mkdocs
fi

if ! echo "$pipages" | grep -Piq '^pymdown-extensions\s'
then
	pip install pymdown-extensions
fi

# if ! echo "$pipages" | grep -Piq '^mkdocs-minify-plugin\s'
# then
# 	pip install mkdocs-minify-plugin
# fi

"$gitRoot/update_index.sh"
# "$gitRoot/spotify_generate.sh"

mkdir -p "$gitRoot/docs/html"

newTabHtmlPath="$gitRoot/docs/html/new_tab_page_simple.html"
pandoc --from gfm --to html --standalone --metadata title="" --metadata pagetitle="new tab" "$gitRoot/docs/links/new_tab_page.md" --css "../css/new_tab_page_simple.css" --output "$newTabHtmlPath"
sed -e 's|/index\.md|/|g' -e 's/\.md"/"/g' -i "$newTabHtmlPath"

mkdocs build --config-file "$gitRoot/mkdocs.yml"
# htmlmin --remove-comments "$gitRoot/docs/html/new_tab_page_simple.html" "$gitRoot/site/html/new_tab_page_simple.html"
