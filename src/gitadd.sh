#!/bin/bash
#
# $Id: gitadd.sh 7 2016-06-22 15:57:47+04:00 toor $
#
. bashlyk
#
#
#
udfMain() {

	udfThrowOnCommandNotFound date git grep sed

	local a=( $( git shortlog -s ) ) fn ic ts ui
	fmt='sed -i -r -e "s/%sId(.*)?%s/%s/" %s'

	eval set -- "$(_ sArg)"

	if [[ -f "$1" && -n "$( git status -s "$1" | grep -P "^[ AM?][M?]\s$1" )" ]]; then

		ts="$( date --rfc-3339=s )"
		ic="${a[0]}"
		fn="${1##*/}"
		ui="$USER"

		if udfWarnOnEmptyVariable fn ic ts ui; then

			s="$( printf '\044Id: %s %d %s %s \044\n' "$fn" "$ic" "$ts" "$ui" )"
			eval "$( printf "$fmt" '\\\$' '\\\$' '$s' '$fn')"

		fi

		git add "$1"

	else

		echo "$1 not modified, but may be indexed..."

	fi

}
#
#
#
udfMain
#
