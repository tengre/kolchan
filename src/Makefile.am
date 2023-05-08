##
## $Git: Makefile.am 1.0-2-142 2023-05-07 16:43:09+00:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
PACKAGE        = kolchan
bin_SCRIPTS    = kolchan-automake kolchan-builddeb git-add-id kolchan-up2deb
datadir        = /usr/share/kolchan
data_DATA      = libsys.sh ../VERSION pre-commit
PACKAGEVERSION = $(shell test -f ../ChangeLog && sed -n "3p" ../ChangeLog | sed -e "s/.*Version.//")
DESTDIR        =
