##
## $Id: Makefile.am 145 2023-05-09 13:03:11+00:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
DOC         = /usr/share/doc
docdir      = ${DOC}/${PACKAGE}
doc_DATA    = ../changelog ../README.md
htmldir     = ${DOC}/${PACKAGE}/html
html_DATA   = $(wildcard *.html) $(wildcard *.css)
BUILD_DATE  = $(shell test -f ../VERSION && cut -f 3 -d' ' ../VERSION || date '+%Y-%m-%d')
DESTDIR     =

## robodoc may not be installed, documentation generation has been moved to the kolchan-robodoc tool
#all:
#	$(shell) cd .. && robodoc && cd ./doc && patch < ${PACKAGE}.html.patch && sed -i -re "s/^(<p>Generated.from.*V.*on).*/\1 ${BUILD_DATE}/ig" kolchan.html
##

../changelog: ../ChangeLog
	$(shell) cp ../ChangeLog ../changelog

clean-local:
	-rm -rf ../changelog
