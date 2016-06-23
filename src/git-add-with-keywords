#!/bin/bash
#
# $Id: gitadd.sh 10 2016-06-23 12:41:05+04:00 toor $
#
. bashlyk
#
#
#
udfMain() {

	udfThrowOnCommandNotFound bc date git grep sed xargs

	local fmt fn ic ts ui

	fmt='sed -i -r -e "s/%sId(.*)?%s/%s/" %s'
	ic=$( git shortlog -s | grep -oP '^\s+\d+\s+' | xargs | tr ' ' '+' | bc )

	eval set -- "$(_ sArg)"

	[[ -d "$1" ]] && eval $( udfOnError exitecho iErrorNonValidArgument "this version do not support directories, only files \($1\)..." )

	[[ -f "$1" && -n "$( git status -s "$1" | grep -P "^[ AM?][M?]\s$1" )" ]] || {

		eval $(udfOnError retwarn iErrorNonValidArgument "$1 is mask, not exist or not modified, but may be indexed...")

	}

	fn="${1##*/}"
	ic=$(( ic + 1 ))
	ts="$( date --rfc-3339=s )"
	ui="$(_ sUser)"

	if udfWarnOnEmptyVariable fn ic ts ui; then

		s="$( printf '\044Id: %s %d %s %s \044\n' "$fn" "$ic" "$ts" "$ui" )"
		eval "$( printf "$fmt" '\\\$' '\\\$' '$s' '$fn')" && git add "$1"

	fi

}
#
#
#
udfMain
#
