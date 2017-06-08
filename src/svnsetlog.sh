#!/bin/bash
#
# $Id: svnsetlog.sh 28 2017-06-08 15:19:59+04:00 toor $
#
_bashlyk=developing . bashlyk
#
#
#

: ${pathSVN:=/opt/dat/svn}

svnsetlog::main() {

  throw on CommandNotFound ls svnadmin

  eval set -- "$(_ sArg)"

  local r

  throw on MissingArgument $1
  throw on NoSuchFileOrDir "${pathSVN}/$1"

  while read r; do

    echo "$1 - setlog $r"
    svnadmin setlog ${pathSVN}/$1 -r ${r/r/} --bypass-hooks $r

  done< <( ls -rt r* )

}
#
#
#
svnsetlog::main
#
