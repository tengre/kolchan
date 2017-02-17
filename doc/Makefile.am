##
## $Id: Makefile.am 24 2017-02-17 15:34:48+04:00 toor $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
DOC			= /usr/share/doc
docdir			= ${DOC}/${PACKAGE}/html
doc_DATA		= $(wildcard *.html) $(wildcard *.css)
DESTDIR			=

all:
	$(shell) cd .. && robodoc && cd ./doc && patch < ${PACKAGE}.html.patch
