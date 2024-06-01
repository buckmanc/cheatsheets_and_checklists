#!/usr/bin/env bash

gitRoot="$(git rev-parse --show-toplevel)"

templateString="$(cat "$gitRoot/docs/index_template.md")"
toc="$(tree "docs/" --prune --noreport | tail -n +2 | sed 's/[└─├│ ]/ /g' | sed 's/^ \{4\}//g' | grep -Piv '^(index\.md|index_template\.md)$')"
templateString="${templateString/\{table_of_contents\}/$toc}"
echo "$templateString" > "$gitRoot/readme.md"
echo "$templateString" > "$gitRoot/docs/index.md"

