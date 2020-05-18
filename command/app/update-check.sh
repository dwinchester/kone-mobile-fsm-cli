#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "$(get_project_path)"

# list of all remote repositories that are currently connected to your local 
# repository and check for updates
git remote -v update

say "${green:-}Success${normal:-} Checking remote repository completed."
exit 0