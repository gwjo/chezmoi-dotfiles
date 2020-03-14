##
## Easily jump around the SBC source code
##


## change to directoru based on SD stream
#
# Usage:
#
#  _sd_cd <SD2 dir> <SD4 dir>
#
function _sd_cd () {
    declare -r CCBASE=`/usr/local/acme/bin/ccbase`

    if [[ -z ${CCBASE} ]] ; then
      echo "Not a clearcase view"
      return
    fi

    if [[ -d "${CCBASE}/${1}" ]] ; then
      cd "${CCBASE}/${1}"
    elif [[ -z ${2} && -d "${CCBASE}/${2}" ]] ; then
      cd "${CCBASE}/${2}"
    else
      echo "Not found"
    fi
}

## change to an acme directory
function _acme_cd () {
    _sd_cd acme/${1} sd_vi/acme/${2}
}

## change to app directory
function _app_cd () {
    _acme_cd bin/${1} apps/${1}
}

## change to linux directory
function _linux_cd () {
    _sd_cd linux/${1} 
}

## Alias to jump around the code base

alias base='_sd_cd . .'
alias acme='_acme_cd . .'
alias bin='_app_cd .'
alias inc='_acme_cd include/acme include'

alias acli='_app_cd acli'
alias algd='_app_cd algd'   # sd2 only
alias atcp='_app_cd atcp'
alias berp='_app_cd berp'
alias broker='_app_cd broker'
alias ccd='_app_cd ccd'
alias collect='_app_cd collect'
alias ebmd='_app_cd ebmd'
alias embd='_app_cd ebmd'    # common misspelling
alias iked='_app_cd iked'
alias h248='_app_cd h248'
alias h323='_app_cd h323'
alias lid='_app_cd lid'
alias lem='_app_cd lem'
alias mbcd='_app_cd mbcd'
alias mgcp='_app_cd algd'   # use this instead of algd (sd2 only)
alias radius='_app_cd radius'
alias sip='_app_cd sip'
alias snmp='_app_cd snmp'
alias sysman='_app_cd sysman'
alias xserv='_app_cd xserv'

alias account='_acme_cd lib/accounting lib/accounting'
alias common='_acme_cd lib/common lib/common'
alias dam='_acme_cd lib/dam lib/dam'
alias sig='_acme_cd lib/sig lib/sig' # sd4 only

alias aplib='_sd_cd aplib/private/common .'
alias apinc='_sd_cd aplib/private/include .'

alias linux='_linux_cd .'
alias private='_linux_cd private'
alias public='_linux_cd public'
alias shared='_linux_cd shared'
