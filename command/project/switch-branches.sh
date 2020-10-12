#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone project switch-branches [options]"
  echo ""
  echo "Options:"
  echo "  --main-branch <BRANCH>            The name of the branch for the main project checkout."
  echo "  --submodule-branch <BRANCH>       The name of the branch for the submodule checkout."
  echo "  --force                           When switching branches, proceed even if the index or the working tree differs from HEAD. This is used to throw away local changes."
  echo "  --recurse-submodules              Update the content of the submodule according to the commit recorded in the superproject. If local modifications in a submodule would be overwritten the checkout will fail unless --force is used."
  echo ""
  echo "Examples:"
  echo "  kone project switch-branches --main feature/http-logging-xplatform --force"
  echo "  kone project switch-branches --main development --submodule feature/38456-analytics" 
  echo "  kone project switch-branches --help" 
  echo ""
  echo "Run 'kone [command] -h|--help' for more information on a command."
  echo ""
  exit 3
}

main_branch="${BRANCH_MAIN}"
submodule_branch="${BRANCH_SUBMODULE}"
non_dynamic_parameters=""

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    switch-branches)
      ;;  
    --force)
      non_dynamic_parameters+=" --force"
      ;;
    --main-branch)
      shift
      main_branch="${1}"
      ;; 
    --recurse-submodules)
      non_dynamic_parameters+=" --recurse-submodules"
      ;;
    --submodule-branch)
      shift
      submodule_branch="${1}"
      ;;     
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

project_path="$(get_project_path)"
cd "${project_path}"

# switch branches or restore working tree files to the configured profile
git checkout ${non_dynamic_parameters} "${main_branch}"
cd "android/React"
git checkout ${non_dynamic_parameters} "${submodule_branch}"

say "${green:-}Success${normal:-} Branches updated."
exit 0