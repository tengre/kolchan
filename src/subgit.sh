#!/bin/bash
#
# $Id: subgit.sh 27 2017-06-08 14:44:57+04:00 toor $
#
_bashlyk=developing . bashlyk
#
#
#
: ${pathSVN:=/opt/dat/svn}
: ${pathGIT:=/opt/dat/git}
: ${fnAuthors:=~/src/authors}

subgit::main() {

  eval set -- "$( _ sArg )"

  throw on MissingArgument $1
  throw on CommandNotFound subgit

  pathSVN+="/${1}"
  pathGIT+="/${1}.git"

  throw on NoSuchFileOrDir $pathGIT $pathSVN $fnAuthors

  ## TODO use svn(admin) and git tools for checking repos validity

  subgit import --authors-file $fnAuthors --svn-url file://$pathSVN $pathGIT

}
#
#
#
subgit::main
#
