import re
from sys import stdin
content = stdin.read().rstrip()
# Admonition headers
content = re.sub(re.compile(r"!!! (\w+) ([^\n]+?) \(spoiler\)$(?=\n {4})", flags=re.M), r"[[\1-spoiler | \2]]", content)
content = re.sub(re.compile(r"!!! (\w+) ([^\n]+)(?=\n {4})"), r"[[\1 | \2]]", content)
content = re.sub(re.compile(r'!!! (\w+) ""(?=\n {4})'), r"[[\1 | ]]", content)
# Admonition content
## First line
content = re.sub(re.compile(r"(?<=\]\]\n)^ {4}([^\n]*)", flags=re.M), r"| \1¶¶¶", content)
## All subsequent lines except last
pattern = re.compile(r"(?<=¶¶¶\n)^ {4}([^\n]*)(?=\n {4})", flags=re.M)
newcontent = re.sub(pattern, r"| \1¶¶¶", content)
while content != newcontent:
    content = newcontent
    newcontent = re.sub(pattern, r"| \1¶¶¶", content)
## Last line
content = re.sub(re.compile(r"(?<=¶¶¶\n)^ {4}([^\n]*)", flags=re.M), r"| \1", content)
## Remove temp
content = re.sub(re.compile(r"¶¶¶"), "", content)
print(content)
