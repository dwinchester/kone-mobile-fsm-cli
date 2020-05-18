#!/bin/sh

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

unknown_command_message() {
  local cmd="${1}"

  echo "Could not execute because the specified command or option was not found."
  echo "Possible reasons for this include:"
  echo "  * You misspelled a built-in kone command."
  echo "  * You intended to execute the kone app, but the kone command ${cmd} does not exist."
  echo "  * You intended to run a global tool, but a kone-prefixed executable with this name could not be found on the PATH."
  echo "" 
}

say_warning() {
  printf "%b\n" "${yellow:-}kone_cli: Warning: ${1}${normal:-}"
}

say_err() {
  printf "%b\n" "${red:-}kone_cli: Error: ${1}${normal:-}" >&2
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

debug() {
  if [ "${DEBUG}" = true ]; then
    local now="$(date +"%Y%m%d%I%M")"
    local log="${ROOT_DIR}/log/release-${now}.log" # output: release-202004240958.log

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

list_folders() {
  eval $invocation

  # find all folders in the the current folder recursively and do not return hidden files.
  # remove the prepended ./ from the result list
  find . -maxdepth 1 -type d -not -path '*/\.*' | sed 's/^\.\///g' | sort
  return 0
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
  #eval $invocation

  local input="${1:-}"
  echo "${input%/}"
  return 0
}

remove_beginning_slash() {
  #eval $invocation

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

resolve_installation_path() {
  eval $invocation

  local install_dir="$(to_lowercase "${1}")"

  if [ "${install_dir}" = "<auto>" ]; then
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

get_launch_file() {
  eval $invocation

  local project_path="${1}"
  local launch_file="$(combine_paths "${project_path}" "${LAUNCH_FILE_RELATIVE_PATH}")"

  echo "${magenta:-}Launch file: ${launch_file}${normal:-}"
  return 0
}

is_app_installed() {
  if adb shell pm list packages | grep ${PACKAGE_NAME}; then
    return 0
  fi
  return 1
}

set_config() {
  eval $invocation

  sed -i '' "s/\($(to_upper $1) *= *\).*/\1$2/" "${3}"

  return 0
}






# cli_info() {
#   KONE FSM app:
#   ---------------------------

#   Version: 0.1.0
#   Commit: bc5f8df
  
#   Projects:
#   Android [/Users/lwinchester/Desktop/sfdc/konecorp/kone-mobile-fsm-android]
#   iOS [/Users/lwinchester/Desktop/sfdc/konecorp/kone-mobile-fsm-ios]
#   ReactNative [/Users/lwinchester/Desktop/sfdc/konecorp/kone-mobile-fsm-ReactNative]

#   Distributed versions:
#   8.1.1 [f47d52b]
#   8.1.0 [bdf1d88]
#   7.3.3 [9d5daf2]

#   SDKs available:
#   fsl-android-sdk-224.0.0-RC.2-02112020 [/Users/lwinchester/Desktop/sfdc/konecorp/sdk/]
#   fsl-android-sdk-222.0.1-102419 [/Users/lwinchester/Desktop/sfdc/konecorp/sdk/]
# }

# list_projects() {
#   Android [/Users/lwinchester/Desktop/sfdc/konecorp/kone-mobile-fsm-android]
#   iOS [/Users/lwinchester/Desktop/sfdc/konecorp/kone-mobile-fsm-ios]
#   ReactNative [/Users/lwinchester/Desktop/sfdc/konecorp/kone-mobile-fsm-ReactNative]
# }

# list_sdk() {
#   fsl-android-sdk-224.0.0-RC.2-02112020 [/Users/lwinchester/Desktop/sfdc/konecorp/sdk/]
#   fsl-android-sdk-222.0.1-102419 [/Users/lwinchester/Desktop/sfdc/konecorp/sdk/] 
# }

# sdk_version() {
#   224.0.0-RC.2-02112020
# }