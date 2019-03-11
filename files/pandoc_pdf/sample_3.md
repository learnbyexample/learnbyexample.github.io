* Using `python` syntax highlighting

```python
# remove first two columns where : is delimiter
>>> re.sub(r'\A([^:]+:){2}', r'', 'foo:123:bar:baz', count=1)
'bar:baz'
>>> ''.join(re.findall(r'\b\w', 'sea eat car rat eel tea'))
'secret'
# match 'dog' only if it is not preceded by 'parrot'
>>> bool(regex.search(r'(?<!parrot.*)dog', 'fox,cat,dog,parrot'))
True
```

* Using `ruby` syntax highlighting

```ruby
# remove first two columns where : is delimiter
>>> re.sub(r'\A([^:]+:){2}', r'', 'foo:123:bar:baz', count=1)
'bar:baz'
>>> ''.join(re.findall(r'\b\w', 'sea eat car rat eel tea'))
'secret'
# match 'dog' only if it is not preceded by 'parrot'
>>> bool(regex.search(r'(?<!parrot.*)dog', 'fox,cat,dog,parrot'))
True
```

