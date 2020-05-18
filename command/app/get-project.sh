#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

clone_repos() {
  eval $invocation
  
  git clone -b "${BRANCH_MAIN}" "${GITHUB_REPO}"
}

initialize_submodule() {
  eval $invocation

  local install_node_modules="${1}"

  # initialize the react submodule and clone
  git submodule init
  git submodule update

  # run `npm i` to install node modules 
  if [ "${install_node_modules}" == true ]; then
    cd "android/React"
    npm i
  fi
  return 0
}

install_app() {
  eval $invocation

  project_path="$(get_project_path)"

  # check if the project is already installed
  if is_project_installed "${project_path}"; then
    say_err "KONE FSM app is already installed."
    return 0
  fi

  # create the installation directories and clone the project repositories
  mkdir -p "${install_root}" && cd "$_"
  clone_repos

  # check if the repos cloned successfully; if not, fail the installation
  is_asset_installed=false

  if is_project_installed "${project_path}"; then
    is_asset_installed=true
  fi

  if [ "${is_asset_installed}" = false ]; then
    say_err 'Failed to install with an unknown error.'
    return 0
  fi

  cd "${project_path}"
  initialize_submodule "${install_dependencies}"

  [ "${output_launch_file}" == true ] && get_launch_file "${project_path}"; return 0;

  return 0
}

dry_run=false
install_dependencies=true
non_dynamic_parameters=""
output_launch_file=false

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      echo ""
      echo "Description: Clone the project and install project-to-project dependencies."
      echo "Usage: kone app get-project [options] [[--] <additional arguments>]]"
      echo ""
      echo "Options:"
      echo "  -h, --help                Show command line help."     
      echo "  --dry-run                 Do not perform installation. Display the outcome of an installation."
      echo "  --no-dependencies         Ignores project-to-project dependencies and only initializes the specified root project." 
      echo "  --output-launch-file      Prints the location of the project launch file."
      echo ""
      echo "Additional Arguments:"
      echo "  Arguments passed to the application that is being run."
      echo ""
      echo "Install Location:"
      echo "  Location is chosen in following order:"
      echo "    - INSTALL_DIR from project.settings"      
      echo "    - $HOME/Library/Kone"
      echo ""
      echo "Examples:"
      echo "  kone app get-project --help"
      echo "  kone app get-project --output-launch-file"
      echo ""
      exit 3
      ;;     
    get-project)
      ;;
    --dry-run)
      dry_run=true
      non_dynamic_parameters+=" ${key}"
      ;;
    --no-dependencies)
      install_dependencies=false
      non_dynamic_parameters+=" ${key}"
      ;;   
    --output-launch-file)
      output_launch_file=true
      non_dynamic_parameters+=" ${key}"
      ;;            
    *)
      say_err "$(unknown_command_message ${key})"
      exit 3
      ;;
  esac
  shift
done

check_min_reqs
script_name=$(basename "$0")

if [ "${dry_run}" = true ]; then
    say "Check min requirements"
    repeatable_command="kone app ${script_name%.sh}"
    repeatable_command+="${non_dynamic_parameters}"
    say "Repeatable invocation: ${repeatable_command}"
    exit 0
fi

install_app

say "${green:-}Success${normal:-} Project clone completed."
exit 0