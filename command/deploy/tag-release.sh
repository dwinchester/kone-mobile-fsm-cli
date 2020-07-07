#!/bin/sh

# note: ensure that you are on the release branch that requires deployment

set -e
. "${ROOT_DIR}/utils.sh"

project_path="$( get_project_path )"
cd "${project_path}"

tag="${VERSION_TAG}"

 # we do this in case any changes were made between creating the deployment and tagging it;
 # for example, updating the README
git pull

# create a `lightweight` tag for the release point, see: https://git-scm.com/book/en/v2/Git-Basics-Tagging 
git tag "${tag}"

# by pushing the tag we capture a point in history that is used for a marked 
# version release. When the tag is pushed, it triggers the `Firebase QA deploy` 
# pipeline
git push origin "${tag}"

# remove your local release branches:

# 1:- main projectgit 
git checkout development 
git branch -D "release/${tag}"

# 2:- submodule
cd "android/React"
git checkout development
git branch -D "release/${tag}"

say "${green:-}Success${normal:-} New tag created.\nPlease see: ${blue:-}https://dev.azure.com/konecorp/kone-mobile-fsm-android/_build${normal:-}"
exit 0