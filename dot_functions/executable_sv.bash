############################
#
# sv - set (clearcase) view
#
# Usage:
#
#   sv                Details of current view
#   sv [-ik] <view>   CD to view
#
#         -i   Switch to integration view
#         -k   Keep current relative directory
#
#############################

function sv() {
  #    setopt    local_options \
  #           NO_xtrace        \
  #              extended_glob

  local integration
  local keep
  local opt
  local view
  local subdir
  local basedir

  # current view base directory
  basedir=$(/usr/local/acme/bin/ccbase 2>/dev/null)

  #
  # if there are no arguments, just echo current view
  # and activity
  #
  if [[ -z $1 ]]; then
    if [[ -z ${basedir} ]]; then
      echo "Not in a view"
      return 1
    else
      _sv_status_line
      return 0
    fi
  fi

  OPTIND=1
  while getopts "hik\?" opt; do
    # loop continues till options finished
    case $opt in
      i)
        integration="true"
        ;;
      k)
        keep="true"
        ;;
      *)
        _sv_help
        return 0
        ;;
    esac
  done
  ((OPTIND > 1)) && shift $((OPTIND - 1))

  # concatenate 2nd parameter with underbar
  if [[ -n $2 ]]; then
    set -- "${1}_${2}"
  fi

  # get the current sub-directory so we
  # can cd to it after switching views
  if [[ -n $keep ]]; then

    # just ignore the error if there isn't a current
    # view
    if [[ -n $basedir ]]; then
      subdir=${PWD#"${basedir}/"}
    fi

    # clear subdir if the above substitution failed
    if [[ "$PWD" == "$subdir" ]]; then
      subdir=""
    fi
  fi

  # debug
  #set -x

  if [[ (-n ${integration} || -n ${keep}) && -z $1 ]]; then
    #
    # single -i with no view means toggle between
    # integration view
    #

    if [[ -z ${basedir} ]]; then
      _sv_help
      return 1
    else
      local other_view
      other_view=${basedir/_integration/} # strip "_integration"
      [[ ${basedir} == "${other_view}" ]] && other_view=${basedir}_integration
      view=${other_view}
    fi

  elif [[ -z $1 || -n $2 ]]; then
    #
    # else must be a single option
    #
    _sv_help
    return 127
  fi

  # full path
  if [[ -z $view && -d $1 ]]; then
    view=$1
  fi

  # view name directory
  if [[ -z $view ]]; then
    if [[ -z $integration ]]; then
      view="${HOME}/cc/?(gowen_)${1}/"
    else
      view="${HOME}/cc/?(gowen_)${1}_integration/"
    fi

    # check we found the requested view...
    if [[ -z $view ]]; then
      echo "${1:u}: View Not Found"
      return 127
    fi
  fi

  # add subdir
  [[ -n ${subdir} ]] && view="${view}/${subdir}"

  # check that view exists
  cd "${view}" 2>/dev/null || exit 1

  # echo the view and activity to the command line
  _sv_status_line

}

function _sv_status_line() {

  # view name
  # shellcheck disable=SC2155
  local view="$(/usr/local/acme/bin/ccbase 2>/dev/null)"

  # current activity + lock status
  # shellcheck disable=SC2155
  local act="$(cleartool lsact -cact -fmt "%n (%[locked]p)\n" 2>/dev/null)"
  [[ -n $act ]] && act=" --> ${act}"

  # now the tricky bit, determine if the integration stream is locked
  # shellcheck disable=SC2155
  local project="$(cleartool lsproject -cview -short 2>/dev/null)"
  local ibranch="brtype:${project}_integration@/projects"
  # shellcheck disable=SC2155
  local islocked="$(cleartool lslock -s "${ibranch}" 2>/dev/null)"

  local lockstr=""
  if [[ -n $islocked ]]; then
    # branch is locked, but is it locked for me?
    # shellcheck disable=SC2155
    local exclusions="$(cleartool lslock "${ibranch}" | grep except | grep "${USER}")"
    lockstr="(locked"
    [[ -n ${exclusions} ]] && lockstr="${lockstr}*"
    lockstr="${lockstr})"
  fi

  echo "${view:t}${lockstr}${act}"
}

function _sv_help() {
  echo "sv [-i] [-k] <view>"
}
