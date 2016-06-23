#!/bin/bash
#
# $Id: svnsetlog.sh 13 2016-06-23 15:34:08+04:00 toor $
#
. bashlyk
#
#
#

: ${pathSVN:=/opt/dat/svn}

udfMain() {

	udfThrowOnCommandNotFound svnadmin

	eval set -- "$(_ sArg)"

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
udfMain
#
