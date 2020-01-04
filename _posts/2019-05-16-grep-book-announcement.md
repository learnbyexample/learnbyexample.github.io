---
title: "GNU GREP and RIPGREP"
categories:
  - ebook
tags:
  - gnu-grep
  - ripgrep
  - linux
  - command-line
date: 2019-05-16T16:46:01
---

Hello!

I recently self-published my third book, this one is about **GNU GREP and RIPGREP**.

![grep cover image]({{ '/images/books/grep.png' | absolute_url }}){: .align-center}

Get the e-book using either of these sites:

* [https://gumroad.com/l/gnugrep_ripgrep](https://gumroad.com/l/gnugrep_ripgrep)
* [https://leanpub.com/gnugrep_ripgrep](https://leanpub.com/gnugrep_ripgrep)

**Note** Please use a valid e-mail and save the mail you receive, you'll get free updates for future versions.

Code snippets, example files, sample chapters, etc are available on GitHub: [https://github.com/learnbyexample/learn_gnugrep_ripgrep](https://github.com/learnbyexample/learn_gnugrep_ripgrep)

This book covers features of `GNU grep` and `ripgrep` along with discussion on BRE/ERE/PCRE(2)/Rust **regular expressions**. Examples are used extensively, please follow along by typing them out. Exercises are also included to test your understanding.

Some of you might be familiar with my [Command Line Text Processing](https://github.com/learnbyexample/Command-line-text-processing) repo. This book is based on the `grep` chapter - edited to add more descriptions, better examples, exercises, etc. Also, I took the plunge and checked out `ripgrep` while working on this book. I'd assumed it would be similar to `gnu grep` and I just need simple changes to present it in the book. Well, it turned out lot more work and I had to settle for not covering all the options and customizations. In hindsight, would've been better if I did a separate book. Speed wise, `ripgrep` is very impressive and has plenty of additional nice features. For example: the multiline `-U` and replace `-r` options of `ripgrep` are quite handy - you can use this instead of `sed` for some cases with added advantage of speed, `-F` option and better regex features.

**Table of Contents**

* Preface
* Introduction
* Frequently used options
* BRE/ERE Regular Expressions
* Context matching
* Recursive search
* Miscellaneous options
* Perl Compatible Regular Expressions
* Gotchas and Tricks
* ripgrep
* Further Reading

Hope you find the book useful. I would be grateful for your feedback and suggestions ([twitter](https://twitter.com/learn_byexample), [goodreads](https://www.goodreads.com/book/show/47406700-gnu-grep-and-ripgrep)).

Happy learning :)

