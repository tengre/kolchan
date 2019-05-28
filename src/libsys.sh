#
# $Id: libsys.sh 87 2019-05-29 00:45:42+04:00 yds $
#
#****h* kolchan/libsys
#  DESCRIPTION
#    OOP style wrappers for various system commands:
#    SYS::RSYNC - support for rsync
#  USES
#    libcfg
#  EXAMPLE
#    # create instance from SYS::RSYNC class
#    SYS::RSYNC rsync
#    # set various properties for rsync operation
#    rsync.pathSource = /tmp/source
#    rsync.pathTarget = /tmp/target
#    rsync.options    = -aCrv --delete-after
#    rsync.debugLevel = 2
#    rsync.title      = sync $( rsync.pathSource) to $( rsync.pathTarget )
#    rsync.onSuccess  = rm -r $( rsync.pathSource)
#    # start rsync
#    rsync.run
#    # destroy SYS::RSYNC object, free resources
#    rsync.free
#  AUTHOR
#    Damir Sh. Yakupov <yds@bk.ru>
#******
#***iV* libsys/bash compatibility
#  DESCRIPTION
#    Compatibility checked by bashlyk (bash version 4.xx or more required)
#    $_BASHLYK_LIBSYS provides protection against re-using of this module
#  SOURCE
: ${_bashlyk_pathLib:="/usr/share/bashlyk"}
[ -n "$_BASHLYK_LIBSYS_RSYNC" ] && return 0 || _BASHLYK_LIBSYS_RSYNC=1
[ -n "$_BASHLYK" ] || . ${_bashlyk_pathLib}/bashlyk || eval '                  \
                                                                               \
    echo "[!] bashlyk loader required for ${0}, abort.."; exit 255             \
                                                                               \
'
#******
#****L* libsys/Used libraries
# DESCRIPTION
#   Loading external libraries
# SOURCE
[[ -s ${_bashlyk_pathLib}/libcfg.sh ]] && . "${_bashlyk_pathLib}/libcfg.sh"
#******
#****G* libsys/Global Variables
#  DESCRIPTION
#    Global variables of the library
#  SOURCE
# rsync error states definition
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
_bashlyk_hError[$_bashlyk_iErrorMissingMethod]="instance failed - missing method"
_bashlyk_hError[$_bashlyk_iErrorBadMethod]="instance failed - bad method"
#
declare -rg _bashlyk_settings_sys_rsync='
    debugLevel fileLog onFailure onSuccess options pathSource pathTarget title truncateLog
'
declare -rg _bashlyk_methods_sys_rsync='
    run free
'
#******
#****e* libsys/SYS::RSYNC
#  SYNOPSIS
#    SYS::RSYNC [<id>]
#  DESCRIPTION
#    constructor for new instance <id> of the SYS::RSYNC "class" (object)
#  NOTES
#    constructor
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

  f=$( declare -f SYS::RSYNC::settings 2>/dev/null ) || error MissingMethod throw -- SYS::RSYNC::settings for $o
  for s in $_bashlyk_settings_sys_rsync; do

    echo "${f/SYS::RSYNC::settings/${o}.$s}" >> $fn  || error BadMethod     throw -- SYS::RSYNC::settings for $o

  done

  for s in $_bashlyk_methods_sys_rsync; do

    f=$( declare -f SYS::RSYNC::${s} 2>/dev/null ) || error MissingMethod throw -- SYS::RSYNC::${s} for $o
    echo "${f/SYS::RSYNC::$s/${o}.$s}" >> $fn      || error BadMethod     throw -- SYS::RSYNC::${s} for $o

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
#    instance:
#
#    title       - title message
#    options     - rsync options
#    pathSource  - source
#    pathTarget  - destination
#    truncateLog - max error lines to show
#    debugLevel  - debug level
#    onFailure   - run command on rsync fail
#    onSuccess   - run command on rsync success
#    fileLog     - name of a temporary file to save rsync stdout (may be readonly)
#  EXAMPLE
#    SYS::RSYNC tSettings
#    tSettings.title       = value
#    tSettings.pathSource  = /tmp/source
#    tSettings.pathTarget  = /tmp/target
#    tSettings.options     = --aCrv --delete-after
#    tSettings.debugLevel  = 2
#    tSettings.truncateLog = 10
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
#    child processes
#  TODO
#    improve verbosity level handling
#  EXAMPLE
#    mkdir -p /tmp/qwaszx1
#    date -R > /tmp/qwaszx1/qwaszx3.txt
#    SYS::RSYNC rsync
#    rsync.pathSource = /tmp/qwaszx1/
#    rsync.onSuccess  = rm -r /tmp/qwaszx1
#    rsync.pathTarget = /tmp/qwaszx2
#    rsync.run
#    test -f /tmp/qwaszx2/qwaszx3.txt                                           #? false
#    test -f /tmp/qwaszx2/qwaszx3.txt                                           #? true
#    rm -r /tmp/qwaszx{1,2}
#    rsync.free
#  SOURCE
SYS::RSYNC::run() {

  local I fnErr fnStd fnRC rc o s V
  local -a a

  o=${FUNCNAME[0]%%.*}
  V=$( ${o}.debugLevel )
  I=$( ${o}.truncateLog )

  err::debug $V && printf -- '%s:>' "$( ${o}.title )"

  std::temp fnErr
  std::temp fnRC
  std::temp fnStd
  ${o}.fileLog = $fnStd

  while read; do

    err::debugf $V '%s' '.'
    echo "$REPLY" >> $fnStd

  done< <( rsync $( ${o}.options ) $( ${o}.pathSource ) $( ${o}.pathTarget ) 2>$fnErr; echo $? >$fnRC )

  rc=$( < $fnRC )
  if (( rc > 0 )); then

    err::debug $V 'fail..'
    a=( $( wc -l $fnErr ) )

    (( ${a[0]} == 1 )) || err::debug $V 'warns:'

    if (( ${a[0]} > I )); then

      head -n $(( I/2 )) $fnErr && echo '...' && tail -n $(( I/2 )) $fnErr

    else

      (( ${a[0]} > 0 )) && std::cat < $fnErr

    fi >&2

    _bashlyk_hError[$rc]="${_rsync_hError[$rc]}"
    s="$( ${o}.onFailure )"

    if [[ $s =~ ^(echo|warn|return|echo\+return|warn\+return|exit|echo\+exit|warn\+exit|throw)$ ]]; then

      error $rc $s -- rsync: $( ${o}.pathSource ) - $( ${o}.pathTarget )

    else

      [[ $s ]] && eval "$s"

    fi

    return $rc

  else

    err::debug $V 'ok!'
    s="$( ${o}.onSuccess )" && eval "$s"
    return 0

  fi
}
#******

