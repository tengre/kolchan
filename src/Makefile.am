##
## $Id: Makefile.am 52 2019-04-01 23:07:05+04:00 yds $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
PACKAGE			= kolchan
bin_SCRIPTS		= automake.sh build-deb.sh git-add-id subgit.sh svnlog2revs.sh svnsetlog.sh uupdeb
PACKAGEVERSION		= $(shell test -f ../ChangeLog && sed -n "3p" ../ChangeLog | sed -e "s/.*Version.//")
DESTDIR			=
