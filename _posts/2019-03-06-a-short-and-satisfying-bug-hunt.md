---
title: "A short and satisfying bug hunt"
categories:
  - shell scripting
tags:
  - debugging
  - corner case
date: 2019-03-06T21:04:04
---

## The surprise

So, a pleasant surprise awaited me last Sunday. As is my usual habit, I opened my
[github](https://github.com/learnbyexample) account after breakfast to see if I've
got any sudden spurt in traffic. And as usual, things were normal. Except for the blue
notification, which was rare. I hoped it wasn't a silly pull request and thankfully
it was a [new issue](https://github.com/learnbyexample/Command-line-text-processing/issues/24)
that was opened.

I gave the issue a cursory glance and wrongly guessed it was probably some line ending issue
(user was on Windows OS). As someone who has seen plenty of
bugs in previous job, I wasn't ruling out anything though. I first cloned the repo so as to try
to recreate the working environment without possible interference from my local working copy.
As the user had provided detailed information while opening the issue, I was able to quickly
replicate it. Sure enough, I was seeing the same problem. I only wondered why it wasn't
brought to my attention before. Either past users chose not to or things weren't interesting
enough to reach that far in the exercises.

## Creating minimal failing case

As I had written the [solution checker script](https://github.com/learnbyexample/Command-line-text-processing/blob/master/exercises/GNU_grep/solve)
about 2 years back, the script looked alien.
Right from cloning the repo, I had to fight the urge to improve things. By the time I spotted
the issue, all such fantasies were thrown out. Replaced by a todo note to *someday* write automated
testing script to check that my script is indeed working properly for all the exercises.

To put it simply, the role of `solve` script is to check if the previous command
executed by the user solves the current exercise question. To do so, the script
gets the previous command from history and compares the output of that command
and a reference solution present in the exercise directory. Sounds simple right?
Yeah, I thought so too. I do remember testing few cases before I first published it
and no one had submitted an issue so far. So, why was it failing now?

As mentioned before, I thought it could be some weird line ending issue. But that was
effectively ruled out as it was failing for me as well on Linux. Still, I did check
for funny characters with `cat -A`. Nope, no issues there.

```bash
$ grep -o '^[^=]*' sample.txt
a[2]
foo_bar
appx_pi
greeting
food[4]
b[0][1]
$ source ../solve -s
---------------------------------------------
Mismatch for question 1:
Expected output is:
a[2]
foo_bar
appx_pi
greeting
food[4]
b[0][1]
---------------------------------------------
```

Expected output was same as output for submitted solution. So, why is the script failing?
I remember passing the script through [shellcheck](https://www.shellcheck.net/) but still
checked it again. No progress. So, then I started by trying to debug the most likely
culprit from terminal before trying to debug the whole script. Luckily, that turned out well.

```bash
$ cat sample.txt 
a[2]='sample string'
foo_bar=4232
appx_pi=3.14
greeting="Hi  there		have a nice   day"
food[4]="dosa"
b[0][1]=42

$ # say what??
$ [[ $(eval "command grep -o '^[^=]*' sample.txt") == \
>    $(eval "command grep -o '^[^=]*' sample.txt") ]] || echo 'Not fine'
Not fine

$ # after some attempts, I tried a command that won't have
$ # any [] characters in the output
$ # Eureka!
$ [[ $(eval "command grep 'bar' sample.txt") == \
>    $(eval "command grep 'bar' sample.txt") ]] || echo 'Not fine'
$ [[ foo == foo ]] && echo 'fine'
fine
$ [[ 'a[5]' == a[5] ]] || echo 'Not fine'
Not fine
$ [[ 'a[5]' == 'a[5]' ]] && echo 'fine'
fine
```

Having a minimal failing case from terminal was a relief. I tried `set -x` but
that didn't light a bulb either. Finally, somehow I thought perhaps characters
in the output was causing the issue and when `[]` characters were not present,
the comparison worked as expected.

I did think quoting could be the issue, but dismissed it at first as both sides
of comparison had the same command. Then my recent experience from reviewing
[Command Line Fundamentals](https://www.packtpub.com/application-development/command-line-fundamentals)
book came in handy. I remembered that if quotes aren't used on RHS of comparison
operator, it is treated as `glob` matching instead of string matching. Phew.

## TL;DR

Always [quote strings in bash](https://unix.stackexchange.com/questions/131766/why-does-my-shell-script-choke-on-whitespace-or-other-special-characters)
unless you have a very good reason for not using them.

After adding double quotes around the command substitution commands, the script
worked as expected. I thanked the user for opening the issue. And then informed
the author for cli fundamentals book as well.

