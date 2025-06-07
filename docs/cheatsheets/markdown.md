# Markdown

A combo Markdown cheatsheet and personal style guide focused on Github Flavored Markdown and mkdocs support.

You can generally get by in Markdown knowing headers and *italics*, then reference this or [other cheatsheets](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) for whatever else you need.

## Headers

```markdown
# Header / Title
## Sub-Header 1
### Sub-Header 2
```

## Horizontal Line
```markdown
---
```

## Emphasis
Use only italics; never bold or underlining.
```markdown
I can't *believe* it.
```

## Numbered Lists
```markdown
1. item one
2. item two
3. item three
```

## Bulleted / Unordered List
```markdown
- bacon
- eggs
- five
```

## External Links
```markdown
here's a [blatant rickroll](https://youtube.com/watch?v=dQw4w9WgXcQ) without any pretense
```

## Internal Links
```markdown
here's a link to [another page in the same project](/docs/index.md)
```

## Embedded Images
```markdown
![alt text][https://example.com/path.jpg]
```

## Transcription Images
When doing transcription, use photos of the source material for emphasis, named after the doc and paragraph number and/or other descriptor.

```markdown
![paragraph 1](../images/2005-10-04-p1.jpg)

![illustration](../images/2005-10-15-illustration.jpg)
```

## Line Break
Markdown defaults to ignoring single line breaks. When one is needed, use an HTML line break at the end of a line.
```markdown
line1<br>
line2
```

## Block quotes
used for excerpts
```markdown
The classic novel *Pride and Prejudice* begins with this deliberately ridiculous statement:

> It is a truth universally acknowledged, that a single man in possession of a good fortune must be in want of a wife.
>
> However little known the feelings or views of such a man may be on his first entering a neighbourhood, this truth is so well fixed in the minds of the surrounding families, that he is considered as the rightful property of some one or other of their daughters.
```

## Cited Quotes
```markdown
> Ring ring ring ring ring ring ring
> Banana phone

-- Raffi
```

## Poetry and Lyrics Format
```markdown
There was a young lady named Bright<br>
Whose speed was far faster than light;<br>
She set out one day<br>
In a relative way<br>
And returned on the previous night.
```

## Tables
Should be rarely needed but *extremely handy* when appropro. Prefer concise format over pretty text format.
```markdown
Header1|Header2|Header3
---|---|---
value1|value2|value3
```

