#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone configure set-default [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                  Show command line help."  
  echo "  -p, --profile <PROFILE>     Specifies the named profile to use for this command."   
  echo ""
  echo "Examples:"
  echo "  kone configure set-default --help"
  echo "  kone configure set-default --profile ios"
  echo "" 
}

set_config() {
  eval $invocation

  sed -i '' "s/\($(to_upper $1) *= *\).*/\1$2/" "${3}"

  return 0
}

profile="default"

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    set-default)
      ;;
    -p|--profile)
      shift
      profile="${1}"
      ;;
    *) # unknown option      
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

set_config "default_profile" "config\/${profile}.settings" "${ROOT_DIR}/cli.settings"

say "${green:-}Success${normal:-} Profile ${profile} set to default."
exit 0