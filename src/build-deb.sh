#!/usr/bin/env bash
#
# $Id: build-deb.sh 70 2019-05-25 10:15:32+04:00 yds $
#
_bashlyk_log=nouse _bashlyk=kolchan . bashlyk

: ${_kolchan_pathLib:=/usr/share/kolchan}

. ${_kolchan_pathLib}/libsys.sh || throw

#
#
#
: ${DEBUGLEVEL:=2}

buildpackage::main() {

  throw on CommandNotFound dpkg-buildpackage head grep rsync sed tail wc

  local fn fnConfig pathTarget pathSource sCodeName sMode sProject
  local -a

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

    SYS::RSYNC rsync
    rsync.title      = 'merge debian.upstream with debian'
    rsync.options    = -arv --exclude changelog
    rsync.pathSource = debian.upstream/
    rsync.pathTarget = debian/
    rsync.onFailure  = throw
    rsync.onSuccess  = rm -r debian.upstream
    rsync.run
    rsync.free

  fi

  throw on NoSuchFile debian/changelog

  if head -n 1 debian/changelog | grep -q UNRELEASED; then

    CFG cfgLSB
    cfgLSB.storage.use /etc/lsb-release
    cfgLSB.load []DISTRIB_CODENAME

    if sCodeName="$( cfgLSB.get []DISTRIB_CODENAME )"; then

      err::debug 2 debian/changelog - use codename $sCodeName
      sed -i "1 s/UNRELEASED/$sCodeName/" debian/changelog

    else

      err::debug 2 DISTRIB_CODENAME value not loaded from /etc/lsb-release

    fi

    cfgLSB.free

  else

    err::debug 2 UNRELEASED tag not found on debian/changelog

  fi

  #
  # TODO split buildinfo to the 'binary' and 'source' sections (or 'mode' option)
  #

  std::temp fn
  echo -n "start building:"
  while read; do

  if   [[ $REPLY =~ dpkg-genchanges.--build=(source|any|all|binary|full).\>../(.*)$ ]]; then
    cfg.set [$sMode]${BASH_REMATCH[1]} = ${BASH_REMATCH[2]}
  elif [[ $REPLY =~ dpkg-deb:.building.package.*in.*../(.*\.deb) ]]; then
    cfg.set [$sMode]package = ${BASH_REMATCH[1]}
  elif [[ $REPLY =~ ^return.code:.(.*)$ ]]; then
    cfg.set [$sMode]status = ${BASH_REMATCH[1]}
    if [[ $( cfg.get [$sMode]status ) != '0' ]]; then
      echo "fail.."
      err::debug 0 stderr:
      cat $fn 1>&2
    else
      echo "ok!"
    fi
    cfg.set [$sMode]timestamp = $( std::date %s )
  else
    echo $REPLY >> $fn
    echo -n '.'
  fi

  done< <( LC_ALL=C dpkg-buildpackage --build=$sMode -rfakeroot 2>&1; echo "return code: $?" )

  err::debug 0 build states:
  cfg.show
  cfg.save
  cfg.free

}
#
#
#
buildpackage::main
#
