## Clearcase diff with previous version
#
# Usage:
#
#   ctpdiff [-h] [-x] <file>
#   ctpdiff -?
#
#     -h  Compare hijacked <file> with latest version
#     -x  Don't lanch the graphical diff tool

function ctpdiff() {
  local base
  local mode="pre"
  local disOpt="-graphical"

  OPTIND=1
  while getopts "hx" opt; do
    case $opt in
      h) mode="hijack" ;;
      x) disOpt="" ;;
    esac
  done
  ((OPTIND > 1)) && shift $((OPTIND - 1))

  case $mode in
    hijack) base=$(cleartool ls ${1} | grep hijacked | cut -d " " -f 1) ;;
    pre) disOpt="-pred ${disOpt}" ;;
  esac

  echo "cleartool diff ${disOpt} $base $1"
  cleartool diff ${disOpt} $base $1

}
