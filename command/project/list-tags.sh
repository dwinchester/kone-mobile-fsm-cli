#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

project_path="$(get_project_path)"
cd "${project_path}"

arg_start=1
pattern="$((arg_start+1))"

# list  all tags. Running the command `git tag` implicitly assumes you want 
# a listing. If, however, a wildcard pattern is provided to match tag names, 
# the use of -l or --list is mandatory
git tag -l 