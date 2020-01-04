---
title: "Ruby Regexp Part 7 - Groupings and backreferences"
categories:
  - ebook
tags:
  - ruby
  - regular-expressions
date: 2019-04-02T15:59:43
---

![groupings and backreferences](/images/ruby_regexp/groupings_backreferences.png)

*Photo Credit: [Clem Onojeghuo](https://www.pexels.com/photo/assorted-assortment-booth-boxes-375897/) on [Pexels](https://www.pexels.com/)*

This is seventh post in a series, where I'll be posting chapters from my free [Ruby Regexp](https://github.com/learnbyexample/Ruby_Regexp) book. Regular expression syntax and features vary from one language to another. Still, the core concept is same and you could benefit from this series even if you do not use Ruby. You can download the ebook from any of these links for free or pay what you wish:

* [gumroad](https://gumroad.com/l/rubyregexp)
* [leanpub](https://leanpub.com/rubyregexp)

# Groupings and backreferences

You've been patiently hearing more awesome stuff to come regarding groupings. Well, here they come in various forms. And some more will come in later chapters!

First up, saving (i.e. capturing) regexp to use it later, similar to variables and functions in a programming language. You have already seen how to use global variables to refer to text captured by groups. In a similar manner, you can use backreference `\N` where `N` is the capture group you want. Backreferences can be used within the regexp definition itself as well as in replacement section whereas global variables can be used in blocks or later instructions.

* in replacement section, use `\1`, `\2` up to `\9` to refer to the corresponding capture group
* in replacement section, use `\0` or `\&` to refer to entire matched portion, similar to `$&` global variable
    * similarly, ``\` `` and `\'` are equivalents for ``$` `` and `$'` respectively
* within regexp definition or when using global variables, there is no upper limit of `9`
    * which implies that you'll have to necessarily use block form if more than `9` backreferences are needed for replacement
* **Note** that if double quotes is used in replacement section, you'll have to use `\\1`, `\\2`, etc

```ruby
# remove square brackets that surround digit characters
>> '[52] apples and [31] mangoes'.gsub(/\[(\d+)\]/, '\1')
=> "52 apples and 31 mangoes"
# replace __ with _ and delete _ if it is alone
>> '_foo_ __123__ _baz_'.gsub(/(_)?_/, '\1')
=> "foo _123_ baz"

# add something around the matched strings
>> '52 apples and 31 mangoes'.gsub(/\d+/, '(\0)')
=> "(52) apples and (31) mangoes"
>> 'Hello world'.sub(/.*/, 'Hi. \0. Have a nice day')
=> "Hi. Hello world. Have a nice day"

# swap words that are separated by a comma
>> 'a,b 42,24'.gsub(/(\w+),(\w+)/, '\2,\1')
=> "b,a 24,42"
```

Here's some examples for using backreferences within regexp definition

```ruby
# whole words that have at least one consecutive repeated character
>> %w[effort flee facade oddball rat tool].grep(/\b\w*(\w)\1\w*\b/)
=> ["effort", "flee", "oddball", "tool"]

# remove any number of consecutive duplicate words separated by space
# quantifiers can be applied to backreferences too!
>> 'a a a walking for for a cause'.gsub(/\b(\w+)( \1)+\b/, '\1')
=> "a walking for a cause"
```

It may be obvious, but it should be noted that backreference will provide the string that was matched, not the regexp that was inside the capture group. For example, if `([0-9][a-f])` matches `3b`, then backreferencing will give `3b` and not any other valid match of regexp like `8f`, `0a` etc. This is akin to how variables behave in programming, only the result of expression stays after variable assignment, not the expression itself.

To refer to the regexp itself, use `\g<1>`, `\g<2>` etc. This is applicable only in regexp definition, not in replacement sections. This behavior, which is similar to function call, is known as **subexpression call** in regular expression parlance. Recursion will be discussed later.

```ruby
>> row = 'today,2008-03-24,food,2012-08-12,nice,5632'
=> "today,2008-03-24,food,2012-08-12,nice,5632"

# same as: /\d{4}-\d{2}-\d{2}.*\d{4}-\d{2}-\d{2}/
>> row.match(/(\d{4}-\d{2}-\d{2}).*\g<1>/)[0]
=> "2008-03-24,food,2012-08-12"
```

## Non-capturing groups

Grouping has many uses like applying quantifier on a regexp portion, creating terse regexp by factoring common portions and so on. It also affects behavior of string methods like `scan` and `split`.

```ruby
# without capture group
>> 'Sample123string42with777numbers'.split(/\d+/)
=> ["Sample", "string", "with", "numbers"]

# to include the matching delimiter strings as well in the output
>> 'Sample123string42with777numbers'.split(/(\d+)/)
=> ["Sample", "123", "string", "42", "with", "777", "numbers"]
```

When backreferencing is not required, you can use a non-capturing group to avoid behavior change of `scan` and `split` methods. It also helps to avoid keeping a track of capture group numbers when that particular group is not needed for backreferencing. The syntax is `(?:regexp)` to define a non-capturing group - recall that `(?>regexp)` is used to define atomic groups. More such special groups starting with `(?` syntax will be discussed later on.

```ruby
# normal capture group will hinder ability to get whole match
# non-capturing group to the rescue
>> 'cost akin more east run against'.scan(/\b\w*(?:st|in)\b/)
=> ["cost", "akin", "east", "against"]

# capturing wasn't needed here, only common grouping and quantifier
>> '123hand42handy777handful500'.split(/hand(?:y|ful)?/)
=> ["123", "42", "777", "500"]

# with normal grouping, need to keep track of all the groups
>> '1,2,3,4,5,6,7'.sub(/\A(([^,]+,){3})([^,]+)/, '\1(\3)')
=> "1,2,3,(4),5,6,7"
# using non-capturing groups, only relevant groups have to be tracked
>> '1,2,3,4,5,6,7'.sub(/\A((?:[^,]+,){3})([^,]+)/, '\1(\2)')
=> "1,2,3,(4),5,6,7"
```

However, there are situations where capture groups cannot be avoided. To some extent, `gsub` can be used instead of `scan`. Recall that `gsub` can return an Enumerator which can be hacked to simulate `scan` like behavior.

```ruby
# same as: scan(/\b\w*(?:st|in)\b/) but using capture group for gsub
>> 'cost akin more east run against'.gsub(/\b\w*(st|in)\b/).to_a
=> ["cost", "akin", "east", "against"]
# same as: scan(/\b\w*(?:st|in)\b/).map(&:upcase)
>> 'cost akin more east run against'.gsub(/\b\w*(st|in)\b/).map(&:upcase)
=> ["COST", "AKIN", "EAST", "AGAINST"]

# now for an example that is not possible with scan
# get whole words containing at least one consecutive repeated character
>> 'effort flee facade oddball rat tool'.gsub(/\b\w*(\w)\1\w*\b/).to_a
=> ["effort", "flee", "oddball", "tool"]
```

## Named capture groups

Regexp can get cryptic and difficult to maintain, even for seasoned programmers. There are a few constructs to help add clarity. One such is naming the capture groups and using that name for backreferencing instead of plain numbers. The syntax is `(?<name>regexp)` or `(?'name'regexp)` for naming the capture groups and `\k<name>` for backreferencing. Named capture groups and normal capture groups cannot be used at the same time.

```ruby
# giving names to first and second captured words
>> 'a,b 42,24'.gsub(/(?<fw>\w+),(?<sw>\w+)/, '\k<sw>,\k<fw>')
=> "b,a 24,42"
# alternate syntax
>> 'a,b 42,24'.gsub(/(?'fw'\w+),(?'sw'\w+)/, '\k<sw>,\k<fw>')
=> "b,a 24,42"
```

Named capture group can be used for backreferencing with `\g` as well

```ruby
>> row = 'today,2008-03-24,food,2012-08-12,nice,5632'
=> "today,2008-03-24,food,2012-08-12,nice,5632"

>> row.match(/(?<date>\d{4}-\d{2}-\d{2}).*\g<date>/)[0]
=> "2008-03-24,food,2012-08-12"
```

If you recall, both `regexp =~ string` and `string =~ regexp` forms can be used. One advantage of first syntax is that named capture groups will also create variables with those names and can be used instead of relying on global variables.

```ruby
>> details = '2018-10-25,car'
=> "2018-10-25,car"

>> /(?<date>[^,]+),(?<product>[^,]+)/ =~ details
=> 0

# same as: $1
>> date
=> "2018-10-25"
# same as: $2
>> product
=> "car"
```

This chapter covered many more features related to grouping - backreferencing to get both variable and function like behavior, and naming the groups to add clarity. When backreference is not needed for a particular group, use non-capturing group.

<br>

For practice problems, visit [Exercises](https://github.com/learnbyexample/Ruby_Regexp/blob/master/exercises/Exercises.md) file from the repository.

