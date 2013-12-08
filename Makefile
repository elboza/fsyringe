VERSION=`cat fsyringe.pl|grep VERSION=\"|cut -d '"' -f2`
BINDIR=/usr/local/bin
SRC=fsyringe.pl
TARGET=fsyringe
DIST_DIR=fsyringe
SHELL=/bin/bash

all: help
	
.PHONY: clean install uninstall dist help

install:
	cp ${SRC} ${DESTDIR}${BINDIR}/${TARGET}
	chmod 555 ${DESTDIR}${BINDIR}/${TARGET}

uninstall:
	rm -f ${BINDIR}/${TARGET}

dist:
	mkdir ${DIST_DIR}
	cp ${SRC} ${DIST_DIR}/
	cp Makefile ${DIST_DIR}/
	cp README.md ${DIST_DIR}/
	COPYFILE_DISABLE=1 tar -cvzf ${TARGET}-${VERSION}.tar.gz ${DIST_DIR}/
	rm -f ./${DIST_DIR}/*
	rmdir ${DIST_DIR}

clean:
	rm -f ./${DIST_DIR}/*
	rmdir ${DIST_DIR}

help:
	@ echo "The following targets are available"
	@ echo "help      - print this message"
	@ echo "install   - install everything"
	@ echo "uninstall - uninstall everything"
	@ echo "clean     - remove any temporary files"
	@ echo "dist      - make a dist .tar.gz tarball package"

