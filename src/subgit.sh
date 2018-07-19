#!/bin/bash
#
# $Id: subgit.sh 43 2018-07-19 22:45:28+04:00 yds $
#
_bashlyk=svn2git . bashlyk
#
#
#
subgit::main() {

  throw on CommandNotFound subgit
  
  local pathGIT pathSVN project
  local -a aAuthors
  
  CFG cfg
  
  cfg.bind.cli authors{a}:-- config{c}: help{h} git{g}: project{p}: svn{s}:
  
  cfg.storage.use $( cfg.getopt config )
  
  cfg.load []git,project,svn [authors]=
  
  pathGIT=$( cfg.get git ) 
  pathSVN=$( cfg.get svn ) 
  project=$( cfg.get project ) 

  s=$( cfg.get [authors] )
  eval "${s/declare -a a/declare -a aAuthors}"
  
  cfg.free
  
  : ${pathGIT:=opt/dat/git}
  : ${pathSVN:=opt/dat/svn}

  if [[ $project ]]; then
  
    pathGIT+="/${project}.git"
    pathSVN+="/${project}"
  
  fi

  throw on NoSuchFileOrDir $pathSVN
  
  #
  # prepare authors substitution
  #
  std::temp fnAuthors 
  for s in "${aAuthors[@]}"; do
  
    echo "$s" >> $fnAuthors
  
  done
  [[ -s $fnAuthors ]] && fnAuthors="--authors-file $fnAuthors" || fnAuthors=

  ## TODO use svn(admin) and git tools for checking repos validity

  subgit import $fnAuthors --svn-url file://${pathSVN} $pathGIT

}
#
#
#
subgit::main
#
