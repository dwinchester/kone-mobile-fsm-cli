#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

# delete all the existing artifacts and metadata Gradle has previously downloaded
rm -rf "${HOME}"/.gradle/caches/

gradlew_path="$(combine_paths $(get_project_path) "/android/FieldService-Android")"
cd "${gradlew_path}"

./gradlew clean --refresh-dependencies
exit 0