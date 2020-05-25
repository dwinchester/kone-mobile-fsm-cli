#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Show changes between local branches and HEAD."
  echo "Usage: kone dev diff-head [options]"
  echo ""
  echo "Options:"
  echo "  --numstat           Shows the number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more friendly."
  echo "  --shortstat         Output only the total number of modified files, as well as number of added and deleted lines."
  echo "  --submodule-only    Show only changes in the project submodule."
  echo ""
  echo "Examples:"
  echo "  kone dev diff-head"
  echo "  kone dev diff-head --numstat" 
  echo "  kone dev diff-head --shortstat --submodule-only" 
  echo "  kone dev diff-head --help" 
  echo ""
  echo "Run 'kone [command] -h|--help' for more information on a command."
  echo ""
  exit 3
}

diff() {
  git diff ${non_dynamic_parameters} HEAD~5 HEAD
}

non_dynamic_parameters=""
submodule_only=false

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    diff-head)
      ;;
    --numstat)
      non_dynamic_parameters+=" --numstat"
      ;;  
    --shortstat)
      non_dynamic_parameters+=" --shortstat"
      ;;
    --submodule-only) 
      submodule_only=true
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

if [ "${submodule_only}" = true ]; then
  cd "android/React"
  diff
  exit 0
fi

diff
exit 0