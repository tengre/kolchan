#!/bin/bash
#
# $Id: subgit.sh 13 2016-06-23 15:33:18+04:00 toor $
#
. bashlyk
#
#
#
: ${pathSVN:=/opt/dat/svn}
: ${pathGIT:=/opt/dat/git}
: ${fnAuthors:=~/src/authors}


udfMain() {

	eval set -- "$(_ sArg)"
	[[ -n "$1" ]] || eval $(udfOnError throw iErrorEmptyOrMissingArgument)

	udfThrowOnCommandNotFound subgit

	pathSVN+="/${1}"
	pathGIT+="/${1}.git"

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
