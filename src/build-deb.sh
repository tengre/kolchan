#!/usr/bin/env bash
#
# $Id: build-deb.sh 55 2019-05-08 10:25:20+04:00 yds $
#
_bashlyk_log=nouse bashlyk=buildpackage . bashlyk

: ${DEBUGLEVEL:=2}

buildpackage::main() {

  throw on CommandNotFound dpkg-buildpackage head grep rsync sed

  local pathWork sCodeName

  [[ $PRJ_BUILDINFO && -s $PRJ_BUILDINFO ]] && pathWork="$( head -n 1 $PRJ_BUILDINFO )" || pathWork="$( pwd )"

  throw on NoSuchDir $pathWork

  cd $pathWork || error NotPermitted throw -- $pathWork

  if [[ -d debian.upstream && -d debian ]]; then

    rsync -rav --exclude changelog debian.upstream/ debian/
    rm -r debian.upstream

  fi

  throw on NoSuchFile debian/changelog

  if head -n 1 debian/changelog | grep -q UNRELEASED; then

    CFG cfg
    cfg.storage.use /etc/lsb-release
    cfg.load []DISTRIB_CODENAME

    if sCodeName="$( cfg.get []DISTRIB_CODENAME )"; then

      err::debug 2 debian/changelog - use codename $sCodeName
      sed -i "1 s/UNRELEASED/$sCodeName/" debian/changelog

    fi

    cfg.free

  fi


  dpkg-buildpackage -rfakeroot

}
#
#
#
buildpackage::main
#
