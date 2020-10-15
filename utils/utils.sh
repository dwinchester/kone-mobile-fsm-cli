#!/bin/sh

. "${ROOT_DIR}/utils/colors_formatting.sh"
. "${ROOT_DIR}/utils/sysfetch.sh"

invocation='say_verbose "Calling: ${FUNCNAME[0]} $*$"' # Use in functions: eval $invocation

# Setup some colors to use. These need to work in fairly limited shells.
# See if stdout is a terminal
if [ -t 1 ] && command -v tput > /dev/null; then
  # see if it supports colors
  ncolors=$(tput colors)
  if [ -n "${ncolors}" ] && [ $ncolors -ge 8 ]; then
    bold="$(tput bold       || echo)"
    normal="$(tput sgr0     || echo)"
    black="$(tput setaf 0   || echo)"
    red="$(tput setaf 1     || echo)"
    green="$(tput setaf 2   || echo)"
    yellow="$(tput setaf 3  || echo)"
    blue="$(tput setaf 4    || echo)"
    magenta="$(tput setaf 5 || echo)"
    cyan="$(tput setaf 6    || echo)"
    white="$(tput setaf 7   || echo)"
  fi
fi

show_cli_welcome() {
  echo "${COLOR_LIGHT_BLUE}"  
  echo " /::   /::  /::::::  /::   /:: /::::::::        /::::::  /::       /::::::"
  echo "| ::  /::/ /::__  ::| ::: | ::| ::_____/       /::__  ::| ::      |_  ::_/"
  echo "| :: /::/ | ::  \ ::| ::::| ::| ::            | ::  \__/| ::        | ::  "
  echo "| :::::/  | ::  | ::| :: :: ::| :::::         | ::      | ::        | ::  "
  echo "| ::  ::  | ::  | ::| ::  ::::| ::__/         | ::      | ::        | ::  "
  echo "| ::\  :: | ::  | ::| ::\  :::| ::            | ::    ::| ::        | ::  "
  echo "| :: \  ::|  ::::::/| ::: \  ::| ::::::::      |  ::::::/| :::::::: /::::::"
  echo "|__/  \__/ \______/ |__/  \__/|________/       \______/ |________/|______/"
  echo "${COLOR_NORMAL}"
  echo ""
  echo "Welcome to the KONE Mobile FSM CLI"
  echo "------------------------------------"
  echo "Version:  ${COLOR_YELLOW}${CLI_VERSION}${COLOR_NORMAL}"
  echo ""
  echo "${COLOR_CYAN}To see your CLI configuration run 'kone configure list'."
  echo ""
  echo "Use the command 'kone help' to see available options or visit the project wiki."
  echo "Report issues and find source on GitHub: ${TEXT_UNDERLINE}https://github.com/dwinchester/kone-mobile-fsm-cli${TEXT_UNDERLINE_RESET}${COLOR_NORMAL}"
  echo ""
  exit 3
}

unknown_command_message() {
  local cmd="${1}"

  echo "Could not execute because the specified command or option was not found."
  echo "Possible reasons for this include:"
  echo "  * You misspelled a built-in kone command."
  echo "  * You intended to execute the kone app, but the kone command ${cmd} does not exist."
  echo "  * You intended to run a global tool, but a kone-prefixed executable with this name could not be found on the PATH."
  echo "" 
}

cli_profile() {
  # export configs to ensure that all settings are visible to all commands through the entrypoint
  CLI_CONFIG_FILE=$( combine_paths "${ROOT_DIR}" "/cli.settings" )
  export $(cat "${CLI_CONFIG_FILE}" | xargs)

  # check that the default profile exists 
  profile=$( combine_paths "${ROOT_DIR}" "${DEFAULT_PROFILE}" )
  if [[ ! -f "${profile}" ]]; then
    say_err "No configruation profile found. Copy "`/template.settings`" to "`${profile}`" and adjust."
    exit 1
  fi
  export $(cat "${profile}" | xargs)
  return 0
}

