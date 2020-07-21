#!/bin/bash

pandoc  "$1" \
        -f gfm \
        --toc \
        --standalone \
        --top-level-division=chapter \
        --highlight-style pygments.theme \
        --css epub.css \
        --metadata=title:"My awesome book" \
        --metadata=author:"learnbyexample" \
        --metadata=lang:"en-US" \
        --metadata=cover-image:"cover.png" \
        -o "$2"

