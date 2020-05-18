#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

gradlew_path="$(combine_paths $(get_project_path) "/android/FieldService-Android")"
cd "${gradlew_path}"

./gradlew clean assembleRelease --stacktrace
exit 0