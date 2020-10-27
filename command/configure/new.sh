#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "${COLOR_YELLOW}Copies the default profile template and creates a new profile.${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}VERSION:${COLOR_NORMAL} ${BACKGROUND_BLUE}${CLI_VERSION}${BACKGROUND_NORMAL}"
  echo ""
  echo "${COLOR_DARK_GRAY}USAGE:${COLOR_NORMAL}" 
  echo "${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}new${COLOR_NORMAL} ${COLOR_MAGENTA}[arguments]${COLOR_NORMAL}"       
  echo ""
  echo "${COLOR_DARK_GRAY}ARGUMENTS${COLOR_NORMAL}                          ${COLOR_DARK_GRAY}DESCRIPTION:${COLOR_NORMAL}"
  echo "${COLOR_MAGENTA}-h, --help${COLOR_NORMAL}                         ${COLOR_LIGHT_GRAY}Show command line help.${COLOR_NORMAL}"    
  echo "${COLOR_MAGENTA}-d, --default${COLOR_NORMAL}                      ${COLOR_LIGHT_GRAY}Sets the profile as the default for the CLI.${COLOR_NORMAL}" 
  echo "${COLOR_MAGENTA}-p, --profile <PROFILE_NAME>${COLOR_NORMAL}       ${COLOR_LIGHT_GRAY}Specifies the named profile to create.${COLOR_NORMAL}"   
  echo ""
  echo ""
  echo "${COLOR_DARK_GRAY}EXAMPLES:${COLOR_NORMAL}" 
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}new${COLOR_NORMAL} ${COLOR_MAGENTA}--profile android${COLOR_NORMAL}"
  echo "$ ${COLOR_GREEN}kone${COLOR_NORMAL} ${COLOR_YELLOW}configure${COLOR_NORMAL} ${COLOR_CYAN}new${COLOR_NORMAL} ${COLOR_MAGENTA}--profile android --default${COLOR_NORMAL}"
  echo ""
}

set_config() {
  eval $invocation

  sed -i '' "s/\($(to_upper $1) *= *\).*/\1$2/" "${3}"

  return 0
}

copy_profile() {
  eval $invocation

  local source="${1}"
  local target="${2}"

  if [ -f "${target}" ]; then
    say_err "Cannot create profile '${profile}' as it already already exists. Exiting with code 1."
    exit 1
  fi

  say "Copying ${source} to ${target}"
  
  # to see files as they are copied the -v option can be used
  cp "${source}" "${target}" 
  return 0   
}

profile="default"
set_default=false

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
    -d|--default)
      set_default=true
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

if [ "${profile}" = "default" ]; then
  say_err "Cannot create new profile. The '--profile' option is required. Exiting with code 1."; 
  exit 1;
fi

copy_profile "${ROOT_DIR}/${DEFAULT_PROFILE}" "${ROOT_DIR}/config/${profile}.settings"

if [ "${set_default}" = true ]; then
  set_config "default_profile" "config\/${profile}.settings" "${ROOT_DIR}/cli.settings"
fi

say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} ${COLOR_GREEN}New profile created.${COLOR_NORMAL}"
exit 0