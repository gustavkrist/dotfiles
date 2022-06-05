import json
from itertools import zip_longest
from sys import argv

COLUMN_HEIGHT = 4

def parse(value):
    if value[0] == '+':
        return f'<span foreground="lightblue"><i>{value}</i></span>'
    else:
        return f'<i>{value}</i>'

with open(argv[1], 'r') as f:
    help = json.load(f)
output = '<span size="large" font_family="monospace">'
menus = []
actions = []
for key in help:
    if help[key][0] == '+':
        menus.append(key)
    else:
        actions.append(key)
columns = [[]]
col = 0
for key in sorted(actions) + sorted(menus):
    if len(columns[col]) >= COLUMN_HEIGHT:
        columns.append([])
        col += 1
    columns[col].append(f'<b>{key}</b> ➜ {parse(help[key]): <30}')

menu = list(map(lambda x: list(filter(lambda y: y, x)), zip_longest(*columns)))
rows = []
for row in menu:
    rows.append('\t'.join(row))
output += '\n'.join(rows)
output = output.rstrip() + '</span>'
print(output)
