#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Description: Displays your current configuration values." 
  echo "Usage: kone configure list [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show command line help."  
  echo "  --profile <PROFILE>     Specifies the named profile to use for this command."   
  echo ""
  echo "Examples:"
  echo "  kone configure list --help"
  echo "  kone configure list"
  echo "  kone configure list --profile ios"
  echo "" 
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
    list)
      ;;
    -p|--profile)
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

config_file="${ROOT_DIR}/config/${profile}.settings"

if [ ! -f "${config_file}" ]; then
  say_warning "Profile '${profile}' not found."
  exit 0
fi

say "Showing content for profile '${profile}'."

cat "${config_file}"
exit 0