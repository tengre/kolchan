#!/usr/bin/env bash
#
# $Id: build-deb.sh 63 2019-05-16 19:06:42+04:00 yds $
#
_bashlyk_log=nouse _bashlyk=kolchan . bashlyk
#
#
#
 _rsync_hError[0]="Success"
 _rsync_hError[1]="Syntax or usage error"
 _rsync_hError[2]="Protocol incompatibility"
 _rsync_hError[3]="Errors selecting input/output files, dirs"
 _rsync_hError[4]="Requested action not supported: an attempt was made to manipulate 64-bit files on a platform that cannot support them; or an option was specified that is supported by the client and not by the server."
 _rsync_hError[5]="Error starting client-server protocol"
 _rsync_hError[6]="Daemon unable to append to log-file"
_rsync_hError[10]="Error in socket I/O"
_rsync_hError[11]="Error in file I/O"
_rsync_hError[12]="Error in rsync protocol data stream"
_rsync_hError[13]="Errors with program diagnostics"
_rsync_hError[14]="Error in IPC code"
_rsync_hError[20]="Received SIGUSR1 or SIGINT"
_rsync_hError[21]="Some error returned by waitpid()"
_rsync_hError[22]="Error allocating core memory buffers"
_rsync_hError[23]="Partial transfer due to error"
_rsync_hError[24]="Partial transfer due to vanished source files"
_rsync_hError[25]="The --max-delete limit stopped deletions"
_rsync_hError[30]="Timeout in data send/receive"
_rsync_hError[35]="Timeout waiting for daemon connection"
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

    err::debugf 0 'merge debian.upstream with debian:'
    std::temp fn
    while read; do

      err::debugf 0 '%s' '.'

    done< <( rsync -rav --exclude changelog debian.upstream/ debian/ 2>$fn; echo $? >>$fn )

    if (( $( tail -n 1 $fn ) > 0 )); then

      err::debugf 0 '%s' '?'
      a=( $( wc -l $fn ) )

      (( ${a[0]} == 1 )) || err::debug 0 'warns:'

      if (( ${a[0]} > 10 )); then

        head -n 4 $fn && echo '...' && tail -n 4 $fn

      else

        (( ${a[0]} > 0 )) && std::cat < $fn

      fi >&2

      _bashlyk_hError[$rc]="${_rsync_hError[$rc]}"
      error $rc throw "rsync: debian.upstream -> debian/"

    else

      rm -r debian.upstream
      err::debug 0 'ok'

    fi

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
    cfg.set [buildinfo]timestamp = $( std::date %s )
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
