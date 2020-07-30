---
title: "I know Python basics, what next?"
categories:
  - curated-resources
tags:
  - python
  - exercises
  - projects
  - intermediate
date: 2020-07-25T15:42:34
---

![what next]({{ '/images/what_next.png' | absolute_url }}){: .align-center}

<br>

What to learn next is an often asked question. [Searching for `what next` on /r/learnpython](https://www.reddit.com/r/learnpython/search?q=what+next&restrict_sr=on) gives you too many results. Here's some more Q&A and articles on this topic:

* [I know how to program, but I don't know what to program](https://www.devdungeon.com/content/i-know-how-program-i-dont-know-what-program)
* [Learning by converting code from one language to another](https://www.reddit.com/r/learnpython/comments/5503pa/code_conversion_probably_the_best_tool_any_level/)
* [Write a command-line utility](https://www.reddit.com/r/learnprogramming/comments/7m92i1/coding_idea_write_a_commandline_utility/)
* [If you want to learn you'll need to be willing to look stupid](https://www.reddit.com/r/learnprogramming/comments/5jm97p/if_you_want_to_learn_youll_need_to_be_willing_to/)
* [Techniques for Efficiently Learning Programming Languages](http://www.flyingmachinestudios.com/programming/learn-programming-languages-efficiently/)
* [Things you might encounter in your programming journey](https://www.techinasia.com/talk/27-things-started-programming)

<br>

## Exercises and Projects

I do not have a simple answer to this question either. If you feel comfortable with programming basics and Python syntax, then exercises are a good way to test your knowledge. The resource you used to learn Python will typically have some sort of exercises, so those would be ideal as a first choice. I'd also suggest using the below resources to improve your skills. If you get stuck, reread the material related to those topics, search online, ask for clarifications, etc  — in short, make an effort to solve it. It is okay to skip some troublesome problems (and come back to it later if you have the time), but you should be able to solve most of the beginner problems. Maintaining notes will help too, especially for common mistakes.

* [Exercism](https://exercism.io/tracks/python/exercises), [Practicepython](https://www.practicepython.org/), [Edabit](https://edabit.com/challenges/python3) — these are all beginner friendly and difficulty levels are marked
* [Codewars](https://www.codewars.com/), [Adventofcode](https://adventofcode.com/), [Projecteuler](https://projecteuler.net/) — more challenging
* [Checkio](https://py.checkio.org/), [Codingame](https://www.codingame.com/start), [Codecombat](https://codecombat.com/play/level/dungeons-of-kithgard) — gaming based challenges
* [/r/dailyprogrammer](https://www.reddit.com/r/dailyprogrammer) — not active currently, but there's plenty of past challenges with discussions

Once you are comfortable with basics and syntax, the next step is projects. I use a 10-line program that solves a common problem for me — adding `body { text-align: justify }` to `epub` files that are not justify aligned. I didn't know that this line would help beforehand, I searched online for a solution and then automated the process of unzipping `epub`, adding the line and then packing it again. That will likely need you to lookup documentation and go through some stackoverflow Q&A as well. And once you have written the solution and use it regularly, you'll likely encounter corner cases and features to be added. I feel this is a great way to learn and understand programming.

* [Projects on various topics with solutions](https://github.com/karan/Projects-Solutions)
* [Project based learning](https://github.com/tuvtran/project-based-learning#python)
* [Pytudes by Peter Norvig](https://github.com/norvig/pytudes)
* [Rosettacode](https://rosettacode.org/wiki/Category:Python)

<br>

## Debugging

Knowing how to debug your programs is crucial and should be ideally taught right from the beginning instead of a chapter at the end of the book. [Think Python](https://greenteapress.com/wp/think-python-2e/) is an awesome example for such a resource material.

Sites like [Pythontutor](http://www.pythontutor.com/visualize.html#mode=edit) allow you to visually debug a program — you can execute a program step by step and see the current value of variables. Similar feature is typically provided by IDEs like [Pycharm](https://www.jetbrains.com/pycharm/) and [Thonny](https://thonny.org/). Under the hood, these visualizations are using the [pdb module](https://docs.python.org/3/library/pdb.html). See also [Python debugging with pdb](https://realpython.com/python-debugging-pdb/).

Debugging is often a frustrating experience. Taking a break helps (and sometimes I have found the problem in my dreams). Try to reduce the code as much as possible so that you are left with minimal code necessary to reproduce the issue. Talking about the problem to a friend/colleague/inanimate-objects/etc can help too — known as [Rubber duck debugging](https://rubberduckdebugging.com/). I have often found the issue while formulating a question to be asked on forums like stackoverflow/reddit because writing down your problem is another way to bring clarity than just having a vague idea in your mind. Here's some more articles on this challenging topic:

* [What does debugging a program look like?](https://jvns.ca/blog/2019/06/23/a-few-debugging-resources/)
* [How to debug small programs](https://ericlippert.com/2014/03/05/how-to-debug-small-programs/)
* [Debugging guide](https://uchicago-cs.github.io/debugging-guide/)
* [Problem solving skills](https://ryanstutorials.net/problem-solving-skills/)

Here's an interesting snippet (modified to keep it small) from a collection of [interesting bug stories](https://stackoverflow.com/questions/169713/whats-the-toughest-bug-you-ever-found-and-fixed).

>A jpeg parser choked whenever the CEO came into the room, because he always had a shirt with a square pattern on it, which triggered some special case of contrast and block boundary algorithms.

See also [curated list of absurd software bug stories](https://500mile.email/).

## Testing

Another crucial aspect in the programming journey is knowing how to write tests. In bigger projects, usually there are separate engineers (often in much larger number than code developers) to test the code. Even in those cases, writing a few sanity test cases yourself can help you develop faster knowing that the changes aren't breaking basic functionality.

There's no single consensus on test methodologies. There is [Unit testing](https://en.wikipedia.org/wiki/Unit_testing), [Integration testing](https://en.wikipedia.org/wiki/Integration_testing), [Test-driven development](https://en.wikipedia.org/wiki/Test-driven_development) and so on. Often, a combination of these is used. These days, machine learning is also being considered to reduce the testing time, see [Testing Firefox more efficiently with machine learning](https://hacks.mozilla.org/2020/07/testing-firefox-more-efficiently-with-machine-learning/) for example.

When I start a project, I usually try to write the programs incrementally. Say I need to iterate over files from a directory. I will make sure that portion is working (usually with `print` statements), then add another feature — say file reading and test that and so on. This reduces the burden of testing a large program at once at the end. And depending upon the nature of the program, I'll add a few sanity tests at the end. For example, for my [command_help](https://github.com/learnbyexample/command_help) project, I copy pasted a few test runs of the program with different options and arguments into a separate file and wrote a program to perform these tests programmatically whenever the source code is modified.

For non-trivial projects, you'll usually end up needing frameworks like built-in module `unittest` or third-party modules like `pytest`. See [Getting started with testing in Python](https://realpython.com/python-testing/) and [calmcode: pytest](https://calmcode.io/pytest/introduction.html) for discussion on these topics.

<br>

## Intermediate Python resources

* [Official Python docs](https://docs.python.org/3/index.html) — Python docs are a treasure trove of information
* [Calmcode](https://calmcode.io/) — videos on testing, code style, args kwargs, data science, etc
* [Practical Python Programming](https://dabeaz-course.github.io/practical-python/Notes/Contents.html) — covers foundational aspects of Python programming with an emphasis on script writing, data manipulation, and program organization
* [Intermediate Python](https://book.pythontips.com/en/latest/index.html) — covers debugging, generators, decorators, virtual environment, collections, comprehensions, classes, etc
* [Effective Python](https://www.effectivepython.com/) — insight into the Pythonic way of writing programs
* [Fluent Python](https://www.oreilly.com/library/view/fluent-python/9781491946237/) — takes you through Python’s core language features and libraries, and shows you how to make your code shorter, faster, and more readable at the same time
    * [Fluent Python, 2nd Edition](https://www.oreilly.com/library/view/fluent-python-2nd/9781492056348/)
* [Serious Python](https://nostarch.com/seriouspython) — deployment, scalability, testing, and more
* [Pythonprogramming](https://pythonprogramming.net/) — domain based topics like machine learning, game development, data analysis, web development, etc
* [Youtube: Corey Schafer](https://www.youtube.com/user/schafer5/playlists) — various topics for beginners to advanced users

<br>

## Handy cheatsheets

* [Python Crash Course cheatsheet](https://ehmatthes.github.io/pcc_2e/cheat_sheets/cheat_sheets/)
* [Comprehensive Python cheatsheet](https://gto76.github.io/python-cheatsheet/)
* [Scientific Python cheatsheet](https://ipgp.github.io/scientific_python_cheat_sheet/)

<br>

I hope these resources will help you take that crucial next step and continue your Python journey. Happy learning :)

