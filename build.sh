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

"$gitRoot/update_index.sh"
# "$gitRoot/spotify_generate.sh"

mkdir -p "$gitRoot/docs/html"

pandoc --from gfm --to html --standalone --metadata title="" --metadata pagetitle="new tab" "$gitRoot/docs/links/new_tab_page.md" --output "$gitRoot/docs/html/new_tab_page_simple.html"
mkdocs build --config-file "$gitRoot/mkdocs.yml"
