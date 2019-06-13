#!/bin/bash

pandoc "$1" \
    -f gfm \
    --toc \
    --include-in-header chapter_break.tex \
    --include-in-header inline_code.tex \
    --include-in-header bullet_style.tex \
    --include-in-header pdf_properties.tex \
    --highlight-style pygments.theme \
    -V toc-title='Table of contents' \
    -V linkcolor:blue \
    -V geometry:a4paper \
    -V geometry:margin=2cm \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    --pdf-engine=xelatex \
    -o temp.tex

fn="${2%.*}"

perl -0777 -pe \
  's/begin\{document\}\n\n\K(.*?^\}$)(.+?)\n/$2\n\\thispagestyle{empty}\n\n$1\n/ms' \
  temp.tex > "$fn".tex

xelatex "$fn".tex &> /dev/null
xelatex "$fn".tex &> /dev/null

rm temp.tex "$fn".{tex,toc,aux,log}


