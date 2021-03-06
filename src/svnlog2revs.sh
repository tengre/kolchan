#!/usr/bin/env bash
#
# $Id: svnlog2revs.sh 57 2019-05-08 10:54:57+04:00 yds $
#
_bashlyk=devtools . bashlyk
#
#
#
svnlog2revs::main() {

  throw on CommandNotFound rm sed touch
  throw on MissingArgument $1
  throw on NoSuchFile $1

  eval set -- "$(_ sArg)"

  local s fn fnRev tsRev

  fn=$1

  sed -i -r -e "s/\t/%SVNLOG2REVSTABULA%/g" -e "s/^(\s+)/%SVNLOG2REVSIDENT%\1/" $fn

  while read s; do

    [[ "$s" =~ ^------------------------------------------------------------------------$ ]] && continue
    if [[ "$s" =~ ^(r[0-9]+)[[:space:]]\|[[:space:]][[:graph:]]+[[:space:]]\|[[:space:]](.*)[[:space:]]\(.*\).*[0-9]+.line(s)?$ ]]; then

      if [[ $fnRev && -f $fnRev && $tsRev ]]; then

        [[ "$2" == "add-svn-rev" ]] && printf -- "--\n--\t(svn rev %s)\n" "$fnRev" >> $fnRev
        sed -i -r -e "s/%SVNLOG2REVSTABULA%/\t/g" -e "s/%SVNLOG2REVSIDENT%//" $fnRev
        touch --date="$tsRev" $fnRev

      fi

      if [[ ${BASH_REMATCH[1]} ]]; then

        fnRev="${BASH_REMATCH[1]}"
        tsRev="${BASH_REMATCH[2]}"
        rm -f $fnRev
        echo "$fnRev $tsRev"

      else

        error Unexpected throw "$s"

      fi

      read s
      continue

    fi

    [[ $fnRev =~ ^r[0-9]+$ ]] || continue
    echo "$s" >> $fnRev

  done < $fn

  if [[ $fnRev && -f "$fnRev" && $tsRev ]]; then

    [[ $2 == add-svn-rev ]] && printf -- "--\n--\t(svn rev %s)\n" "$fnRev" >> $fnRev
    sed -i -r -e "s/%SVNLOG2REVSTABULA%/\t/g" -e "s/%SVNLOG2REVSIDENT%//" $fnRev
    touch --date="$tsRev" $fnRev

  fi

  sed -i -r -e "s/%SVNLOG2REVSTABULA%/\t/g" -e "s/%SVNLOG2REVSIDENT%//" $fn

}
#
#
#
svnlog2revs::main
#
