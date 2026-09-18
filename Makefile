all: build

build: apn.py

apn.py: apn.ksy
	kaitai-struct-compiler -t python -d . apn.ksy
