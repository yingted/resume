#!/usr/bin/env python
import os, sys, re, subprocess
font = 'CMU Serif'
args = sys.argv[1:]
if len(args) != 2:
    print('Usage: %s <basename> <prefix>')
    sys.exit(1)
base, prefix = args
pat = re.compile(r'([^/]*)\.(?:[a-z]*): :style=([a-zA-Z]*)$', re.M)
for name, style in pat.findall(subprocess.check_output(('fc-list', font, 'file', 'style'))):
    rules = []
    if 'Bold' in style:
        rules += ['font-weight: bold;']
    if 'Italic' in style:
        rules += ['font-style: italic;']
    else:
        rules += ['font-style: normal;']
    print '''\
@font-face{
    font-family: "%(font)s";
    src: url("%(path)s.eot");
    %(rules)s
}
@font-face{
    font-family: "%(font)s";
    src: local("%(font)s"),
        url("%(path)s.eot") format('eot'),
        url("%(path)s.woff") format('woff'),
        url("%(path)s.otf") format('otf'),
        url("%(path)s.ttf") format('truetype'),
        url("%(path)s.svg") format('svg');
    %(rules)s
}''' % {
        'path': (prefix + name).encode('string_escape'),
        'font': font.encode('string_escape'),
        'rules': ''.join(rules),
    }
