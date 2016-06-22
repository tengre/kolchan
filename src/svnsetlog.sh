#!/bin/bash
#
# $Id: svnsetlog.sh 3 2016-06-22 13:49:50+04:00 toor $
#
. bashlyk
#
#
#

: ${pathSVN:=/opt/dat/svn}

udfMain() {
	local r
#
	[[ -n "$1"          ]] || eval $(udfOnError throw iErrorEmptyOrMissingArgument)
	[[ -d ${pathSVN}/$1 ]] || eval $(udfOnError throw iErrorNoSuchFileOrDir "${pathSVN}/$1")
#
	for r in $(ls -rt r*); do

		echo "$1 - setlog $r"
		svnadmin setlog ${pathSVN}/$1 -r ${r/r/} --bypass-hooks $r

	done

}
#
#
#
udfMain "$@"
#
