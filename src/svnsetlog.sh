#!/bin/bash
#
# $Id: svnsetlog.sh 19 2017-02-08 17:22:57+04:00 toor $
#
. bashlyk
#
#
#

: ${pathSVN:=/opt/dat/svn}

udfMain() {

  udfThrowOnCommandNotFound ls svnadmin

  eval set -- "$(_ sArg)"

  local r

  udfOn MissingArgument throw $1
  udfOn NoSuchFileOrDir throw "${pathSVN}/$1"

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
