##
## $Id: Makefile.am 71 2019-05-25 10:39:32+04:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
PACKAGE			= kolchan
bin_SCRIPTS		= kolchan-automake kolchan-builddeb git-add-id kolchan-up2deb
datadir			= /usr/share/kolchan
data_DATA		= libsys.sh ../VERSION
PACKAGEVERSION		= $(shell test -f ../ChangeLog && sed -n "3p" ../ChangeLog | sed -e "s/.*Version.//")
DESTDIR			=
