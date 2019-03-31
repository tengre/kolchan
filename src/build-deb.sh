#!/bin/bash
#
# $Id: build-deb.sh 51 2019-03-31 18:37:18+04:00 yds $
#
_bashlyk=buildpackage . bashlyk

: ${DEBUGLEVEL:=2}

buildpackage::main() {

  throw on CommandNotFound dpkg-buildpackage head grep rsync sed

  local sCodeName

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
