#!/bin/bash
#
# $Id: svnlog2revs.sh 29 2018-06-18 15:31:00+04:00 toor $
#
_bashlyk=developing . bashlyk
#
#
#
svnlog2revs::main() {

  throw on CommandNotFound rm sed touch
  throw on MissingArgument $1
  throw on NoSuchFileOrDir $1

  eval set -- "$(_ sArg)"

  local s fn fnRev tsRev

  fn=$1

  sed -i -r -e "s/\t/%SVNLOG2REVSTABULA%/g" -e "s/^(\s+)/%SVNLOG2REVSIDENT%\1/" $fn

  while read s; do

    [[ "$s" =~ ^------------------------------------------------------------------------$ ]] && continue
    if [[ "$s" =~ ^(r[0-9]+)[[:space:]]\|[[:space:]][[:graph:]]+[[:space:]]\|[[:space:]](.*)[[:space:]]\(.*\).*[0-9]+.line(s)?$ ]]; then

      if [[ -n "$fnRev" && -f "$fnRev" && -n "$tsRev" ]]; then

        [[ "$2" == "add-svn-rev" ]] && printf -- "--\n--\t(svn rev %s)\n" "$fnRev" >> $fnRev
        sed -i -r -e "s/%SVNLOG2REVSTABULA%/\t/g" -e "s/%SVNLOG2REVSIDENT%//" $fnRev
        touch --date="$tsRev" $fnRev

      fi

      if [[ -n "${BASH_REMATCH[1]}" ]]; then

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

  if [[ $fnRev && -f "$fnRev" && -n "$tsRev" ]]; then

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
