#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Copies the default profile template and creates a new profile." 
  echo "Usage: kone configure new [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show command line help." 
  echo "  --set-default           Sets the newly created profile as the default for the CLI."    
  echo "  --profile <PROFILE>     Specifies the named profile to create."   
  echo "" 
}

copy_profile() {
  eval $invocation

  local source="${1}"
  local target="${2}"

  if [ -f "${target}" ]; then
    say_err "Cannot create profile as it already already exists. Exiting with code 1."
    exit 1
  fi
  
  # to see files as they are copied the -v option is used
  cp -v "${source}" "${target}" 
  return 0   
}

profile="default"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 0
      ;;
    new)
      ;;
    --profile)
      shift
      profile="${1}"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

copy_profile "$(combine_paths ${ROOT_DIR} ${DEFAULT_PROFILE})" \
    "$(combine_paths ${ROOT_DIR} $(combine_paths "config/" ${profile}.settings))"

say "${green:-}New profile created successfully.${normal:-}"
exit 0