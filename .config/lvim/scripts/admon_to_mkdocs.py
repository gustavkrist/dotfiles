import re
from sys import stdin
content = stdin.read().rstrip()
# Admonition content
## First line after [[]]
content = re.sub(re.compile(r"(?<=\]\]\n)^\| ?([^\n]*)", flags=re.M), r"¶¶¶    \1¶¶¶", content)
## All subsequent lines except last
pattern = re.compile(r"(?<=¶¶¶\n)^\| ?([^\n]*)(?=\n\|)", flags=re.M)
newcontent = re.sub(pattern, r"    \1¶¶¶", content)
while content != newcontent:
    content = newcontent
    newcontent = re.sub(pattern, r"    \1¶¶¶", content)
## Last line
content = re.sub(re.compile(r"(?<=¶¶¶\n)^\| ?([^\n]*)", flags=re.M), r"    \1¶¶¶", content)
## Remove temp
# Admonition headers
content = re.sub(re.compile(r"^\[\[(\w+)\-spoiler \| ([^\n]+)\]\](?=\n¶¶¶)", flags=re.M), r"!!! \1 \2 (spoiler)", content)
content = re.sub(re.compile(r"^\[\[(\w+) \| ([^\n]+)\]\](?=\n¶¶¶)", flags=re.M), r"!!! \1 \2", content)
content = re.sub(re.compile(r"^\[\[(\w+) \| \]\](?=\n¶¶¶)", flags=re.M), r'!!! \1 ""', content)
content = re.sub(re.compile(r"^\[\[(\w+)\]\](?=\n¶¶¶)", flags=re.M), r'!!! \1 ""', content)
content = re.sub(re.compile(r"¶¶¶"), "", content)
print(content)
