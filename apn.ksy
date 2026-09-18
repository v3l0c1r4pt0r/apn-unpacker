meta:
  id: apn
  title: Alps Alpine filesystem
  tags:
    - automotive
  ks-version: 0.10
doc: |
  Filesystem format used on Alps Alpine headunits
seq:
  - id: header
    type: header
  - id: contents
    type: node
    repeat: eos
types:
  header:
    seq:
      - id: magic
        contents: ["APN#$%&@@", 0, 0, 0]
      - id: padding
        size: 0x40 - 0xc
  node:
    seq:
      - id: attrs
        type: attr
        size: 0x60
      - id: filename
        type: strz
        size: attrs.filename_size
        encoding: ASCII
      - id: mountname
        type: strz
        size: attrs.mountname_size
        encoding: ASCII
      - id: linkname
        type: strz
        size: attrs.linkname_size
        encoding: ASCII
      - id: contents
        size: attrs.filesize
  attr:
    seq:
      - id: entry_num
        type: u2le
      - id: arg1
        type: u1
      - id: arg2
        type: u1
      - id: filename_size
        type: u2le
      - id: linkname_size
        type: u2le
      - id: mountname_size
        type: u2le
      - id: arg3
        type: u1
      - id: arg4
        type: u1
      - id: filesize
        type: u4le
      - id: arg5
        type: u8le
      - id: arg1fc
        type: u8le
      - id: arg6
        type: u8le
      - id: timestamp1
        type: u8le
      - id: timestamp2
        type: u8le
      - id: timestamp3
        type: u8le
      - id: padding
        size: (-_io.pos) % 0x60
