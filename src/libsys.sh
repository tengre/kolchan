#
# $I$
#
: ${_bashlyk_pathLib:="/usr/share/bashlyk"}

[ -n "$_BASHLYK_LIBSYS_RSYNC" ] && return 0 || _BASHLYK_LIBSYS_RSYNC=1
[ -n "$_BASHLYK" ] || . ${_bashlyk_pathLib}/bashlyk || eval '                  \
                                                                               \
    echo "[!] bashlyk loader required for ${0}, abort.."; exit 255             \
                                                                               \
'
#******
#****L* libcfg/Used libraries
# DESCRIPTION
#   Loading external libraries
# SOURCE
[[ -s ${_bashlyk_pathLib}/libcfg.sh ]] && . "${_bashlyk_pathLib}/libcfg.sh"
#******
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
_bashlyk_iErrorMissingMethod=165
_bashlyk_iErrorBadMethod=164
_bashlyk_iErrorExtraCharInKey=163
_bashlyk_hError[$_bashlyk_iErrorMissingMethod]="instance failed - missing method"
_bashlyk_hError[$_bashlyk_iErrorBadMethod]="instance failed - bad method"
_bashlyk_hError[$_bashlyk_iErrorExtraCharInKey]="extra character(s) in the key"
#
#
#
declare -rg _bashlyk_settings_sys_rsync='
    title options pathSource pathTarget truncateLog debugLevel onFailure onSuccess
'
declare -rg _bashlyk_methods_sys_rsync='
    run free
'
#
: ${DEBUGLEVEL:=2}

