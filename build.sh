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
mkdocs build
