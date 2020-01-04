---
title: "Ruby Regexp Part 5 - Matched portions"
categories:
  - ebook
tags:
  - ruby
  - regular-expressions
date: 2019-03-29T18:23:41
---

![matched portions](/images/ruby_regexp/matched_portions.png)

*Photo Credit: [Benny Jackson](https://unsplash.com/photos/TilfTdj3x6U) on [Unsplash](https://unsplash.com)*

This is fifth post in a series, where I'll be posting chapters from my free [Ruby Regexp](https://github.com/learnbyexample/Ruby_Regexp) book. Regular expression syntax and features vary from one language to another. Still, the core concept is same and you could benefit from this series even if you do not use Ruby. You can download the ebook from any of these links for free or pay what you wish:

* [gumroad](https://gumroad.com/l/rubyregexp)
* [leanpub](https://leanpub.com/rubyregexp)

# Working with matched portions

Having seen a few regexp features that can match varying text, you'll learn how to extract and work with those matching portions in this chapter.

## match

First up, the `match` method which is similar to `match?` method. Both these methods accept a regexp and an optional index to indicate the starting location. Furthermore, these methods treat a string argument as if it was a regexp all along (which is not the case with other string methods like `sub`, `split`, etc). The `match` method returns a `MatchData` object from which various details can be extracted like the matched portion of string, location of matched portion, etc. See [ruby-doc: MatchData](https://ruby-doc.org/core-2.5.0/MatchData.html) for details.

```ruby
# only the first matching portion is considered
>> 'abc ac adc abbbc'.match(/ab*c/)
=> #<MatchData "abc">

# string argument is treated same as a regexp
>> 'abc ac adc abbbc'.match('a.*d')
=> #<MatchData "abc ac ad">

# second argument specifies starting location to start the matching
>> 'abc ac adc abbbc'.match(/ab*c/, 7)
=> #<MatchData "abbbc">
```

The regexp grouping inside `()` is also known as a **capture group**. It has multiple uses, one of which is the ability to work with matched portions of those groups. When capture groups are used with `match` method, they can be retrieved using array index slicing on the `MatchData` object. The first element is always the entire matched portion and rest of the elements are for capture groups if they are present.

```ruby
>> 'abc ac adc abbbc'.match(/a.*d/)
=> #<MatchData "abc ac ad">
# retrieving entire matched portion
>> 'abc ac adc abbbc'.match(/a.*d/)[0]
=> "abc ac ad"

# capture group example
>> 'abc ac adc abbbc'.match(/a(.*)d(.*a)/).to_a
=> ["abc ac adc a", "bc ac a", "c a"]
>> 'abc ac adc abbbc'.match(/a(.*)d(.*a)/)[1]
=> "bc ac a"
```

The `match` method also supports block form, which is executed only if the regexp matching succeeds.

```ruby
>> 'abc ac adc abbbc'.match(/a(.*)d(.*a)/) { |m| puts m[2], m[1] }
c a
bc ac a
=> nil
>> 'abc ac adc abbbc'.match(/xyz/) { 2 * 3 }
=> nil
```

If you are a fan of code golfing, you can use a regexp inside `[]` on a string object to replicate some features of the `match` and `sub!` methods.

```ruby
# same as: match(/c.*d/)[0]
>> 'abc ac adc abbbc'[/c.*d/]
=> "c ac ad"

# same as: match(/a(.*)d(.*a)/)[1]
>> 'abc ac adc abbbc'[/a(.*)d(.*a)/, 1]
=> "bc ac a"

# same as: match(/ab*c/, 7)[0]
>> 'abc ac adc abbbc'[7..-1][/ab*c/]
=> "abbbc"

>> word = 'elephant'
=> "elephant"
# same as: sub!(/e.*h/, 'w')
>> word[/e.*h/] = 'w'
=> "w"
>> word
=> "want"
```

## scan

The `scan` method returns all the matched portions as an array.

```ruby
>> 'abc ac adc abbbc'.scan(/ab*c/)
=> ["abc", "ac", "abbbc"]

>> 'abc ac adc abbbc'.scan(/ab+c/)
=> ["abc", "abbbc"]

>> 'par spar apparent spare part'.scan(/\bs?pare?\b/)
=> ["par", "spar", "spare"]
```

It is a useful method for debugging purposes as well, for example to see what is going on under the hood before applying substitution methods.

```ruby
>> 'that is quite a fabricated tale'.scan(/t.*a/)
=> ["that is quite a fabricated ta"]

>> 'that is quite a fabricated tale'.scan(/t.*?a/)
=> ["tha", "t is quite a", "ted ta"]
```

If capture groups are used, each element of output will be an array of strings of all the capture groups. Text matched by regexp outside of capture groups won't be present in the output array.

```ruby
>> 'abc ac adc abbc xabbbcz bbb bc abbbbbc'.scan(/a(b*)c/)
=> [["b"], [""], ["bb"], ["bbb"], ["bbbbb"]]

>> 'xx:yyy x: x:yy :y'.scan(/(x*):(y*)/)
=> [["xx", "yyy"], ["x", ""], ["x", "yy"], ["", "y"]]
```

Use block form to iterate over the matched portions.

```ruby
>> 'abc ac adc abbbc'.scan(/ab+c/) { |m| puts m.upcase }
ABC
ABBBC

>> 'xx:yyy x: x:yy :y'.scan(/(x*):(y*)/) { |a, b| puts a.size + b.size }
5
1
3
1
```

## regexp global variables

An expression involving regexp also sets some of the global variables, unless otherwise specified like the `match?` method. First up, these four global variables:

* `$~` contains `MatchData` object
* ``$` `` string before the matched portion
* `$&` matched portion
* `$'` string after the matched portion

Here's an example:

```ruby
>> sentence = 'that is quite a fabricated tale'
=> "that is quite a fabricated tale"
>> sentence =~ /q.*b/
=> 8

>> $~
=> #<MatchData "quite a fab">
>> $~[0]
=> "quite a fab"
>> $`
=> "that is "
>> $&
=> "quite a fab"
>> $'
=> "ricated tale"
```

For multiple matches, like for `gsub` method, the global variables will be updated for each match. Referring to them in later instructions will give you information only for the final match.

```ruby
# same as: { |m| puts m.upcase }
>> 'abc ac adc abbbc'.scan(/ab+c/) { puts $&.upcase }
ABC
ABBBC

>> $~
=> #<MatchData "abbbc">
>> $`
=> "abc ac adc "
```

Apart from getting capture groups using `$~`, you can also use `$N` where N is the capture group you want. `$1` will have string matched by first group, `$2` will have string matched by second group and so on. As a special case, `$+` will have string matched by last group.  Default value is `nil` if that particular capture group wasn't used in the regexp.

```ruby
>> sentence = 'that is quite a fabricated tale'
=> "that is quite a fabricated tale"
>> sentence =~ /a.*(q.*(f.*b).*c)(.*a)/
=> 2

>> $&
=> "at is quite a fabricated ta"
>> $1
=> "quite a fabric"
>> $2
=> "fab"
>> $+
=> "ated ta"
>> $4
=> nil

# $~ is handy if array slicing, negative index, etc are needed
>> $~[-2]
=> "fab"
```

This chapter introduced different ways to work with various matching portions of input string.  You learnt another use of groupings and you'll see even more uses of groupings later on.

<br>

For practice problems, visit [Exercises](https://github.com/learnbyexample/Ruby_Regexp/blob/master/exercises/Exercises.md) file from the repository.

