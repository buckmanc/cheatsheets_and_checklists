#!/usr/bin/env bash

gitRoot="$(git rev-parse --show-toplevel)"

templateString="$(cat "$gitRoot/docs/index_template.md")"

baseToc="$(tree docs/ --prune --noreport -H 'docs/' | \
perl -00pe 's/(^.+<\/h1><p>|<hr>.+$)//sg' | \
sed 's/[└─├│ ]/ /g' | \
perl -pe 's/&nbsp;/ /g' | \
sed 's/^\t    //g' | \
grep -Piv 'index(_template)?\.md' | \
grep -Piv '/images/' | \
grep -Piv '/drafts/' | \
grep -Piv '^\s*$' | \
tail -n +2 | \
perl -pe 's/^( *)/$1- /g' | \
perl -pe 's|/+|/|g' | \
perl -pe 's|\.md(</a>)|$1|g' | \
perl -pe 's|<a href.+?/">([^<]+)</a>|$1|g')"

indexToc="$(echo "$baseToc" | perl -pe 's|docs/||g' | perl -pe 's/\.md"/"/g')"

readmeString="${templateString/\{table_of_contents\}/$baseToc}"
indexString="${templateString/\{table_of_contents\}/$indexToc}"
echo "$readmeString" > "$gitRoot/readme.md"
echo "$indexString" > "$gitRoot/docs/index.md"

