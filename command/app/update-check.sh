#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

project_path="$(get_project_path)"
cd "${project_path}"

say "Checking remote repository"

# list of all remote repositories that are currently connected to your local 
# repository and check for updates
git remote -v update

say "${green:-}SUCCESS${normal:-}"
exit 0