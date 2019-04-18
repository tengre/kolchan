#!/bin/bash
#
# $Id: automake.sh 54 2019-04-18 17:21:53+04:00 yds $
#
_bashlyk=devtools . bashlyk
#
#
#
automake::main() {

  throw on NoSuchFile ChangeLog
  throw on CommandNotFound autoscan autoheader aclocal autoconf autoreconf automake cat cut grep mv pwd robodoc head tr touch sed xargs

  local fn sPackage sVersion sAuthor pathWork

  : ${sVersion:=0.1}

  errorify on CommandNotFound git && : ${sAuthor:="$( git config --get user.name ) <$( git config --get user.email )>"}

  : ${sAuthor:="${DEBFULLNAME:-$USER} <${DEBEMAIL:-$USER@localhost.localdomain}>"}

  pathWork="$( pwd )"

  [[ -s AUTHORS ]] || echo "$sAuthor" > AUTHORS

  for fn in NEWS README TODO; do [[ -f $fn ]] || touch $fn; done

  sPackage=${pathWork##*/}
  sPackage=${sPackage/-$sVersion/}
  sVersion=$(grep -i version ChangeLog | head -n 1 | xargs | cut -f 2 -d' ')
  : ${sVersion:=0.001}

  sEmail="$(grep -o -E '<.*>' AUTHORS | tr -d '<|>' | head -n 1)"

  autoscan
  mv configure.scan configure.ac || throw on NoSuchFile configure.ac

  autoheader
  sed -i -e "s/AC_INIT.*/AC_INIT(${sPackage}, ${sVersion}, ${sEmail})\nAM_INIT_AUTOMAKE/ig" configure.ac

  aclocal
  autoconf
  autoreconf
  automake --add-missing --copy

  errorify on CommandNotFound git-add-id && git-add-id

  throw on CommandNotFound ./configure make && ./configure --prefix=/usr && make

}
#
#
#
automake::main
#
