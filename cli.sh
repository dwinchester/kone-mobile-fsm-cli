#!/bin/sh

# Stop script on NZEC
set -e

# standard output may be used as a return value in the functions
# we need a way to write text on the screen in the functions so that
# it won't interfere with the return value.
# Exposing stream 3 as a pipe to standard output of the script itself
exec 3>&1

export ROOT_DIR=$(cd $(dirname ${0}) && pwd)
script_name=$(basename "${0}")

. "${ROOT_DIR}/utils.sh" # shellcheck source

invocation='say_verbose "Calling: ${FUNCNAME[0]} $*$"' # Use in functions: eval $invocation

# check that the config file exists 
CLI_CONFIG_FILE="${ROOT_DIR}/cli.settings"
if [[ ! -f "${CLI_CONFIG_FILE}" ]]; then
  say_err "No configruation file found. Copy "`/config/template.settings`" and adjust."
  exit 1
fi

# export configs to ensure that all settings are visible to all commands
export $(cat "${CLI_CONFIG_FILE}" | xargs)
export $(cat "$(combine_paths ${ROOT_DIR} ${DEFAULT_PROFILE})" | xargs)

# if no arguments are passed, then show the welcome message
if [ $# == 0 ]; then
  echo ""  
  echo "Welcome to the KONE FSM Mobile app CLI"
  echo "---------------------------"
  echo "CLI Version ${cli_version}"
  echo ""
  echo "Use 'kone --help' to see available options and commands or visit the project wiki."
  echo "Report issues and find source on GitHub: https://github.com/konecorp/kone-mobile-fsm-cli"
  echo ""
  exit 3
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