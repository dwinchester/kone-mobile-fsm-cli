#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

gradlew_path="$(combine_paths $(get_project_path) "/android/FieldService-Android")"
cd "${gradlew_path}"

./gradlew clean
exit 0