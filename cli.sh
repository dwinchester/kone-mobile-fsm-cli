#!/bin/sh

# Stop script on NZEC
set -e

# standard output may be used as a return value in the functions
# we need a way to write text on the screen in the functions so that
# it won't interfere with the return value.
# Exposing stream 3 as a pipe to standard output of the script itself
exec 3>&1

export ROOT_DIR=$(cd $(dirname ${0}) && pwd)

# shellcheck external sources
. "${ROOT_DIR}/utils/utils.sh"

# run the CLI entrypoint
cli_entrypoint "$@"