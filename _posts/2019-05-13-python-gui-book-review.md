---
title: "Creating GUI Applications with wxPython - book review"
categories:
  - book-review
tags:
  - python
  - gui
  - wxpython
date: 2019-05-13T11:02:19
---

![GUI example]({{ '/images/python_gui/GUI_example.jpg' | absolute_url }}){: .align-center}

*Photo Credit: [Tranmautritam](https://www.pexels.com/photo/apple-computer-desk-devices-326501/) on [Pexels](https://www.pexels.com/)*

I've always wanted to create nice looking, useful GUI applications over the years. And I've given up most of the time as the programming seemed too difficult for me and GUI requires at least some level of design skills. I only managed to grit through one Android app for over a year as it was a dream game from school days and I had loads of free time having quit my job. At the end of it though, I had a spaghetti mess of several 1000+ lines programs and a strong aversion to Java and object oriented programming. Part of the reason is that I didn't try to learn in a formal way, just started from a tutorial closest to the game I wanted to do.

Several years later, here I am, trying my hand with GUI again. I have several small to medium scale apps in mind to implement and hopefully I'll avoid previous mistakes, especially feature creep. When I saw [this tweet from Mike Driscoll](https://twitter.com/driscollis/status/1109106540160733184), I took up the offer. I got a free book in exchange for reviewing [Creating GUI Applications with wxPython](https://www.blog.pythonlibrary.org/2019/05/08/creating-gui-applications-with-wxpython-now-available/). The book is currently on sale till May 15. Having to review has served as an extra incentive to read the book regularly, and so far I'm quite satisfied to have done so.

![book cover]({{ '/images/python_gui/wxPython_book_cover.png' | absolute_url }}){: .align-center}

I hadn't heard of [wxPython](https://wxpython.org) before this book. When it comes to GUI in Python, I knew about `tkinter` which comes by default with standard libary, [Kivy](https://kivy.org), [Pygame](https://www.pygame.org) and [PyQt5](https://pypi.org/project/PyQt5/). This book starts with an introduction to `wxPython` and then dives into project-based approach. I've finished half the chapters so far, covering four project concepts:

* Image viewer
* Database viewer and editor
* Calculator
* Archiver

![calculator]({{ '/images/python_gui/calculator.png' | absolute_url }}){: .align-center}

Rest of the chapters cover these topics:

* MP3 tag editor
* Image application using NASA's API
* PDF merger/splitter
* File search
* FTP application
* XML editor
* Distributing your application

There are also a couple of appendix chapters.

As mentioned in book's introduction, you definitely need to be comfortable with Python classes before you start this book. The code used in the book is also available from [GitHub repo](https://github.com/driscollis/applications_with_wxpython), but I highly recommend to type them manually.

The project nature also means that after chapter 3, you could probably skip chapters you are not interested in. For example, I didn't pay too much attention to database chapters as I don't have much experience with databases. Each project is described and shown step by step. The projects could be run at different stages as well - playing around with the GUI at those points helps in mapping code-to-output, as well as to experiment different settings.

All in all, I would highly recommend this book for those wanting to start coding GUI applications in Python. And please do contact the author to let him know your feedback or if you have any clarifications. Happy learning :)