#####
# SYS::RSYNC rsync
# rsync.Title       = sync
# rsync.Options     = -aCrv --exclude changelog
# rsync.pathSource  = debian.upstream
# rsync.pathTarget  = debian/
# rsync.ShowMaxLine = 16
# rsync.DEBUGLEVEL  = info
# rsync.onFailure   = throw
# rsync.onSuccess   = rm -r debian.upstream
#****e* libsys/SYS::RSYNC
#  SYNOPSIS
#    SYS::RSYNC [<id>]
#  DESCRIPTION
#    constructor for new instance <id> of the SYS::RSYNC "class" (object)
#  NOTES
#    public method
#  ARGUMENTS
#    valid variable name for created instance, default - used class name RSYNC as
#    instance
#  ERRORS
#    InvalidVariable  - invalid variable name for instance
#    IniMissingMethod - method not found
#    IniBadMethod     - bad method
#  EXAMPLE
#    SYS::RSYNC tnew                                                           #? true
#    declare -f tnew.title >/dev/null 2>&1                                     #= true
#    declare -f tnew.run   >/dev/null 2>&1                                     #= true
#    declare -f tnew.free  >/dev/null 2>&1                                     #= true
#    tnew.free
#  SOURCE
SYS::RSYNC() {

  local f fn s o=${1:-RSYNC}

  throw on InvalidVariable $o

  CFG ${o}_settings

  std::temp fn path="${TMPDIR}/${USER}/bashlyk" prefix='sys.rsync' suffix=".${o}"

  f=$( declare -f SYS::RSYNC::settings 2>/dev/null ) || error IniMissingMethod throw -- SYS::RSYNC::settings for $o
  for s in $_bashlyk_settings_sys_rsync; do

    echo "${f/SYS::RSYNC::settings/${o}.$s}" >> $fn  || error IniBadMethod     throw -- SYS::RSYNC::settings for $o

  done

  for s in $_bashlyk_methods_sys_rsync; do

    f=$( declare -f SYS::RSYNC::${s} 2>/dev/null ) || error IniMissingMethod throw -- SYS::RSYNC::${s} for $o
    echo "${f/SYS::RSYNC::$s/${o}.$s}" >> $fn      || error IniBadMethod     throw -- SYS::RSYNC::${s} for $o

  done

  source $fn || error InvalidArgument throw $fn
  return 0

}
#******
#****e* libsys/SYS::RSYNC::free
#  SYNOPSIS
#    SYS::RSYNC::free
#  DESCRIPTION
#    destructor of the instance
#  NOTES
#    public method
#  EXAMPLE
#    local i o s
#    SYS::RSYNC tRsync
#    tRsync.title = rsync instance test
#    tRsync.free                                                                 #? true
#    declare -f tRsync.title                                                     #? false
#  SOURCE
SYS::RSYNC::free() {

  local o s

  o=${FUNCNAME[0]%%.*}

  ${o}_settings.free

  for s in $_bashlyk_settings_sys_rsync $_bashlyk_methods_sys_rsync; do

    unset -f ${o}.$s

  done

}
#******
#****p* libsys/SYS::RSYNC::settings
#  SYNOPSIS
#    SYS::RSYNC::settings [ <value> ]
#  DESCRIPTION
#    set or get propertie(s) of the SYS::RSYNC instance
#  ARGUMENTS
#    <value> - set new value for selected properties
#              default, show property value
#  NOTES
#    fully virtual function, replaced by "get/set" methods when initializing an
#    instance
#  EXAMPLE
#    SYS::RSYNC tSettings
#    tSettings.title value
#    tSettings.pathSource /tmp/source
#    tSettings.pathTarget /tmp/target
#    tSettings.title                                                            | {{ '^value$'     }}
#    tSettings.pathSource                                                       | {{ ^/tmp/source$ }}
#    tSettings.pathTarget                                                       | {{ ^/tmp/target$ }}
#    tSettings.free
#  SOURCE
SYS::RSYNC::settings() {

  local o=${FUNCNAME[0]%%.*} f=${FUNCNAME[0]#*.}
  [[ $* ]] && ${o}_settings.set $f $* || ${o}_settings.get $f
}
#******
#****e* libsys/SYS::RSYNC::run
#  SYNOPSIS
#    SYS::RSYNC::run
#  DESCRIPTION
#    run rsync configured by instance
#  NOTES
#    public method
#  ERRORS
#    MissingArgument - the storage name is not specified
#  EXAMPLE
#    mkdir -p /tmp/qwaszx1
#    date -R > /tmp/qwaszx1/qwaszx3.txt
#    SYS::RSYNC rsync
#    rsync.pathSource /tmp/qwaszx1/
#    rsync.pathTarget /tmp/qwaszx2
#    rsync.run
#    test -f /tmp/qwaszx2/qwaszx3.txt                                           #? true
#    rm -r /tmp/qwaszx{1,2}
#    rsync.free
#  SOURCE
SYS::RSYNC::run() {

  local I rc o s V
  local -a a

  o=${FUNCNAME[0]%%.*}
  V=$( ${o}.debugLevel )
  I=$( ${o}.truncateLog )

  err::debug $V && ${o}.title

  std::temp fn
  while read; do

    err::debugf $V '%s' '.'

  done< <( rsync $( ${o}.options ) $( ${o}.pathSource ) $( ${o}.pathTarget ) 2>$fn; echo $? >>$fn )

  rc=$( tail -n 1 $fn )
  if (( rc > 0 )); then

    err::debug $V '?'
    a=( $( wc -l $fn ) )

    (( ${a[0]} == 1 )) || err::debug $V 'warns:'

    if (( ${a[0]} > I )); then

      head -n $(( I/2 )) $fn && echo '...' && tail -n $(( I/2 )) $fn

    else

      (( ${a[0]} > 0 )) && std::cat < $fn

    fi >&2

    _bashlyk_hError[$rc]="${_rsync_hError[$rc]}"
    eval $( ${o}.onFailure )
    error $rc warn -- rsync: $( ${o}.pathSource ) -> $( ${o}.pathTarget )

  else

    err::debug $V 'ok'
    eval $( ${o}.onSuccess )

  fi
}
#******

