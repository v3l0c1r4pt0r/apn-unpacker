from apn import Apn
import sys
from pathlib import Path

if len(sys.argv) < 2:
  print(f'Usage: {sys.argv[0]} APN-file output-directory', file=sys.stderr)
  sys.exit(1)

filename = sys.argv[1]
dirname = Path(sys.argv[2])

if not dirname.exists():
  dirname.mkdir(parents=True)

archive = Apn.from_file(filename)
for entry in archive.contents:
  if entry.attrs.filesize == 0:
    print(f'Skipping {entry.filename} having no size, sorry')
    continue
  if entry.filename.startswith('/'):
    fullpath = dirname / entry.filename[1:]
  else:
    fullpath = dirname / entry.filename
  parentdir = fullpath.parent
  if not parentdir.exists():
    parentdir.mkdir(parents=True)
  with open(fullpath, 'wb') as fp:
    fp.write(entry.contents)
