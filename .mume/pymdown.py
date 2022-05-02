import markdown
from sys import stdin, stdout
import pymdownx.arithmatex as arithmatex
import pymdownx.superfences as superfences
import regex as re
from os import getenv
from platform import system


def preformat(text):
    del_comments = re.compile(r"<!---->")
    # quotate_admon_titles = re.compile(
    #     r'((?:\?{3}|!{3})\+? \b\w+\b )"?((?:(?<!").(?!"))*)"?'
    # )
    del_header = re.compile(r"^---.+?---\n", flags=re.S)
    # fix_paths = re.compile(r'(src=")(assets/[\w\-_]+.\w+)')
    # corr_path = dir[dir.rfind("docs") + 5 : dir.rfind("/") + 1]
    text = re.sub(del_comments, "", text)
    # text = re.sub(quotate_admon_titles, r'\1"\2"', text)
    text = re.sub(del_header, "", text)
    # text = re.sub(fix_paths, r"\1../\2", text)
    return text


extensions = [
    "markdown.extensions.tables",
    "markdown.extensions.admonition",
    "markdown.extensions.footnotes",
    "markdown.extensions.abbr",
    "markdown.extensions.meta",
    "markdown.extensions.attr_list",
    "markdown.extensions.def_list",
    "markdown.extensions.md_in_html",
    "markdown.extensions.wikilinks",
    "pymdownx.arithmatex",
    "pymdownx.caret",
    "pymdownx.mark",
    "pymdownx.tilde",
    "pymdownx.tasklist",
    "pymdownx.tabbed",
    "pymdownx.details",
    "pymdownx.superfences",
    "pymdownx.highlight",
    "pymdownx.inlinehilite",
    "pymdownx.betterem",
    "pymdownx.snippets",
    "pymdownx.keys",
]

extension_configs = {
    "pymdownx.arithmatex": {"generic": True},
    "pymdownx.highlight": {"use_pygments": True, "linenums": True},
    "pymdownx.superfences": {
        "custom_fences": [
            {
                "name": "mermaid",
                "class": "mermaid",
                "format": superfences.fence_div_format,
            },
            {
                "name": "math",
                "class": "arithmatex",
                "format": arithmatex.arithmatex_fenced_format(which="generic"),
            },
        ]
    },
    "pymdownx.tasklist": {"custom_checkbox": True},
    "pymdownx.tabbed": {"alternate_style": False},
}

extra_stylesheets = [
    "https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/katex.min.css",
    "https://cdn.jsdelivr.net/gh/gustavkrist/notesdocs@master/docs/stylesheets/katex.css",
]

extra_javascripts = [
    "https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/katex.min.js",
    "https://cdn.jsdelivr.net/gh/gustavkrist/dotfiles@aa97d644bd1c755e727fedafaf0cf926f23ebc07/md-preview/katex.js",
    "https://unpkg.com/mermaid@8.6.4/dist/mermaid.min.js",
]

extra_stylesheets = [f"<link rel=stylesheet href={s}>" for s in extra_stylesheets]
extra_javascripts = [f'<script src="{s}"></script>' for s in extra_javascripts]

md = markdown.Markdown(extensions=extensions, extension_configs=extension_configs)
html = md.convert(preformat(stdin.read()))

# html = header + " ".join(extra_stylesheets) + "</head>" + html + "<body>"
# doc = html + " ".join(extra_javascripts) + "</body></html>"
doc = " ".join(extra_stylesheets) + html + " ".join(extra_javascripts)
# doc = '@import "https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/katex.min.css"\n' + doc
# doc += '\n@import "https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/katex.min.js"'
# doc += '\n@import "https://cdn.jsdelivr.net/gh/gustavkrist/notes@1eeb0a5e5dcc22d801a602652c25684a6cbf8743/katex.js"'
# doc = "<!doctype html>" + doc
if system() == "Darwin":
    path = f"{getenv('HOME')}/.mume/output.html"
elif system() == "Windows":
    path = getenv("userprofile") + r"\.mume\output.html"

with open(path, "w") as f:
    f.write(doc)
stdout.write(doc)
