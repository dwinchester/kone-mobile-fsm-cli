#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone project update-check [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help      Show command line help."  
  echo "  --graph         View a Git graph of your local repository."   
  echo "  --history       Shows your local repository commit logs."
  echo "  --log           Shows a oneline representation of your local repository commit logs."
  echo ""
  echo "Examples:"
  echo "  kone project update-check --help"
  echo "  kone project update-check"
  echo "  kone project update-check --history"
  echo "  kone project update-check --log --graph"
  echo "" 
}

show_history=false
show_log=false

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    update-check)
      ;;
    --graph)
      non_dynamic_params=" --graph"
      ;;
    --history)
      show_history=true
      ;;
    --log)
      show_log=true
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

if [ "${show_log}" = true ]; then
  # making things easier to read with prettyprint option and colors
  git log ${non_dynamic_params} --pretty=format:"%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %C(cyan)[%an]" --date=short --abbrev-commit
  exit 0
elif [ "${show_history}" = true ]; then
  git log --relative-date
  exit 0
fi

say "Checking for updates:"
echo "${magenta:-}Android Project${normal:-}"
git status -sb
echo "${magenta:-}Submodule Dependencies${normal:-}"
echo $( git submodule | awk '{ print $2 }' )
cd "android/React"
git status -sb

echo ""

# apply updates
while true; 
do
  read -p "Do you wish to apply updates? [Y]y [N]n: " yn
  case $yn in
    [Yy]* ) 
      "${ROOT_DIR}/command/project/update-project.sh"
      break
      ;;
    [Nn]* ) 
      say "${BACKGROUND_GREEN}Success${BACKGROUND_NORMAL} Done.\nTo apply updates, run: '${yellow:-}kone app update-project${normal:-}'"
      exit 0
      ;;
    * ) 
      say_err "Please answer yes or no."
      ;;
  esac
done
exit 0