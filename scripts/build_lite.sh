#!/usr/bin/env bash

pip install --upgrade pip
pip install --upgrade mkdocs mkdocs-material mkdocs-exclude-search pymdown-extensions cairosvg pillow mkdocs-git-revision-date-localized-plugin
mkdocs build
