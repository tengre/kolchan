#!/bin/bash
#
# $Id: svnsetlog.sh 44 2019-03-25 22:56:00+04:00 yds $
#
_bashlyk=devtools . bashlyk
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
