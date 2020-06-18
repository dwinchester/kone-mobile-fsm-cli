#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone deploy [options] [[--] <additional arguments>]]"
  echo ""
  echo "Options:"
  echo "  --description <DESCRIPTION>     Use the given <DESCRIPTION> as the commit message."
  echo "  --update-apply                  Checks if there are updates available for the project repository and pulls them."
  echo "  --update-check                  Checks if there are updates available for the project repository."
  echo "  --version <VERSION_TAG>         The version number for the release. Default uses the configured profile VERSION_TAG setting."
  echo ""
  echo "Examples:"
  echo "  kone deploy create-replease --version 9.3.0 --description "\"Integrated new version of FSL SDK"\""
  echo "  kone deploy create-replease --update-apply" 
  echo "  kone deploy create-replease --help" 
  echo ""
  echo "Run 'kone [command] -h|--help' for more information on a command."
  echo ""
  exit 3
}

tag="${VERSION_TAG}"
description="Created release ${tag}"
project_path="$(get_project_path)"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    create-release)
      ;;
    --description)
      shift
      description="${1}"
      ;;
    --update-apply)
      . "${ROOT_DIR}/command/app/update-project.sh"
      exit 0
      ;;
    --update-check)
      . "${ROOT_DIR}/command/app/update-check.sh"
      exit 0
      ;;   
    --version)
      shift
      tag="${1}"
      # updates the VERSION_TAG setting in the configured profile. We do
      # this so that the `tag-release` command can push the new version
      "${ROOT_DIR}/command/configure/set.sh" --variable VERSION_TAG --value "${1}"
      ;; 
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

# set the release branch name
branch="release/${tag}"

# create the release branches from the `development` branch:

# # 1:- main project
cd "${project_path}"
git checkout -b "${branch}" development

# 2:- submodule
cd "android/React"
latest_commit=$(git rev-parse HEAD)
git checkout -b "${branch}" "${latest_commit}"
git push --set-upstream origin "${branch}" # push the new submodule branch

# 3:- commit the new submodule hash
cd "../../"
git add .
git commit -m "${description}"
git push --set-upstream origin "${branch}"

say "${green:-}Success${normal:-} New release created.\nWhen you are ready, run: ${yellow:-}kone deploy tag-release${normal:-}"
exit 0