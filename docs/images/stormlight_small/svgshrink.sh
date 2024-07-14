#!/usr/bin/env bash
perl -i -pe 's/(?<= )height="[\d\.]+"//g' *.svg
perl -i -pe 's/(?<= width=")[\d\.]+(?=")/70/g' *.svg
