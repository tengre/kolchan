#!/bin/bash
#
# $Id: subgit.sh 8 2016-06-22 16:24:09+04:00 toor $
#
. bashlyk
#
#
#
udfMain() {

	eval set -- "$(_ sArg)"
	[[ -n "$1" ]] || eval $(udfOnError throw iErrorEmptyOrMissingArgument)

	udfThrowOnCommandNotFound subgit

	local pathSVN pathGIT fnAuthors

	fnAuthors=~/src/authors
	pathSVN=/opt/dat/svn/${1}
	pathGIT=/opt/dat/git/${1}.git

	## TODO use svn(admin) and git tools for checking repos validity
	[[ -d $pathSVN   ]] || eval $( udfOnError throw iErrorNoSuchFileOrDir $pathSVN   )
	[[ -d $pathGIT   ]] || eval $( udfOnError throw iErrorNoSuchFileOrDir $pathGIT   )
	[[ -f $fnAuthors ]] || eval $( udfOnError throw iErrorNoSuchFileOrDir $fnAuthors )

	subgit import --authors-file $fnAuthors --svn-url file://$pathSVN $pathGIT

}
#
#
#
udfMain
#
