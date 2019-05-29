##
## $Id: Makefile.am 93 2019-05-29 22:32:30+04:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
DOC			= /usr/share/doc
docdir			= ${DOC}/${PACKAGE}
doc_DATA		= ../changelog ../README.md
htmldir			= ${DOC}/${PACKAGE}/html
html_DATA		= $(wildcard *.html) $(wildcard *.css)
BUILD_DATE		= $(shell test -f ../VERSION && cut -f 3 -d' ' ../VERSION || date '+%Y-%m-%d')
DESTDIR			=


all:
	$(shell) cd .. && robodoc && cd ./doc && patch < ${PACKAGE}.html.patch && sed -i -re "s/^(<p>Generated.from.*V.*on).*/\1 ${BUILD_DATE}/ig" kolchan.html

../changelog: ../ChangeLog
	$(shell) cp ../ChangeLog ../changelog

clean-local:
	-rm -rf ../changelog


