#!/bin/sh

set -e

cd "${ANDROID_HOME}/platform-tools"

${ROOT_DIR}/coloredlogcat.py

exit 0
