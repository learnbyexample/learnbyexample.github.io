---
title: "Ruby Regexp Part 1 - Introduction"
categories:
  - ebook
tags:
  - ruby
  - regular-expressions
date: 2019-03-25T18:02:36
---

![cover](/images/ruby_regexp/cover.png)

This is first post in a series, where I'll be posting chapters from my free [Ruby Regexp](https://github.com/learnbyexample/Ruby_Regexp) book. Regular expression syntax and features vary from one language to another. Still, the core concept is same and you could benefit from this series even if you do not use Ruby. You can download the ebook from any of these links for free or pay what you wish:

* [gumroad](https://gumroad.com/l/rubyregexp)
* [leanpub](https://leanpub.com/rubyregexp)

<br>

# Preface

Scripting and automation tasks often need to extract particular portions of text from input data or modify them from one format to another. This book will help you learn Regular Expressions, a mini-programming language for all sorts of text processing needs.

The book heavily leans on examples to present features of regular expressions one by one. It is recommended that you manually type each example and experiment with them. Understanding both the nature of sample input string and the output produced is essential. As an analogy, consider learning to drive a bike or a car - no matter how much you read about them or listen to explanations, you need to practice a lot and infer your own conclusions. Should you feel that copy-paste is ideal for you, [code snippets are available chapter wise on GitHub](https://github.com/learnbyexample/Ruby_Regexp).

The examples presented here have been tested with **Ruby version 2.5.0** and may include features not available in earlier versions. Unless otherwise noted, all examples and explanations are meant for *ASCII* characters only. The examples are copy pasted from `irb --simple-prompt` shell, but modified slightly for presentation purposes (like adding comments, blank lines, removing `nil` return value, brief error messages, etc).

**Acknowledgements**

* [ruby-lang documentation](https://www.ruby-lang.org/en/documentation/) - manuals and tutorials
* [/r/ruby/](https://www.reddit.com/r/ruby/) - helpful forum for beginners and experienced programmers alike
* [stackoverflow](https://stackoverflow.com/) - for getting answers to pertinent questions on Ruby and regular expressions
* [tex.stackexchange](https://tex.stackexchange.com/) - for help on `pandoc` and `tex` related questions
* [draw.io](https://about.draw.io/) - cover image
* [softwareengineering.stackexchange](https://softwareengineering.stackexchange.com/questions/39/whats-your-favourite-quote-about-programming) and [skolakoda](https://skolakoda.org/programming-quotes) for programming quotes

Special thanks to Allen Downey, an attempt at translating his book [Think Python](https://greenteapress.com/wp/think-python-2e/) to [Ruby](https://github.com/learnbyexample/ThinkRubyBuild) gave me the confidence to publish my own book.

**License** 

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/)

Code snippets are available under [MIT License](https://github.com/learnbyexample/Ruby_Regexp/blob/master/LICENSE)

See [Version_changes.md](https://github.com/learnbyexample/Ruby_Regexp/blob/master/Version_changes.md) to track changes across book versions. This series is based on version 1.1

# Why is it needed?

Regular Expressions have become a synonym with text processing. Most programming languages that are used for scripting purposes come with regular expression module as part of their standard library offering. If not, you can usually find a third-party library support. Syntax and features of regular expressions varies from language to language. Ruby's offering is based upon the [Onigmo regular expressions library](https://github.com/k-takata/Onigmo/blob/master/doc/RE).

The `string` class comes loaded with variety of methods to deal with text. So, what's so special about regular expressions and why would you need it? For learning and understanding purposes, one can view regular expressions as a mini programming language in itself, specialized for text processing. Parts of a regular expression can be saved for future use, analogous to variables and functions. There are ways to perform AND, OR, NOT conditionals. Operations similar to range and string repetition operators and so on.

Here's some common use cases:

* sanitizing a string to ensure it satisfies a known set of rules
* filtering or extracting portions on an abstract level like alphabets, numbers, punctuation, etc instead of a known fixed string
* qualified string replacement - start or end of string, whole words, based on surrounding text, etc

Though the term indicates *regular* structure, modern regular expressions support features like recursion too. So, usage of the term is different than the mathematical concept.

**Further Reading**

* [The true power of regular expressions](https://nikic.github.io/2012/06/15/The-true-power-of-regular-expressions.html) - it also includes a nice explanation of what *regular* means
* [softwareengineering: Is it a must for every programmer to learn regular expressions?](https://softwareengineering.stackexchange.com/questions/133968/is-it-a-must-for-every-programmer-to-learn-regular-expressions)
* [softwareengineering: When you should NOT use Regular Expressions?](https://softwareengineering.stackexchange.com/questions/113237/when-you-should-not-use-regular-expressions)
* [Regular Expressions: Now You Have Two Problems](https://blog.codinghorror.com/regular-expressions-now-you-have-two-problems/)
* [wikipedia: Regular expression](https://en.wikipedia.org/wiki/Regular_expression) - this article includes discussion on regular expressions as a formal language as well as details on various implementations

# Regexp literal and operators

It is always a good idea to know where to find the documentation. Visit [ruby-doc: Regexp](https://ruby-doc.org/core-2.5.0/Regexp.html) for information on `Regexp` class, available methods, syntax, features, examples and more. Here's a quote:

>Regular expressions (*regexps*) are patterns which describe the contents of a string. They're used for testing whether a string contains a given pattern, or extracting the portions that match. They are created with the `/pat/` and `%r{pat}` literals or the `Regexp.new` constructor.

In this chapter, you'll get to know how to declare and use regexps. For some examples, the equivalent normal string method is shown for comparison. Regular expression features will be covered next chapter onwards.

First up, a simple example to test whether a string is part of another string or not. Normally, you'd use the `include?` method and pass a string as argument. To pass a regexp, use the `match?` method.

```ruby
>> sentence = 'This is a sample string'
=> "This is a sample string"

# check if 'sentence' contains the given string argument
>> sentence.include?('is')
=> true
>> sentence.include?('z')
=> false

# check if 'sentence' contains the pattern described by regexp argument
>> sentence.match?(/is/)
=> true
>> sentence.match?(/z/)
=> false
```

The `match?` method accepts an optional second argument to specify the index to start searching from.

```ruby
>> sentence.match?(/is/, 2)
=> true
>> sentence.match?(/is/, 6)
=> false
```

The regexp literals can be saved in a variable which helps to improve code clarity, pass around as method argument, enable reuse, etc.

```ruby
>> pet = /dog/
=> /dog/

>> 'They bought a dog'.match?(pet)
=> true
>> 'A cat crossed their path'.match?(pet)
=> false
```

Similar to double quoted string literals, you can use interpolation and escape sequences in a regexp literal. See [ruby-doc: Strings](https://ruby-doc.org/core-2.5.0/doc/syntax/literals_rdoc.html#label-Strings) for syntax details on string escape sequences. Regexp literals have many more special meanings, will be explained one by one.

```ruby
>> "cat\tdog".match?(/\t/)
=> true
>> "cat\tdog".match?(/\a/)
=> false

>> greeting = 'hi'
=> "hi"
>> /#{greeting} there/
=> /hi there/
>> /#{greeting.upcase} there/
=> /HI there/
>> /#{2**4} apples/
=> /16 apples/
```

Ruby also provides Perl style regexp matching. The `=~` match operator returns index of first match and `nil` if match is not found. The `!~` match operator returns `true` if string *doesn't* contain the given regexp and `false` otherwise. A key difference from `match?` method is that these operators will also set regexp related global variables (discussed in later chapters).

```ruby
>> sentence = 'This is a sample string'
=> "This is a sample string"

# can also use: /is/ =~ sentence
>> sentence =~ /is/
=> 2
>> sentence =~ /z/
=> nil

# can also use: /z/ !~ sentence
>> sentence !~ /z/
=> true
>> sentence !~ /is/
=> false
```

Just like `match?` method, both `=~` and `!~` can be used in a conditional statement:

```ruby
>> puts 'hi' if sentence =~ /is/
hi
=> nil

>> puts 'hi' if sentence !~ /z/
hi
=> nil
```

Yet another alternative to `match?` method is the `===` operator. This one returns `true` or `false` similar to `match?` method, but in addition sets regexp related global variables. Comes in handy with Enumerable methods like `grep`, `grep_v`, `all?`, `any?`, etc.

```ruby
>> sentence = 'This is a sample string'
=> "This is a sample string"

# regexp literal has to be on LHS and string on RHS
>> /is/ === sentence
=> true
>> /z/ === sentence
=> false

>> words = %w[cat parrot whale]
=> ["cat", "parrot", "whale"]
>> words.all?(/a/)
=> true
>> words.none?(/w/)
=> false
```

You might wonder why there are so many ways to test matching condition with regexps. The most common approach is to use `match?` method in a conditional statement. If you need position of match, use `=~` operator or `index` method. The `===` operator is usually relevant in Enumerable methods. Usage of global variables will be covered in later chapters. The `=~` and `!~` operators are also prevalent in command line one-liners, see my [Ruby one liners](https://github.com/learnbyexample/Command-line-text-processing/blob/master/ruby_one_liners.md) tutorial for examples.

<br>

For practice problems, visit [Exercises](https://github.com/learnbyexample/Ruby_Regexp/blob/master/exercises/Exercises.md) file from the repository.

