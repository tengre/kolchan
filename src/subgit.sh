#!/bin/bash
#
# $Id: subgit.sh 20 2017-02-16 16:50:18+04:00 toor $
#
. bashlyk
#
#
#
: ${pathSVN:=/opt/dat/svn}
: ${pathGIT:=/opt/dat/git}
: ${fnAuthors:=~/src/authors}

udfMain() {

  eval set -- "$( _ sArg )"

  udfOn MissingArgument throw $1

  udfThrowOnCommandNotFound subgit

  pathSVN+="/${1}"
  pathGIT+="/${1}.git"

  udfOn NoSuchFileOrDir throw $pathGIT $pathSVN $fnAuthors

  ## TODO use svn(admin) and git tools for checking repos validity

  subgit import --authors-file $fnAuthors --svn-url file://$pathSVN $pathGIT

}
#
#
#
udfMain
#
