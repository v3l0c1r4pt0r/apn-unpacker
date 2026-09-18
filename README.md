# apn-unpacker

Unpacker for Alps EntryNav2 head-unit root filesystems.

## Prerequisites

The extraction workflow requires:

- Python 3
- A POSIX shell (`sh`)
- `hexdump` (from the util-linux or BSD command-line tools)
- The tools and libraries required by the repository's Python/Kaitai Struct parsers
- Sufficient disk space for the extracted firmware segments and root filesystem

On a Debian/Ubuntu system, the commonly required command-line tools can be installed with:

```sh
sudo apt install python3 util-linux
```

If the scripts require additional Python packages in your checkout, install them according to the project's build files or generated Kaitai Struct code.

## Basic workflow

The firmware is handled in two stages:

1. Extract the addressable sections from the XML description and its corresponding binary data.
2. Pass the section containing the root filesystem to the rootfs extraction script.

Run the section extractor with the XML metadata file followed by the matching binary file:

```sh
python3 extract-swe.py <metadata.xml> <firmware.bin>
```

This writes files named after the firmware image and their offsets. The command prints the ranges that were extracted, for example:

```text
<image>_<offset>:<start>:<end>
```

Inspect the generated files to identify the root filesystem image. `hexdump` is useful for checking their headers:

```sh
for f in <image>_*; do
    echo "$f:"
    hexdump -C "$f" | head -1
done
```

Finally, unpack the root filesystem image into an output directory:

```sh
sh extract.rootfs.sh <rootfs-image> out
```

The resulting filesystem is placed below the output directory, typically at:

```text
out/tmp/rootfs/
```

For example, a successful extraction contains a standard root filesystem layout such as `bin/`, along with the other directories and files supplied by the image.

## Notes

- Keep the XML metadata and binary input from the same firmware image; the offsets in the metadata must match the binary data.
- Use a fresh output directory for each extraction to avoid mixing files from different images.
- The firmware may contain proprietary or device-specific data. Only unpack and use images that you are authorized to handle.
