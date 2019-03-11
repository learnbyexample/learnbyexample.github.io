---
title: "Customizing pandoc to generate beautiful pdfs from markdown"
categories:
  - tutorial
  - ebook-generation
tags:
  - pandoc
  - xelatex
  - markdown
  - pdf
date: 2019-03-11T21:05:25
---

Either you've already heard of `pandoc` or if you have searched online for `markdown` to `pdf` or similar, you are sure to come across `pandoc`. This tutorial will give you a basic idea of using `pandoc` to generate `pdf` from [GitHub style markdown](https://github.github.com/gfm/) file. The main purpose is to highlight what customizations I did to generate `pdf` for self-publishing my ebooks. It wasn't easy to arrive at the set-up I ended up with, so I hope this will be useful for those looking to use `pandoc` to generate `pdf`. Specifically aimed at technical books that has code snippets.

## Installation

I use Ubuntu, as far as I remember, the below steps are enough to work for the demos in this tutorial. If you get an error or warning, search that issue online and you'll likely find what else has to be installed.

I first downloaded `deb` file from [pandoc: releases](https://github.com/jgm/pandoc/releases) and installed it. Followed by packages needed for `pdf` generation.

```bash
$ # current version is 2.7, I had installed last year with 2.3
$ sudo gdebi ~/Downloads/pandoc-2.3-1-amd64.deb

$ # note that download size is 750+ MB
$ sudo apt install texlive-xetex
$ sudo apt install librsvg2-bin
$ sudo apt install texlive-math-extra
```

For more details and guide for other OS, refer to [pandoc: installation](https://pandoc.org/installing.html)

## Minimal example

Once `pandoc` is working on your system, try generating a sample `pdf` without any customization.

**Note**: See [learnbyexample.github.io repo](https://github.com/learnbyexample/learnbyexample.github.io/tree/master/files/pandoc_pdf) for all the input and output files referred in this tutorial

```bash
$ pandoc sample_1.md -f gfm -o sample_1.pdf
```

Here `sample_1.md` is input markdown file and `-f` is used to specify that the input format is GitHub style markdown. The `-o` option specifies the output file type based on extension. The default output is probably good enough but has shortcomings like hyperlink and inline code are hard to distinguish, chapters are not separated, etc.

`pandoc` has its own version of `markdown` as well with many useful extensions, see [pandoc: pandocs-markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) for details.

**Note** that it is advised to use `markdown` headers in order without skipping - for example, `H1` for chapter heading and `H2` for chapter sub-section, etc is fine. `H1` for chapter heading and `H3` for sub-section is not. Using the former can give automatic index navigation on `pdf` readers.

On [Evince](https://wiki.gnome.org/Apps/Evince) reader, the index navigation for above sample looks like this:

![Chapter Index](/images/pandoc_pdf/chapter_index.png)

## Chapter breaks

As observed from previous demo, by default there are no chapter breaks. Searching for a [solution online](https://superuser.com/questions/601469/getting-chapters-to-start-on-a-new-page-in-a-pandoc-generated-pdf), I got this piece of `tex` code:

```latex
\usepackage{sectsty}
\sectionfont{\clearpage}
```

This can be added using `-H` option. From `pandoc` manual,

>-H FILE, --include-in-header=FILE
>
>Include  contents  of FILE, verbatim, at the end of the header.  This
>can be used, for example, to include special  CSS  or  JavaScript  in
>HTML documents.  This option can be used repeatedly to include multiple
>files in the header.  They will be included in the  order  specified.
>Implies --standalone.

So, the `pandoc` invocation now looks like:

```bash
$ pandoc sample_1.md -f gfm -H chapter_break.tex -o sample_1_chapter_break.pdf
```

## Changing settings via -V option

>-V KEY[=VAL], --variable=KEY[:VAL]
>
>Set the template variable KEY to the value  VAL  when  rendering  the
>document  in standalone mode.  This is generally only useful when the
>--template option is used to specify a custom template, since  pandoc
>automatically  sets  the variables used in the default templates.  If
>no VAL is specified, the key will be given the value true.

The `-V` option allows to change variable values to customize settings like page size, font, link color, etc. As more settings are changed, better to use a simple script to call `pandoc` instead of typing the whole command on terminal.

```bash
#!/bin/bash

pandoc "$1" \
    -f gfm \
    --include-in-header chapter_break.tex \
    -V linkcolor:blue \
    -V geometry:a4paper \
    -V geometry:margin=2cm \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    --pdf-engine=xelatex \
    -o "$2"
```

* `mainfont` is for normal text
* `monofont` is for code snippets
* `geometry` for page size and margins
* `linkcolor` to set hyperlink color

Using `xelatex` as the `pdf-engine` allows to use any font installed in the system. One reason I chose `DejaVu` was because it supported **Greek** and other Unicode characters that were causing error with other fonts. See [tex.stackexchange: Using XeLaTeX instead of pdfLaTeX](https://tex.stackexchange.com/questions/21736/using-xelatex-instead-of-pdflatex) for some more details.

```bash
$ chmod +x md2pdf.sh
$ ./md2pdf.sh sample_1.md sample_1_settings.pdf
```

## Syntax highlighting

One option to customize syntax highlighting for code snippets is to save one of the `pandoc` themes and editing it. See [stackoverflow: What are the available syntax highlighters?](https://stackoverflow.com/questions/30880200/pandoc-what-are-the-available-syntax-highlighters/47876166#47876166) for available themes and more details (go through other answers as well).

```bash
$ pandoc --print-highlight-style=pygments > pygments.theme
```

Change theme settings using a text editor ([colorhexa](https://www.colorhexa.com/) is a good site to choose colors). For this demo, the below settings are changed:

```
# by default, background is same as normal text
# change it to a shade of gray to easily distinguish code and text
"background-color": "#f8f8f8",

# change italic to false, messes up comments with slashes
# change text-color to another shade of gray
"Comment": {
    "text-color": "#9c9c9c",
    "background-color": null,
    "bold": false,
    "italic": false,
    "underline": false
},
```

**Inline code**

Similar to changing background color for code snippets, I found a [solution online](https://stackoverflow.com/questions/40975004/pandoc-latex-change-backtick-highlight) to change background color for inline code snippets.

```latex
\usepackage{fancyvrb,newverbs,xcolor}

\definecolor{Light}{HTML}{F4F4F4}

\let\oldtexttt\texttt
\renewcommand{\texttt}[1]{
  \colorbox{Light}{\oldtexttt{#1}}
}
```

Add `--highlight-style pygments.theme` and `--include-in-header inline_code.tex` to the script and generate the `pdf` again.

With `pandoc sample_2.md -f gfm -o sample_2.pdf` the output would be:

![Default syntax highlighting](/images/pandoc_pdf/default_syn.png)

With `./md2pdf_syn.sh sample_2.md sample_2_syn.pdf` the output is:

![Customized syntax highlighting](/images/pandoc_pdf/customized_syn.png)

<br>

For my [Python re(gex)?](https://github.com/learnbyexample/py_regular_expressions) book, by chance I found that using `ruby` instead of `python` for REPL code snippets syntax highlighting was better. As seen from `./md2pdf_syn.sh sample_3.md sample_3.pdf` result, for `python` directive, string output gets treated as a comment and color for boolean values isn't easy to distinguish from string values.

![REPL syntax highlighting](/images/pandoc_pdf/python_vs_ruby_syn.png)

## Bullet styling

This [stackoverflow Q&A](https://stackoverflow.com/questions/22156999/how-to-change-the-style-of-bullets-in-pandoc-markdown) helped for bullet styling.

```latex
\usepackage{enumitem}
\usepackage{amsfonts}

% level one
\setlist[itemize,1]{label=$\bullet$}
% level two
\setlist[itemize,2]{label=$\circ$}
% level three
\setlist[itemize,3]{label=$\star$}
```

`pandoc sample_4.md -f gfm -o sample_4.pdf` vs `./md2pdf_syn_bullet.sh sample_4.md sample_4_bullet.pdf` gives:

![Bullet styling](/images/pandoc_pdf/bullet_styling.png)

## PDF properties

This [tex.stackexchange Q&A](https://tex.stackexchange.com/questions/23235/eliminate-edit-pdf-properties-added-by-pdflatex) helped to change metadata. See also [pspdfkit: What’s Hiding in Your PDF?](https://pspdfkit.com/blog/2018/whats-hiding-in-your-pdf/) and [discussion on HN](https://news.ycombinator.com/item?id=18381515).

```latex
\usepackage{hyperref}

\hypersetup{
  pdftitle={My awesome book},
  pdfauthor={learnbyexample},
  pdfsubject={pandoc},
  pdfkeywords={pandoc,pdf,xelatex}
}
```

`./md2pdf_syn_bullet_prop.sh sample_4.md sample_4_bullet_prop.pdf` gives:

![PDF properties](/images/pandoc_pdf/pdf_properties.png)

## Resource links

* [pandoc: manual](https://pandoc.org/MANUAL.html)
* [pandoc: demos](https://pandoc.org/demos.html)
* [pandoc: tips and tricks](https://github.com/jgm/pandoc/wiki/Pandoc-Tricks)
* [tex.stackexchange: How to change the background color and border of a blockquote?](https://tex.stackexchange.com/questions/154528/how-to-change-the-background-color-and-border-of-a-pandoc-generated-blockquote)
* [tex.stackexchange: Change section fonts](https://tex.stackexchange.com/questions/10138/change-section-fonts)

**Other ebook creation tools**:

* [Asciidoctor](https://asciidoctor.org/docs/what-is-asciidoc/)
* [Sphinx](https://www.sphinx-doc.org/en/stable/index.html)
    * [Self-publishing a book with reStructuredText, Sphinx, Calibre, and vim](https://digitalsuperpowers.com/blog/2019-02-16-publishing-ebook.html)
* [Bookdown](https://bookdown.org/home/)
* [Markdeep](https://casual-effects.com/markdeep/)

**Miscellaneous**

* [Vim is saving me hours of work when writing books & courses](https://nickjanetakis.com/blog/vim-is-saving-me-hours-of-work-when-writing-books-and-courses)
* [Writing a Book with Unix](https://joecmarshall.com/posts/book-writing-environment/)
* [askubuntu: How do I install fonts?](https://askubuntu.com/questions/3697/how-do-i-install-fonts)
* [tex.stackexchange: What best combination of fonts for Serif, Sans, and Mono do you recommend?](https://tex.stackexchange.com/questions/9533/what-best-combination-of-fonts-for-serif-sans-and-mono-do-you-recommend)
* [LATEX font catalogue](http://www.tug.dk/FontCatalogue/)
* [Tools to support markdown authoring](https://github.com/karthik/markdown_science/wiki/Tools-to-support-your-markdown-authoring)
* [picular: search engine for colors](https://picular.co/)
* [ebooks.stackexchange](https://ebooks.stackexchange.com/questions?sort=votes)

