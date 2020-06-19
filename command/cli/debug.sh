#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

help_arg=2
if [ "${!help_arg}" == "help" ]; then
  say "Usage: kone cli debug"  
  exit 3
fi

# get the current profile value
debug="${DEBUG}"
message=""

# toggle the debug flag
if [ "${debug}" = true ]; then
  debug=false
  message="Debug has been disabled"
else 
  debug=true
  message="Debug has been enabled"
fi

# set the debug value in configured profile
"${ROOT_DIR}/command/configure/set.sh" --setting DEBUG --value "${debug}"

say "${yellow:-}Warning${normal:-} ${message}."
exit 0