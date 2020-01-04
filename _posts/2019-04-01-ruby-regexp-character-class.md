---
title: "Ruby Regexp Part 6 - Character class"
categories:
  - ebook
tags:
  - ruby
  - regular-expressions
date: 2019-04-01T13:27:02
---

![character class](/images/ruby_regexp/character_class.png)

*Photo Credit: [Megan Savoie](https://unsplash.com/photos/bHoBMkArD5k) on [Unsplash](https://unsplash.com)*

This is sixth post in a series, where I'll be posting chapters from my free [Ruby Regexp](https://github.com/learnbyexample/Ruby_Regexp) book. Regular expression syntax and features vary from one language to another. Still, the core concept is same and you could benefit from this series even if you do not use Ruby. You can download the ebook from any of these links for free or pay what you wish:

* [gumroad](https://gumroad.com/l/rubyregexp)
* [leanpub](https://leanpub.com/rubyregexp)

# Character class

To create a custom placeholder for limited set of characters, enclose them inside `[]` metacharacters.  It is similar to using single character alternations inside a grouping, but without the drawbacks of a capture group. In addition, character classes have their own versions of metacharacters and provide special predefined sets for common use cases. Quantifiers are also applicable to character classes.

```ruby
# same as: /cot|cut/ or /c(o|u)t/
>> %w[cute cat cot coat cost scuttle].grep(/c[ou]t/)
=> ["cute", "cot", "scuttle"]

# same as: /(a|e|o)+t/
>> 'meeting cute boat site foot'.gsub(/[aeo]+t/, 'X')
=> "mXing cute bX site fX"

>> 'Sample123string42with777numbers'.scan(/[0123456789]+/)
=> ["123", "42", "777"]
```

## Metacharacters

Character classes have their own metacharacters to help define the sets succinctly. Metacharacters outside of character classes like `^`, `$`, `()` etc either don't have special meaning or have completely different one inside the character classes. First up, the `-` metacharacter that helps to define a range of characters instead of having to specify them all individually.

```ruby
# all digits
>> 'Sample123string42with777numbers'.scan(/[0-9]+/)
=> ["123", "42", "777"]

# whole words made up of lowercase alphabets only
>> 'coat Bin food tar12 best'.scan(/\b[a-z]+\b/)
=> ["coat", "food", "best"]

# whole words made up of lowercase alphabets and digits only
>> 'coat Bin food tar12 best'.scan(/\b[a-z0-9]+\b/)
=> ["coat", "food", "tar12", "best"]

# whole words made up of lowercase alphabets, but starting with 'p' to 'z'
>> 'coat tin food put stoop best'.scan(/\b[p-z][a-z]*\b/)
=> ["tin", "put", "stoop"]

# whole words made up of only 'a' to 'f' and 'p' to 't' lowercase alphabets
>> 'coat tin food put stoop best'.scan(/\b[a-fp-t]+\b/)
=> ["best"]
```

Character classes can also be used to construct numeric ranges. However, it is easy to miss corner cases and some ranges are complicated to design. Wherever possible, like `gsub` method, you can also use block form and apply actual numeric operators.

```ruby
# numbers between 10 to 29
>> '23 154 12 26 98234'.scan(/\b[12][0-9]\b/)
=> ["23", "12", "26"]

# numbers >= 100
>> '23 154 12 26 98234'.scan(/\b[0-9]{3,}\b/)
=> ["154", "98234"]

# numbers >= 100 if there are leading zeros
>> '0501 035 154 12 26 98234'.scan(/\b0*[1-9][0-9]{2,}\b/)
=> ["0501", "154", "98234"]

# numbers < 350
>> '45 349 651 593 4 204'.gsub(/[0-9]+/) { $&.to_i < 350 ? 0 : 1 }
=> "0 0 1 1 0 0"
# numbers between 200 and 650
>> '45 349 651 593 4 204'.gsub(/[0-9]+/) { (200..650) === $&.to_i ? 0 : 1 }
=> "1 0 1 0 1 0"
```

Next metacharacter is `^` which has to specified as the first character of the character class.  It negates the set of characters, so all characters other than those specified will be matched.  As highlighted earlier, handle negative logic with care, you might end up matching more than you wanted. Also, these examples below are all excellent places to use possessive quantifier as there is no backtracking involved.

```ruby
# all non-digits
>> 'Sample123string42with777numbers'.scan(/[^0-9]+/)
=> ["Sample", "string", "with", "numbers"]

# deleting characters from start of string based on a delimiter
>> 'foo=42; baz=123'.sub(/\A[^=]+/, '')
=> "=42; baz=123"
# remove first two columns where : is delimiter
>> 'foo:123:bar:baz'.sub(/\A([^:]+:){2}/, '')
=> "bar:baz"

# deleting characters at end of string based on a delimiter
>> 'foo=42; baz=123'.sub(/=[^=]+\z/, '')
=> "foo=42; baz"
```

Sometimes, it is easier to use positive character class along with `grep_v` instead of using negated character class with `grep` method.

```ruby
>> words = %w[tryst fun glyph pity why]
=> ["tryst", "fun", "glyph", "pity", "why"]

>> words.grep(/\A[^aeiou]+\z/)
=> ["tryst", "glyph", "why"]

>> words.grep_v(/[aeiou]/)
=> ["tryst", "glyph", "why"]
```

Using `&&` between two sets of characters will result in matching only the intersection of those two sets. To aid in such definitions, you can use `[]` in nested fashion.

```ruby
# [^aeiou] will match any non-vowel character
# which means space is also a valid character to be matched
>> 'tryst glyph pity why'.scan(/\b[^aeiou]+\b/)
=> ["tryst glyph ", " why"]

# [a-z&&[^aeiou]] will be intersection of a-z and non-vowel characters
# this results in positive definition of characters to match
>> 'tryst glyph pity why'.scan(/\b[a-z&&[^aeiou]]+\b/)
=> ["tryst", "glyph", "why"]
```

Similar to other metacharacters, prefix `\` to character class metacharacters to match them literally. Some of them can be achieved by different placement as well.

```ruby
# - should be first or last character or escaped using \
>> 'ab-cd gh-c 12-423'.scan(/\b[a-z-]{2,}\b/)
=> ["ab-cd", "gh-c"]
>> 'ab-cd gh-c 12-423'.scan(/\b[a-z\-0-9]{2,}\b/)
=> ["ab-cd", "gh-c", "12-423"]

# ^ should be other than first character or escaped using \
>> 'f*(a^b) - 3*(a+b)'.scan(/a[+^]b/)
=> ["a^b", "a+b"]
>> 'f*(a^b) - 3*(a+b)'.scan(/a[\^+]b/)
=> ["a^b", "a+b"]

# [ ] and \ should be escaped using \
>> 'words[5] = tea'.match(/[a-z\[\]0-9]+/)
=> #<MatchData "words[5]">
>> puts '5ba\babc2'.match(/[a\\b]+/)
ba\bab
```

## Escape sequences and Named classes

Commonly used character sets have predefined escape sequences:

* `\w` is equivalent to `[A-Za-z0-9_]` for matching word characters (recall the definition for word boundaries)
* `\d` is equivalent to `[0-9]` for matching digit characters
* `\s` is equivalent to `[ \t\r\n\f\v]` for matching whitespace characters
* `\h` is equivalent to `[0-9a-fA-F]` for matching hexadecimal characters

These escape sequences can be used as standalone or inside a character class.

```ruby
>> '128A foo1 fe32 34 bar'.scan(/\b\h+\b/)
=> ["128A", "fe32", "34"]
>> '128A foo1 fe32 34 bar'.scan(/\b\h+\b/).map(&:hex)
=> [4746, 65074, 52]

>> 'Sample123string42with777numbers'.split(/\d+/)
=> ["Sample", "string", "with", "numbers"]
>> 'foo=5, bar=3; x=83, y=120'.scan(/\d+/).map(&:to_i)
=> [5, 3, 83, 120]

>> 'sea eat car rat eel tea'.scan(/\b\w/).join
=> "secret"
>> 'tea sea-pit sit-lean bean'.scan(/[\w\s]+/)
=> ["tea sea", "pit sit", "lean bean"]
```

And negative logic strikes again, use `\W`, `\D`, `\S` and `\H` respectively for their negated character class.

```ruby
>> 'Sample123string42with777numbers'.gsub(/\D+/, '-')
=> "-123-42-777-"

>> "   1..3  \v\f  foo_baz 42\tzzz   \r\n1-2-3  ".scan(/\S+/)
=> ["1..3", "foo_baz", "42", "zzz", "1-2-3"]
```

Ruby also provides named character sets, which are Unicode aware unlike the escape sequences which only work on ASCII characters. A named character set is defined by a name enclosed between `[:` and `:]` and has to be used within a character class `[]`, along with any other characters as needed. Using `[:^` instead of `[:` will negate the named character set.

All the four escape sequences presented above have named set equivalents. See [ruby-doc: Character Classes](https://ruby-doc.org/core-2.5.0/Regexp.html#class-Regexp-label-Character+Classes) for full list and details.

```ruby
# similar to: /\d+/ or /[0-9]+/
>> 'Sample123string42with777numbers'.split(/[[:digit:]]+/)
=> ["Sample", "string", "with", "numbers"]

# similar to: /\S+/
>> "   1..3  \v\f  foo_baz 42\tzzz   \r\n1-2-3  ".scan(/[[:^space:]]+/)
=> ["1..3", "foo_baz", "42", "zzz", "1-2-3"]

# similar to: /[\w\s]+/
>> 'tea sea-pit sit-lean bean'.scan(/[[:word:][:space:]]+/)
=> ["tea sea", "pit sit", "lean bean"]
```

Here's some named character sets which do not have escape sequence versions:

```ruby
# similar to: /[a-zA-Z]+/
>> 'Sample123string42with777numbers'.scan(/[[:alpha:]]+/)
=> ["Sample", "string", "with", "numbers"]

# remove all punctuation characters
>> 'hi there! how are you?? all fine here.'.gsub(/[[:punct:]]+/, '')
=> "hi there how are you all fine here"
# remove all punctuation characters except . and !
>> 'hi there! how are you?? all fine here.'.gsub(/[[^.!]&&[:punct:]]+/, '')
=> "hi there! how are you all fine here."
```

This chapter focussed on how to use and create custom placeholders for limited set of characters. Grouping and character classes can be considered as two levels of abstractions. On the one hand, you can have character sets inside `[]` and on the other, you can have multiple regexp alternations grouped inside `()` including character classes. As anchoring and quantifiers can be applied to both these abstractions, you can begin to see how regular expressions is considered a mini-programming language.  In coming chapters, you'll even see how to negate groupings similar to negated character class in certain scenarios.

<br>

For practice problems, visit [Exercises](https://github.com/learnbyexample/Ruby_Regexp/blob/master/exercises/Exercises.md) file from the repository.

