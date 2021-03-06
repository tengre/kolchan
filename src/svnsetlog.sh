#!/usr/bin/env bash
#
# $Id: svnsetlog.sh 57 2019-05-08 10:54:57+04:00 yds $
#
_bashlyk=devtools . bashlyk
#
#
#

: ${pathSVN:=/opt/dat/svn}

svnsetlog::main() {

  throw on CommandNotFound ls svnadmin

  eval set -- "$(_ sArg)"

  throw on MissingArgument $1
  throw on NoSuchDir "${pathSVN}/$1"

  while read; do

    echo "$1 - setlog $REPLY"
    svnadmin setlog ${pathSVN}/$1 -r ${REPLY/r/} --bypass-hooks $REPLY

  done< <( ls -rt r* )

}
#
#
#
svnsetlog::main
#
