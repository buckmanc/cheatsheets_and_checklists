#!/usr/bin/env bash

gitRoot="$(git rev-parse --show-toplevel)"

# load templates
indexTemplateString="$(cat "$gitRoot/docs/index_template.md")"
pdfTemplateString="$(cat "$gitRoot/docs/pdfs/pdfs_template.md")"

# populate tables of contents
baseToc="$(tree "$gitRoot/docs/" -P '*.md' --filesfirst --prune --noreport -H 'docs/' | \
perl -00pe 's/(^.+<\/h1><p>|<hr>.+$)//sg' | \
sed 's/[└─├│ ]/ /g' | \
perl -pe 's/&nbsp;/ /g' | \
sed 's/^\t    //g' | \
grep -Piv 'index.md' | \
grep -Piv '_(template|print_version).md' | \
grep -Piv '/(drafts)/' | \
grep -Piv '^\s*$' | \
tail -n +2 | \
perl -pe 's/^( *)/$1- /g' | \
perl -pe 's|/+|/|g' | \
perl -pe 's|\.[a-zA-Z]{2,4}(</a>)|$1|g' | \
perl -pe 's|<a href.+?/">([^<]+)</a>|$1|g' | \
perl -pe 's|(?<=^- )pdfs|other|g' \
)"

pdfToc="$(tree "$gitRoot/docs/pdfs/" -P '*.pdf' --filesfirst --prune --noreport -H '/pdfs/' | \
perl -00pe 's/(^.+<\/h1><p>|<hr>.+$)//sg' | \
sed 's/[└─├│ ]/ /g' | \
perl -pe 's/&nbsp;/ /g' | \
sed 's/^\t    //g' | \
grep -Piv '^\s*$' | \
tail -n +2 | \
perl -pe 's/^( *)/$1- /g' | \
perl -pe 's|\.[a-zA-Z]{2,4}(</a>)|$1|g' | \
perl -pe 's|_print_version(</a>)|$1|g' | \
perl -pe 's|/+|/|g' \
)"

# add a link to the simple new tag page, wherever the new tab page might be in the list
simpleNewTabPageLink="(<a href=\"html/new_tab_page_simple.html\">simple</a>)"
baseToc="$(echo "$baseToc" | perl -pe "s|(new_tab_page</a>)|\$1 $simpleNewTabPageLink|g")"

# change directory levels for the index file
indexToc="$(echo "$baseToc" | perl -pe 's|docs/||g' | perl -pe 's/\.md"/"/g')"

# populate file strings
readmeString="${indexTemplateString/\{table_of_contents\}/$baseToc}"
indexString="${indexTemplateString/\{table_of_contents\}/$indexToc}"
pdfString="${pdfTemplateString/\{table_of_contents\}/$pdfToc}"

# write files
echo "$readmeString" > "$gitRoot/readme.md"
echo "$indexString" > "$gitRoot/docs/index.md"
echo "$pdfString" > "$gitRoot/docs/pdfs/pdfs.md"

