---
title: "Ruby Regexp Part 10 - Miscellaneous"
categories:
  - ebook
tags:
  - ruby
  - regular-expressions
date: 2019-04-05T12:12:44
---

![misc](/images/ruby_regexp/misc.jpg)

*Photo Credit: [Markus Spiske](https://unsplash.com/photos/0VNVxhEnkII) on [Unsplash](https://unsplash.com)*

This is tenth post in a series, where I'll be posting chapters from my free [Ruby Regexp](https://github.com/learnbyexample/Ruby_Regexp) book. Regular expression syntax and features vary from one language to another. Still, the core concept is same and you could benefit from this series even if you do not use Ruby. You can download the ebook from any of these links for free or pay what you wish:

* [gumroad](https://gumroad.com/l/rubyregexp)
* [leanpub](https://leanpub.com/rubyregexp)

With this post, all of the ebook is covered. There may be more posts in future like cheatsheets, common regexp explained, etc.

# Miscellaneous

This chapter will cover some more regexp features and useful tricks.

## Using hashes

Using block form and global variables, you can use a hash variable to determine the replacement string based on the matched text. If the requirement is as simple as passing entire matched portion to the hash variable, both `sub` and `gsub` methods accept a hash instead of string in replacement section.

```ruby
# one to one mappings
>> h = { '1' => 'one', '2' => 'two', '4' => 'four' }
=> {"1"=>"one", "2"=>"two", "4"=>"four"}
>> '9234012'.gsub(/[124]/) { h[$&] }
=> "9two3four0onetwo"

# or, simply pass hash variable as replacement argument
>> '9234012'.gsub(/[124]/, h)
=> "9two3four0onetwo"

# if the matched text doesn't exist as a key, default value will be used
>> h.default = 'X'
=> "X"
>> '9234012'.gsub(/\d/, h)
=> "XtwoXfourXonetwo"
```

For swapping two or more strings without using intermediate result, using a hash is recommended.

```ruby
>> swap = { 'cat' => 'tiger', 'tiger' => 'cat' }
=> {"cat"=>"tiger", "tiger"=>"cat"}

# replace word if it exists as key, else leave it as is
>> 'cat tiger dog tiger cat'.gsub(/\w+/) { swap[$&] || $& }
=> "tiger cat dog cat tiger"

# or, build the alternation regexp manually for simple cases
>> 'cat tiger dog tiger cat'.gsub(/cat|tiger/, swap)
=> "tiger cat dog cat tiger"
```

For hashes that have many entries and likely to undergo changes during development, building alternation list manually is not a good choice. Also, recall that as per precedence rules, longest length string should come first.

```ruby
>> h = { 'hand' => 1, 'handy' => 2, 'handful' => 3 }
=> {"hand"=>1, "handy"=>2, "handful"=>3}

>> re = Regexp.union(h.keys.sort_by { |w| -w.length })
=> /handful|handy|hand/
>> 'handful hand pin handy'.gsub(re, h)
=> "3 1 pin 2"
```

## \G anchor

The `\G` anchor restricts matching from start of string like the `\A` anchor. In addition, after a match is done, ending of that match is considered as the new anchor location. This process is repeated again and continues until the given regexp fails to match (assuming multiple matches with methods like `scan` and `gsub`).

```ruby
# all non-whitespace characters from start of string
>> '123-87-593 42 foo'.scan(/\G\S/)
=> ["1", "2", "3", "-", "8", "7", "-", "5", "9", "3"]
>> '123-87-593 42 foo'.gsub(/\G\S/, '*')
=> "********** 42 foo"

# all digits and optional hyphen combo from start of string
>> '123-87-593 42 foo'.scan(/\G\d+-?/)
=> ["123-", "87-", "593"]
>> '123-87-593 42 foo'.gsub(/\G(\d+)(-?)/, '(\1)\2')
=> "(123)-(87)-(593) 42 foo"

# all word characters from start of string
# only if it is followed by word character
>> 'cat12 bat pin'.gsub(/\G\w(?=\w)/, '\0:')
=> "c:a:t:1:2 bat pin"

# all lowercase alphabets or space from start of string
>> 'par tar-den hen-food mood'.gsub(/\G[a-z ]/, '(\0)')
=> "(p)(a)(r)( )(t)(a)(r)-den hen-food mood"
```

## Recursive matching

The `\g` subexpression call was introduced as analogous to function call. And in typical function fashion, it does support recursion. Useful to match nested patterns, which is usually not recommended to be done with regular expressions. Indeed, if you are looking to parse file formats like html, xml, json, csv, etc - use a proper parser library. But for some cases, a parser might not be available and using regexp might be simpler than writing a parser from scratch.

First up, matching a set of parentheses that is not nested (termed as level-one regexp for reference).

```ruby
# note the use of possessive quantifier
>> 'a + (b * c) - (d / e)'.scan(/\([^()]++\)/)
=> ["(b * c)", "(d / e)"]

>> '((f+x)^y-42)*((3-g)^z+2)'.scan(/\([^()]++\)/)
=> ["(f+x)", "(3-g)"]
```

Next, matching a set of parentheses which may optionally contain any number of non-nested sets of parentheses (termed as level-two regexp for reference).

```ruby
# note the use of non-capturing group
>> '((f+x)^y-42)*((3-g)^z+2)'.scan(/\((?:[^()]++|\([^()]++\))++\)/)
=> ["((f+x)^y-42)", "((3-g)^z+2)"]

>> 'a + (b) + ((c)) + (((d)))'.scan(/\((?:[^()]++|\([^()]++\))++\)/)
=> ["(b)", "((c))", "((d))"]
```

That looks very cryptic. Better to use `x` modifier for clarity as well as for comparing against the recursive version. Breaking down the regexp, you can see `(` and `)` have to be matched literally. Inside that, valid string is made up of either non-parentheses characters or a non-nested parentheses sequence (level-one regexp).

```ruby
>> lvl2 = /\(               #literal (
             (?:            #start of non-capturing group
               [^()]++      #non-parentheses characters
               |            #OR
               \([^()]++\)  #level-one regexp
             )++            #end of non-capturing group, 1 or more times
           \)               #literal )
          /x

>> '((f+x)^y-42)*((3-g)^z+2)'.scan(lvl2)
=> ["((f+x)^y-42)", "((3-g)^z+2)"]

>> 'a + (b) + ((c)) + (((d)))'.scan(lvl2)
=> ["(b)", "((c))", "((d))"]
```

To recursively match any number of nested sets of parentheses, use a capture group and call it within the capture group itself. Since entire regexp needs to be called here, you can use the default zeroth capture group (this also helps to avoid having to use `gsub+to_a` trick).  Comparing with level-two regexp, the only change is that `\g<0>` is used instead of the level-one regexp in the second alternation.

```ruby
>> lvln = /\(               #literal (
             (?:            #start of non-capturing group
               [^()]++      #non-parentheses characters
               |            #OR
               \g<0>        #recursive call
             )++            #end of non-capturing group, 1 or more times
           \)               #literal )
          /x

>> 'a + (b * c) - (d / e)'.scan(lvln)
=> ["(b * c)", "(d / e)"]

>> '((f+x)^y-42)*((3-g)^z+2)'.scan(lvln)
=> ["((f+x)^y-42)", "((3-g)^z+2)"]

>> 'a + (b) + ((c)) + (((d)))'.scan(lvln)
=> ["(b)", "((c))", "(((d)))"]

>> '(3+a) * ((r-2)*(t+2)/6) + 42 * (a(b(c(d(e)))))'.scan(lvln)
=> ["(3+a)", "((r-2)*(t+2)/6)", "(a(b(c(d(e)))))"]
```

You can also use online tools for better understanding of complex regexps. For example: [jex: level-two matching](https://jex.im/regulex/#!flags=&re=%5C((%3F%3A%5B%5E()%5D%2B%7C%5C(%5B%5E()%5D%2B%5C))%2B%5C)) shows how it contains the level-one matching and recursive nature of this regexp. Note that the site only supports JavaScript regular expressions, but close enough for this case.

![level-two matching](/images/ruby_regexp/level_two.png)

## Substitution in conditional expression

The `sub!` and `gsub!` methods return `nil` if substitution fails. That makes them usable as part of a conditional expression leading to creative and terser solutions.

```ruby
>> num = '4'
=> "4"
>> puts "#{num} apples" if num.sub!(/\d+/) { $&.to_i ** 2 }
16 apples

>> word, cnt = ['coffining', 0]
=> ["coffining", 0]
>> cnt += 1 while word.sub!(/fin/, '')
=> nil
>> [word, cnt]
=> ["cog", 2]
```

Here's an example that won't work if greedy quantifier is used instead of possessive quantifier.

```ruby
>> row = '421,foo,2425,42,5,foo,6,6,42'
=> "421,foo,2425,42,5,foo,6,6,42"

# similar to: row.split(',').uniq.join(',')
# lookarounds used to ensure start/end of column matching
# possessive quantifier used to ensure partial column is not captured
# if a column has same text as another column, the latter column is deleted
>> nil while row.gsub!(/(?<=\A|,)([^,]++).*\K,\1(?=,|\z)/, '')
=> nil
>> row
=> "421,foo,2425,42,5,6"
```

This is a miscellaneous chapter, not able to think of a good catchy summary to write.  Here's a suggestion - write a summary in your own words based on notes you've made for this chapter.

# Gotchas

Regexp can get quite complicated and cryptic a lot of the times. But sometimes, if something is not working as expected, it could be because of quirky corner cases.

If there is a newline character at end of string, there is an additional end of line match but no additional start of line match.

```ruby
>> puts "1\n2\n".gsub(/^/, 'foo ')
foo 1
foo 2
>> puts "1\n\n".gsub(/^/, 'foo ')
foo 1
foo 

>> puts "1\n2\n".gsub(/$/, ' baz')
1 baz
2 baz
 baz
>> puts "1\n\n".gsub(/$/, ' baz')
1 baz
 baz
 baz
```

How much does `*` or `*+` match?

```ruby
# there is an extra empty string match at end of non-empty columns
>> ',cat,tiger'.gsub(/[^,]*/, '{\0}')
=> "{},{cat}{},{tiger}{}"
>> ',cat,tiger'.gsub(/[^,]*+/, '{\0}')
=> "{},{cat}{},{tiger}{}"

# use lookarounds as a workaround
>> ',cat,tiger'.gsub(/(?<=\A|,)[^,]*+/, '{\0}')
=> "{},{cat},{tiger}"
```

Don't use `\K` if there are consecutive matches (this is because of how the regexp engine has been implemented, other libraries like PCRE don't have this limitation).

```ruby
>> ',cat,tiger'.gsub(/(?<=\A|,)[^,]*+/, '{\0}')
=> "{},{cat},{tiger}"
>> ',cat,tiger'.gsub(/(?:\A|,)\K[^,]*+/, '{\0}')
=> "{},cat,{tiger}"

>> 'abcd 123456'.gsub(/(?<=\w)/, ':')
=> "a:b:c:d: 1:2:3:4:5:6:"
>> 'abcd 123456'.gsub(/\w/, '\0:')
=> "a:b:c:d: 1:2:3:4:5:6:"
>> 'abcd 123456'.gsub(/\w\K/, ':')
=> "a:bc:d 1:23:45:6"
```

Referring to text matched by a capture group with a quantifier will give only the last match, not entire match. Use a non-capturing group inside a capture group to get the entire matched portion.

```ruby
>> '1,2,3,4,5,6,7'.sub(/\A([^,]+,){3}([^,]+)/, '\1(\2)')
=> "3,(4),5,6,7"
>> '1,2,3,4,5,6,7'.sub(/\A((?:[^,]+,){3})([^,]+)/, '\1(\2)')
=> "1,2,3,(4),5,6,7"

# as mentioned earlier, scan can be useful for debugging purposes
>> '1,2,3,4,5,6,7'.scan(/([^,]+,){3}/)
=> [["3,"], ["6,"]]
>> '1,2,3,4,5,6,7'.scan(/(?:[^,]+,){3}/)
=> ["1,2,3,", "4,5,6,"]
```

In a somewhat similar fashion, using `\g` will give the newer matched text instead of the original capture group when referred.

```ruby
>> d = '2008-03-24,2012-08-12 2017-06-27,2018-03-25 1999-12-23,2001-05-08'
=> "2008-03-24,2012-08-12 2017-06-27,2018-03-25 1999-12-23,2001-05-08"

# output has the value matched by \g<1> and not the capture group
>> d.scan(/(\d{4}-\d{2}-\d{2}),\g<1>/)
=> [["2012-08-12"], ["2018-03-25"], ["2001-05-08"]]

# this will retain the second date of each pair
>> d.gsub(/(\d{4}-\d{2}-\d{2}),\g<1>/, '\1')
=> "2012-08-12 2018-03-25 2001-05-08"
# to retain the first date of each pair, use another capture group
# and adjust the backreference numbers
>> d.gsub(/((\d{4}-\d{2}-\d{2})),\g<2>/, '\1')
=> "2008-03-24 2017-06-27 1999-12-23"
```

So, there you go. A list of gotchas (possibly bug/feature, you decide) to round up this book on the exciting world of regular expressions. Also, do take a look at other great learning resources listed in final chapter.

<br>

For practice problems, visit [Exercises](https://github.com/learnbyexample/Ruby_Regexp/blob/master/exercises/Exercises.md) file from the repository.

# Further Reading

Note that most of these resources are not specific to Ruby, so use them with caution and check if they apply to Ruby's syntax and features

* [rubular](https://rubular.com/) - Ruby regular expression editor, handy way to test your regexp
* [stackoverflow: ruby regexp](https://stackoverflow.com/questions/tagged/ruby+regex?sort=votes&pageSize=15)
* [regexp-examples](https://github.com/tom-lord/regexp-examples) - Generate strings that match a given Ruby regular expression
* [stackoverflow: regex FAQ](https://stackoverflow.com/questions/22937618/reference-what-does-this-regex-mean)
    * [stackoverflow: regex tag](https://stackoverflow.com/questions/tagged/regex) is a good source of exercise questions
* [rexegg](https://www.rexegg.com/) - tutorials, tricks and more
* [regular-expressions](https://www.regular-expressions.info/) - tutorials and tools
* [regexcrossword](https://regexcrossword.com/) - tutorials and puzzles
* [regulex](https://jex.im/regulex) - for visualization
* [swtch](https://swtch.com/~rsc/regexp/regexp1.html) - stuff about regular expression implementation engines

Here's some links for specific topics:

* [rexegg: best regex trick](https://www.rexegg.com/regex-best-trick.html)
* [regular-expressions: matching numeric ranges](https://www.regular-expressions.info/numericranges.html)
* [regular-expressions: Continuing at The End of The Previous Match](https://www.regular-expressions.info/continue.html), especially the second section that discusses about implementation detail
* [regular-expressions: Zero-Length Matches](https://www.regular-expressions.info/zerolength.html)
* [stackoverflow: Greedy vs Reluctant vs Possessive Quantifiers](https://stackoverflow.com/questions/5319840/greedy-vs-reluctant-vs-possessive-quantifiers)
* [stackoverflow: named captures as a hash](https://stackoverflow.com/questions/18825669/how-to-do-named-capture-in-ruby)

