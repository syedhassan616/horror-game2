#!/usr/bin/env python3
"""Inline the stylesheet and every script into one self-contained page.

The multi-file version under js/ is the source of truth; this only bundles it.
Run after any edit:  python3 build-single-file.py
"""
import os, re

HERE = os.path.dirname(os.path.abspath(__file__))
# Load order matters — the modules assume their dependencies are already global.
SCRIPTS = ['js/audio.js', 'js/lighting.js', 'js/story.js', 'js/world.js',
           'js/entities.js', 'js/puzzles.js', 'js/game.js']


def read(rel):
    with open(os.path.join(HERE, rel), encoding='utf-8') as fh:
        return fh.read()


def main():
    html = read('index.html')
    html = html.replace('<link rel="stylesheet" href="css/game.css">',
                        '<style>\n%s\n</style>' % read('css/game.css'))
    html = re.sub(r'<script src="js/[^"]+"></script>\s*', '', html)
    bundle = '\n\n'.join('/* ===== %s ===== */\n%s' % (f, read(f)) for f in SCRIPTS)
    html = html.replace('</body>', '<script>\n%s\n</script>\n</body>' % bundle)

    out = os.path.join(HERE, 'hollowlight-single-file.html')
    with open(out, 'w', encoding='utf-8') as fh:
        fh.write(html)
    print('wrote %s (%d bytes)' % (os.path.basename(out), len(html)))


if __name__ == '__main__':
    main()
