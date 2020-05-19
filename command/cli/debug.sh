#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

# get the current profile value
debug="${DEBUG}"

# toggle the debug flag
if [ "${debug}" = true ]; then
  debug=false
else 
  debug=true
fi

# set the debug value in configured profile
"${ROOT_DIR}/command/configure/set.sh" --variable DEBUG --value "${debug}"

say "${green:-}Success${normal:-} Debug enabled."
exit 0