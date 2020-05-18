#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

cd "$(get_project_path)"

# switch branches (or restore working tree files), and then fetch from and 
# integrate all changes from the remote repository

git checkout "${BRANCH_MAIN}"
git pull

cd "android/React" # update the submodule
git checkout "${BRANCH_SUBMODULE}"
git pull

say "${green:-}Success${normal:-} Project update completed."
exit 0