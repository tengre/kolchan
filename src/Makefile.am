##
## $Id: Makefile.am 24 2017-02-17 15:34:47+04:00 toor $
##
#
AUTOMAKE_OPTIONS	= -Wno-portability
#
PACKAGE			= svn2git
bin_SCRIPTS		= git-add-id subgit.sh svnlog2revs.sh svnsetlog.sh
PACKAGEVERSION		= $(shell test -f ../ChangeLog && sed -n "3p" ../ChangeLog | sed -e "s/.*Version.//")
DESTDIR			=
