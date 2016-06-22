#!/bin/bash
#
# $Id: svnlog2revs.sh 5 2016-06-22 15:10:51+04:00 toor $
#
. bashlyk
#
#
#
udfMain() {

	eval set -- "$(_ sArg)"

	[[ -n "$1" && -s "$1" ]] || eval $(udfOnError throw iErrorEmptyOrMissingArgument '$1')

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

				eval $(udfOnError throw iErrorUnexpected '$s')

			fi

			read s
			continue

		fi

		[[ "$fnRev" =~ ^r[0-9]+$ ]] || continue
		echo "$s" >> $fnRev

	done < $fn

	if [[ -n "$fnRev" && -f "$fnRev" && -n "$tsRev" ]]; then

		[[ "$2" == "add-svn-rev" ]] && printf -- "--\n--\t(svn rev %s)\n" "$fnRev" >> $fnRev
		sed -i -r -e "s/%SVNLOG2REVSTABULA%/\t/g" -e "s/%SVNLOG2REVSIDENT%//" $fnRev
		touch --date="$tsRev" $fnRev

	fi

	sed -i -r -e "s/%SVNLOG2REVSTABULA%/\t/g" -e "s/%SVNLOG2REVSIDENT%//" $fn

}
#
#
#
udfMain
#
