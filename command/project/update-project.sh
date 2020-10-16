#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

# TODO: Get named profile

project_path="$(get_project_path)"
cd "${project_path}"

# switch branches (or restore working tree files), and then fetches from and 
# integrates all changes from the remote repository

git checkout "${BRANCH_MAIN}"
git pull

cd "android/React" # update the submodule
git checkout "${BRANCH_SUBMODULE}"
git pull

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}Project update completed.${COLOR_NORMAL}"
exit 0