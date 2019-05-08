#!/usr/bin/env bash
#
# $Id: build-deb.sh 60 2019-05-09 03:01:07+04:00 yds $
#
_bashlyk_log=nouse _bashlyk=kolchan . bashlyk

: ${DEBUGLEVEL:=2}

buildpackage::main() {

  throw on CommandNotFound dpkg-buildpackage head grep rsync sed

  local fn fnConfig pathTarget pathSource sCodeName sMode sProject

  CFG cfg
  cfg.bind.cli mode{m}: path-source{s}: path-target{t}: config{c}:
  fnConfig=$( cfg.getopt config ) || fnConfig=$( cfg.storage.use && cfg.storage.show )
  cfg.storage.use $fnConfig
  err::debug 0 project configuration $( cfg.storage.show )
  cfg.load

       sMode="$( cfg.get     []mode    )" ||      sMode='binary'
    sProject="$( cfg.get     []project )" ||   sProject=$PROJECT
  pathSource="$( cfg.get [path]source  )" || pathSource=~/src

  if ! pathTarget="$( cfg.get [path]target )"; then

    if [[ $PRJ_BUILDINFO && -s $PRJ_BUILDINFO ]]; then

      pathTarget="$( head -n 1 $PRJ_BUILDINFO )"

    else

      pathTarget="$( pwd )"

    fi

  fi

  throw on NoSuchDir $pathTarget

  cd $pathTarget || error NotPermitted throw -- $pathTarget

  if [[ -d debian.upstream && -d debian ]]; then

    rsync -rav --exclude changelog debian.upstream/ debian/
    rm -r debian.upstream

  fi

  throw on NoSuchFile debian/changelog

  if head -n 1 debian/changelog | grep -q UNRELEASED; then

    CFG cfgLSB
    cfgLSB.storage.use /etc/lsb-release
    cfgLSB.load []DISTRIB_CODENAME

    if sCodeName="$( cfg.get []DISTRIB_CODENAME )"; then

      err::debug 2 debian/changelog - use codename $sCodeName
      sed -i "1 s/UNRELEASED/$sCodeName/" debian/changelog

    fi

    cfgLSB.free

  fi

  std::temp fn
  echo -n "start building:"
  while read; do

  if   [[ $REPLY =~ dpkg-genchanges.--build=(source|any|all|binary|full).\>../(.*)$ ]]; then
    cfg.set [buildinfo]${BASH_REMATCH[1]} = ${BASH_REMATCH[2]}
  elif [[ $REPLY =~ dpkg-deb:.building.package.*in.*../(.*\.deb) ]]; then
    cfg.set [buildinfo]package = ${BASH_REMATCH[1]}
  elif [[ $REPLY =~ ^return.code:.(.*)$ ]]; then
    cfg.set [buildinfo]status = ${BASH_REMATCH[1]}
    if [[ $( cfg.get [buildinfo]status ) != '0' ]]; then
      echo "fail.."
      err::debug 0 stderr:
      cat $fn 1>&2
    else
      echo "ok!"
    fi
  else
    echo $REPLY >> $fn
    echo -n '.'
  fi

  done< <( LC_ALL=C dpkg-buildpackage --build=$sMode -rfakeroot 2>&1; echo "return code: $?" )

  err::debug 0 buildinfo:
  cfg.show
  cfg.save
  cfg.free

}
#
#
#
buildpackage::main
#
