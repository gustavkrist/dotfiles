import regex as re
from sys import stdin, stdout
from os import getenv
from platform import system


on_did_parse = stdin.read()
if system() == "Darwin":
    path = getenv("HOME") + "/.mume/output.html"
elif system() == "Windows":
    path = getenv("userprofile") + r'\.mume\output.html'

with open(path) as f:
    pymdown = f.read()
codeblocks = re.compile(r'<table class="highlighttable">.+?</table>', flags=re.DOTALL)
did_parse_code = re.findall(codeblocks, on_did_parse)
pymdown_code = re.findall(codeblocks, pymdown)
for code in zip(did_parse_code, pymdown_code):
    on_did_parse = on_did_parse.replace(*code)

fix_details = re.compile(r'(<details class=")(\w+)("(?: open="open")?>)(\s+?<summary)')
on_did_parse = re.sub(
    fix_details, r'\1admonition \2\3\4 class="admonition-title"', on_did_parse
)

stdout.write(on_did_parse)
