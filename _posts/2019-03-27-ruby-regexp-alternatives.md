---
title: "Ruby Regexp Part 3 - Alternatives"
categories:
  - ebook
tags:
  - ruby
  - regular-expressions
date: 2019-03-27T17:02:19
---

![alternatives](/images/ruby_regexp/alternatives.png)

*Photo Credit: [Markus Spiske](https://unsplash.com/photos/QVVXPNbjLrI) on [Unsplash](https://unsplash.com)*

This is third post in a series, where I'll be posting chapters from my free [Ruby Regexp](https://github.com/learnbyexample/Ruby_Regexp) book. Regular expression syntax and features vary from one language to another. Still, the core concept is same and you could benefit from this series even if you do not use Ruby. You can download the ebook from any of these links for free or pay what you wish:

* [gumroad](https://gumroad.com/l/rubyregexp)
* [leanpub](https://leanpub.com/rubyregexp)

# Alternation and Grouping

Many a times, you'd want to search for multiple terms. Like selecting only apples and oranges from a basket of assorted fruits or red and yellow leaves from a pile. In a conditional expression, you can use the logical operators to combine multiple conditions. With regular expressions, the `|` metacharacter is similar to logical OR. The regexp will match if any of the expression separated by `|` is satisfied. These can have their own independent anchors as well.

```ruby
# match either 'cat' or 'dog'
>> 'I like cats'.match?(/cat|dog/)
=> true
>> 'I like dogs'.match?(/cat|dog/)
=> true
>> 'I like parrots'.match?(/cat|dog/)
=> false

# replace either 'cat' at start of string or 'cat' at end of word
>> 'catapults concatenate cat scat'.gsub(/\Acat|cat\b/, 'X')
=> "Xapults concatenate X sX"

# replace either 'cat' or 'dog' or 'fox' with 'mammal'
>> 'cat dog bee parrot fox'.gsub(/cat|dog|fox/, 'mammal')
=> "mammal mammal bee parrot mammal"
```

You might infer from above examples that there can be cases where lots of alternation is required. The `Regexp.union` method can be used to build the alternation list automatically.  It accepts an array as argument or a list of comma separated arguments. In either case, each element will be attempted to be converted as regexp literal first (the significance of this will be covered in later chapters).

```ruby
>> Regexp.union('car', 'jeep')
=> /car|jeep/

>> words = %w[cat dog fox]
=> ["cat", "dog", "fox"]
>> pat = Regexp.union(words)
=> /cat|dog|fox/
>> 'cat dog bee parrot fox'.gsub(pat, 'mammal')
=> "mammal mammal bee parrot mammal"
```

Often, there are some common things among the regexp alternatives. It could be common characters or regexp qualifiers like the anchors. In such cases, you can group them using a pair of parentheses metacharacters. Similar to `a(b+c) = ab+ac` in maths, you get `a(b|c) = ab|ac` in regexp.

```ruby
# without grouping
>> 'red reform read arrest'.gsub(/reform|rest/, 'X')
=> "red X read arX"
# with grouping
>> 'red reform read arrest'.gsub(/re(form|st)/, 'X')
=> "red X read arX"

# without grouping
>> 'par spare part party'.gsub(/\bpar\b|\bpart\b/, 'X')
=> "X spare X party"
# taking out common anchors
>> 'par spare part party'.gsub(/\b(par|part)\b/, 'X')
=> "X spare X party"
# taking out common characters as well
# you'll later learn a better technique instead of using empty alternate
>> 'par spare part party'.gsub(/\bpar(|t)\b/, 'X')
=> "X spare X party"
```

There's lot more features to grouping than just forming terse regexps. For now, this is a good place to introduce `Regexp.source` method, which will help to interpolate a regexp literal inside another regexp. For ex: adding anchors to alternation list created using the `Regexp.union` method.

```ruby
>> words = %w[cat par]
=> ["cat", "par"]
>> alt = Regexp.union(words)
=> /cat|par/
>> alt_w = /\b(#{alt.source})\b/
=> /\b(cat|par)\b/

>> 'cater cat concatenate par spare'.gsub(alt, 'X')
=> "Xer X conXenate X sXe"
>> 'cater cat concatenate par spare'.gsub(alt_w, 'X')
=> "cater X concatenate X spare"
```

The above example will work without `Regexp.source` method too, but you'll see that `(?-mix:cat|par)` is inserted instead of `cat|par`. Their meaning will be explained in **Modifiers** chapter.

## Precedence rules

There's some tricky situations when using alternation. If it is used for testing a match to get `true/false` against a string input, there is no ambiguity. However, for other things like string replacement, it depends on a few factors. Say, you want to replace either `are` or `spared` - which one should get precedence? The bigger word `spared` or the substring `are` inside it or based on something else?

In Ruby, the regexp alternative which matches earliest in the input string gets precedence.

```ruby
>> words = 'lion elephant are rope not'
=> "lion elephant are rope not"
>> words =~ /on/
=> 2
>> words =~ /ant/
=> 10

# starting index of 'on' < index of 'ant' for given string input
# so 'on' will be replaced irrespective of order of regexp
>> words.sub(/on|ant/, 'X')
=> "liX elephant are rope not"
>> words.sub(/ant|on/, 'X')
=> "liX elephant are rope not"
```

So, what happens if two or more alternatives match on same index? The precedence is then left to right in the order of declaration.

```ruby
>> mood = 'best years'
=> "best years"
>> mood =~ /year/
=> 5
>> mood =~ /years/
=> 5

# starting index for 'year' and 'years' will always be same
# so, which one gets replaced depends on the order of regexp
>> mood.sub(/year|years/, 'X')
=> "best Xs"
>> mood.sub(/years|year/, 'X')
=> "best X"
```

Another example with `gsub` to drive home the issue:

```ruby
>> words = 'ear xerox at mare part learn eye'
=> "ear xerox at mare part learn eye"

# this is going to be same as: gsub(/ar/, 'X')
>> words.gsub(/ar|are|art/, 'X')
=> "eX xerox at mXe pXt leXn eye"
# this is going to be same as: gsub(/are|ar/, 'X')
>> words.gsub(/are|ar|art/, 'X')
=> "eX xerox at mX pXt leXn eye"
# phew, finally this one works as you wanted
>> words.gsub(/are|art|ar/, 'X')
=> "eX xerox at mX pX leXn eye"
```

If you do not want substrings to sabotage your replacements, a robust workaround is to sort the alternations based on length, longest first.

```ruby
>> words = %w[hand handy handful]
=> ["hand", "handy", "handful"]
>> alt = Regexp.union(words.sort_by { |w| -w.length })
=> /handful|handy|hand/

>> 'hands handful handed handy'.gsub(alt, 'X')
=> "Xs X Xed X"
# without sorting, order will come into play
>> 'hands handful handed handy'.gsub(Regexp.union(words), 'X')
=> "Xs Xful Xed Xy"
```

So, this chapter was about specifying one or more alternate matches within the same regexp using `|` metacharacter. Which can further be simplified using `()` grouping if there are common aspects among the alternations. Among the alternations, earliest matching pattern gets precedence. Left to right ordering is used as a tie-breaker if multiple alternations match starting from same location. You also learnt couple of `Regexp` methods that help to programmatically construct a regexp literal.

# Escaping metacharacters

You have seen a few metacharacters and escape sequences that help to compose a regexp literal.  To match the metacharacters literally, i.e. to remove their special meaning, prefix those characters with a `\` character. To indicate a literal `\` character, use `\\`.

To spice up the examples a bit, block form has been used to modify the matched portion of string with an expression. In later chapters, you'll see more ways to work directly with matched strings.

```ruby
# even though ^ is not being used as anchor, it won't be matched literally
>> 'a^2 + b^2 - C*3'.match?(/b^2/)
=> false
# escaping will work
>> 'a^2 + b^2 - C*3'.gsub(/(a|b)\^2/) { |m| m.upcase }
=> "A^2 + B^2 - C*3"

>> '(a*b) + c'.gsub(/\(|\)/, '')
=> "a*b + c"

>> '\learn\by\example'.gsub(/\\/, '/')
=> "/learn/by/example"
```

As emphasized earlier, regular expression is just another tool to process text. Some examples and exercises presented in this book can be solved using normal string methods as well. For real world use cases, ask yourself first if regexp is needed at all?

```ruby
>> eqn = 'f*(a^b) - 3*(a^b)'
=> "f*(a^b) - 3*(a^b)"

# straightforward search and replace, no need regexp shenanigans
>> eqn.gsub('(a^b)', 'c')
=> "f*c - 3*c"
```

Okay, what if you have a string variable that must be used to construct a regexp literal - how to escape all the metacharacters? Relax, `Regexp.escape` method has got you covered. No need to manually take care of all the metacharacters or worry about changes in future versions. What's more, the `Regexp.union` method takes care of escaping string arguments as well!

```ruby
>> expr = '(a^b)'
=> "(a^b)"
>> puts Regexp.escape(expr)
\(a\^b\)
>> Regexp.union('foo_baz', expr)
=> /foo_baz|\(a\^b\)/

# replace only at end of string
>> eqn.sub(/#{Regexp.escape(expr)}\z/, 'c')
=> "f*(a^b) - 3*c"
```

Another character to keep track for escaping is the delimiter used to define the regexp literal.  Or, you can use a different delimiter than `/` to define a regexp literal using `%r` to avoid escaping. Also, you need not worry about unescaped delimiter inside `#{}` interpolation.

```ruby
>> path = '/foo/123/foo/baz/ip.txt'
=> "/foo/123/foo/baz/ip.txt"

# this is known as 'leaning toothpick syndrome'
>> path.sub(/\A\/foo\/123\//, '~/')
=> "~/foo/baz/ip.txt"
# a different delimiter improves readability and reduces typos
>> path.sub(%r#\A/foo/123/#, '~/')
=> "~/foo/baz/ip.txt"
```

<br>

For practice problems, visit [Exercises](https://github.com/learnbyexample/Ruby_Regexp/blob/master/exercises/Exercises.md) file from the repository.

