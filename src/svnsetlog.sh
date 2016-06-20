#!/bin/bash
#
#
#
. bashlyk
#
#
#

: ${pathSVN:=/opt/dat/svn}

udfMain() {
 local r
 #
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
