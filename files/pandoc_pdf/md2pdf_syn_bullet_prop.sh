#!/bin/bash

pandoc "$1" \
    -f gfm \
    --include-in-header chapter_break.tex \
    --include-in-header inline_code.tex \
    --include-in-header bullet_style.tex \
    --include-in-header pdf_properties.tex \
    --highlight-style pygments.theme \
    -V linkcolor:blue \
    -V geometry:a4paper \
    -V geometry:margin=2cm \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    --pdf-engine=xelatex \
    -o "$2"

