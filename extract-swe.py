import sys
import xml.etree.ElementTree as ET

if len(sys.argv) < 3:
  print(f'Usage: {sys.argv[0]} XML BIN')
  sys.exit(1)

xmlfile = sys.argv[1]
binfile = sys.argv[2]

desc = ET.parse(xmlfile)
with open(binfile, 'rb') as fp:
    blob = fp.read()

for seg in desc.findall('.//{binary-header.xsd}FLASH-SEGMENT'):
    name = seg.find('.//{binary-header.xsd}SHORT-NAME').text
    start = seg.find('.//{binary-header.xsd}SOURCE-START-ADDRESS').text
    end = seg.find('.//{binary-header.xsd}SOURCE-END-ADDRESS').text
    print(f'{name}:{start}:{end}')
    off = int(f'0x{start}', base=0)
    len = int(f'0x{end}', base=0) - off
    with open(name, 'wb') as fp:
        fp.write(blob[off:off+len+1])
