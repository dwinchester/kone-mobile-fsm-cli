#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone project list-branches [options]"
  echo ""
  echo "Options:"
  echo "  --all               List both remote-tracking branches and local branches."
  echo "  --submodule-only    List only branches in the project submodule."
  echo ""
  echo "Examples:"
  echo "  kone project list-branches"
  echo "  kone project list-branches --all" 
  echo "  kone project list-branches --submodule-only" 
  echo "  kone project list-branches --all --submodule-only" 
  echo "  kone project list-branches --help" 
  echo ""
  echo "Run 'kone [command] -h|--help' for more information on a command."
  echo ""
  exit 3
}

list_branches() {
  git branch --list ${non_dynamic_parameters}
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
    list-branches)
      ;;
    --all)
      non_dynamic_parameters+=" --all"
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
  list_branches
  exit 0
fi

list_branches
exit 0