cli_entrypoint() {
  cli_profile

  # if no arguments are passed, then show the welcome message
  if [ $# == 0 ]; then
    show_cli_welcome
  fi

  # locate the correct command to execute by looking through the commands directory
  # for folders and files and match the arguments
  arg_start=1
  cmd_name="${!arg_start}"
  cmd_file="${ROOT_DIR}/command/${cmd_name}"

  while [[ -d "${cmd_file}" && $arg_start -le $# ]]; do
    # if the user provides help as the last argument, then display help
    if [[ "${!arg_start}" == "help" ]]; then
      # strip off the "help" portion of the command
      args=("$@")
      unset "args[$((arg_start-1))]"
      args=("${args[@]}")

      "${ROOT_DIR}/help.sh" $0 ${args[@]}
      exit 3
    fi

    arg_start=$(($arg_start+1))

    if [ -z "${!arg_start}" ]; then
      cmd_file="${cmd_file}/${cmd_name}.sh" 
    else
      cmd_file="${cmd_file}/${!arg_start}.sh" 
    fi 
  done

  # place the arguments for the command in their own list to make them easier 
  # to work with
  cmd_args=("${@:arg_start}")

  # if we hit a directory by the time we run out of arguments, then our user
  # hasn't completed their command, so we'll show them the help for that directory
  if [ -d "${cmd_file}" ]; then
    "${ROOT_DIR}/help.sh" $0 $@
    exit 3
  fi

  # if a command could not be found, then display an error message
  if [[ ! -f "${cmd_file}" ]]; then
    "${ROOT_DIR}/help.sh" $0 ${@:1:$(($arg_start-1))}
    exit 3
  fi

  # run the command and capture its exit code for introspection
  "${cmd_file}" ${cmd_args[@]}
  EXIT_CODE=$?

  # if the command exited with an exit code of 3 then show the help 
  # documentation
  if [[ ${EXIT_CODE} == 3 ]]; then
    say_warning 'Exited with code 3.'
  fi

  # exit with the same code as the command
  exit $EXIT_CODE
}

function cli_resolve_path() {
    perl -e 'use Cwd "abs_path"; print abs_path(shift)' "$1"
}

# cli_auto_completion() {
#   local root_dir=$(dirname "$( cli_resolve_path "$( which "${COMP_WORDS[0]}" )" )" )
#   local current_arg="${COMP_WORDS[COMP_CWORD]}"  
# }

say_warning() {
  printf "%b\n" "${COLOR_YELLOW:-}kone_cli: Warning: ${1}${COLOR_NORMAL:-}"
}

say_err() {
  printf "%b\n" "${COLOR_RED:-}kone_cli: Error: ${1}${COLOR_NORMAL:-}" >&2
}

say() {
  # using stream 3 (defined in the beginning) to not interfere with stdout of functions
  # which may be used as return value
  printf "%b\n" "${cyan:-}kone_cli:${normal:-} ${1}" >&3
}

say_verbose() {
  if [ "${verbose}" = true ]; then
    say "${1}"
  fi
}

debugger() {
  if [ "${DEBUG}" = true ]; then
    local now="$(date +"%Y%m%d%I%M")"
    local log="${ROOT_DIR}/log/cli-debug-${now}.log" # output: cli-debug-202004240958.log

    printf 'Log File - ' > "${log}"
    
    # append date to log file
    date >> "${log}"

    echo "${1}" >> "${log}" # append the log file
    printf "%b\n" "${magenta:-}kone_cli: Debug: ${1}${normal:-}"
  fi
}

open () {
  xdg-open "$@">/dev/null 2>&1
}

machine_has() {
  eval $invocation

  hash "${1}" > /dev/null 2>&1
  return $?
}

check_min_reqs(){
  eval $invocation

  local has_minimum=false

  if machine_has "node"; then
    has_minimum=true
  elif machine_has "react-native"; then
    has_minimum=true
  fi

  if [ "${has_minimum}" = false ]; then
    say_err 'Install missing prerequisites to proceed.'
    return 1
  fi

  return 0
}

to_lowercase() {
  eval $invocation

  echo "${1}" | tr '[:upper:]' '[:lower:]'
  return 0
}

to_upper() {
  eval $invocation

  echo "${1}" | tr '[:lower:]' '[:upper:]'
  return 0
}

remove_trailing_slash() {
  eval $invocation

  local input="${1:-}"
  echo "${input%/}"
  return 0
}

remove_beginning_slash() {
  eval $invocation

  local input="${1:-}"
  echo "${input#/}"
  return 0
}

combine_paths() {
  eval $invocation

  # TODO: Consider making it work with any number of paths. For now:
  if [ ! -z "${3:-}" ]; then
    say_err "combine_paths: Function takes two parameters."
    return 1
  fi

  local root_path="$(remove_trailing_slash "${1}")"
  local child_path="$(remove_beginning_slash "${2:-}")"

  say_verbose "combine_paths: root_path=$root_path"
  say_verbose "combine_paths: child_path=$child_path"

  echo "$root_path/$child_path"
  return 0
}

get_theme() {
  eval $invocation

  cli_theme=$( combine_paths "${ROOT_DIR}" "${COLOR_THEME}" )
  if [[ ! -f "${cli_theme}" ]]; then
    say_err "No theme found: ${cli_theme}"
    exit 1
  fi
  echo "${cli_theme}"
  return 0
}

resolve_installation_path() {
  eval $invocation

  local install_dir="$(to_lowercase "${1}")"

  if [ "${install_dir}" = "auto" ]; then
    local default_install_dir="$HOME/Library/Kone"
    say_verbose "resolve_installation_path: default_install_dir=${default_install_dir}"
    echo "${default_install_dir}"
    return 0
  fi

  echo "${install_dir}"
  return 0
}

get_absolute_path() {
  eval $invocation

  local relative_or_absolute_path="${1}"
  echo "$(cd "$(dirname "${1}")" && pwd -P)/$(basename "${1}")"
  return 0
}

is_project_installed() {
  eval $invocation

  local project_path="${1}"
  say_verbose "is_project_installed: project_path=${project_path}"

  if [[ -d "${project_path}" ]]; then
    return 0
  else
    return 1
  fi
}

get_project_path() {
  eval $invocation

  # get the project location
  local install_root="$(resolve_installation_path "${INSTALL_DIR}")"
  local project_path="$(combine_paths "${install_root}" "${ASSET_RELATIVE_PATH}")"

  # check that the dir exits
  if ! is_project_installed "${project_path}"; then
    say_err "No such directory: ${project_path}" 
    return 1
  fi
  echo "${project_path}"
  return 0
}

set_config() {
  eval $invocation

  value_esc=$( echo $2 | sed 's_/_\\/_g' )
  sed -i '' "s/\($(to_upper $1) *= *\).*/\1$value_esc/" "${3}"

  return 0
}