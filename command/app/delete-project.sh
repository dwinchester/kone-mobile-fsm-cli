#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

say_verbose "$(get_project_path)"

# remove the project and all its contents
rm -rf "$(get_project_path)"

say "${green:-}SUCCESS${normal:-}"
exit 0