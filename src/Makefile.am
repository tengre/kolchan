##
## $Id: Makefile.am 64 2019-05-21 01:00:05+04:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
PACKAGE			= kolchan
bin_SCRIPTS		= automake.sh build-deb.sh git-add-id uupdeb
datadir			= /usr/share/kolchan
data_DATA		= libsys.sh ../VERSION
PACKAGEVERSION		= $(shell test -f ../ChangeLog && sed -n "3p" ../ChangeLog | sed -e "s/.*Version.//")
DESTDIR			=
