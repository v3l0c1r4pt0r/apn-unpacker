#!/bin/sh
if [ $# -lt 2 ]; then
  echo "Usage: $0 APN-file output-directory"
  exit 1
fi

apn_file=$1
output_directory=$2

python unpack_apn.py ${apn_file} ${output_directory}
echo "Decompressing files identified as zlib, wait a little longer..."
find ${output_directory} -type f -exec file {} \; | grep ': zlib compressed data$' | cut -d: -f1 | while read f; do openssl zlib -d -in $f -out $f.nozlib; mv $f.nozlib $f;  done
echo "Done"
