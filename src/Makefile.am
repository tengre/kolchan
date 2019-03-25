##
## $Id: Makefile.am 46 2019-03-25 23:21:33+04:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
PACKAGE			= kolchan
bin_SCRIPTS		= build-deb.sh git-add-id subgit.sh svnlog2revs.sh svnsetlog.sh
PACKAGEVERSION		= $(shell test -f ../ChangeLog && sed -n "3p" ../ChangeLog | sed -e "s/.*Version.//")
DESTDIR			=
