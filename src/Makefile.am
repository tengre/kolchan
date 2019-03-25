##
## $Id: Makefile.am 47 2019-03-25 23:49:41+04:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
PACKAGE			= kolchan
bin_SCRIPTS		= build-deb.sh git-add-id subgit.sh svnlog2revs.sh svnsetlog.sh uupdeb
PACKAGEVERSION		= $(shell test -f ../ChangeLog && sed -n "3p" ../ChangeLog | sed -e "s/.*Version.//")
DESTDIR			=
