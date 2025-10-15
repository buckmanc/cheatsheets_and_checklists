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

"$gitRoot/scripts/update_index.sh"
# "$gitRoot/scripts/spotify_generate.sh"

mkdir -p "$gitRoot/docs/html"

indexPath="$gitRoot/docs/index.md"
newTabHtmlPath="$gitRoot/docs/html/new_tab_page_simple.html"
newTabMdPath="$gitRoot/docs/links/new_tab_page.md"
bookmarksPagePath="$gitRoot/docs/links/bookmarks.md"
bookmarksExportPath="$gitRoot/docs/html/bookmarks_export.html"
exportScriptPath="$HOME/bin/export-bookmarks"

# rebuild the new tab html page if needed
if [[ "$newTabMdPath" -nt "$newTabHtmlPath" ]]
then
	pandoc --from gfm --to html --standalone --metadata title="" --metadata pagetitle="new tab" "$newTabMdPath" --css "../css/new_tab_page_simple.css" --output "$newTabHtmlPath" --include-in-header="$gitRoot/docs/html/pickstring.html" --wrap=preserve
	sed -e 's|/index\.md|/|g' -e 's/\.md"/"/g' -i "$newTabHtmlPath"
fi

# rebuild the bookmark export page if needed
if [[ "$newTabHtmlPath" -nt "$bookmarksExportPath" || "$bookmarksPagePath" -nt "$bookmarksExportPath" || "$bookmarksPagePath" -nt "$indexPath" ]] && [[ -x "$exportScriptPath" ]]
then
	"$exportScriptPath" \
		--url-override 'https://cheatsheets.buckman.cc/links/bookmarks/' "$bookmarksPagePath" \
		--url-override 'https://cheatsheets.buckman.cc/html/new_tab_page_simple.html' "$newTabHtmlPath" \
		--url-override 'https://cheatsheets.buckman.cc/' "$indexPath" \
		> "$bookmarksExportPath"
fi


mkdocs build --config-file "$gitRoot/mkdocs.yml"
# htmlmin --remove-comments "$gitRoot/docs/html/new_tab_page_simple.html" "$gitRoot/site/html/new_tab_page_simple.html"
