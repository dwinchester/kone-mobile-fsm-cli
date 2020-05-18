#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

react_path="$(combine_paths $(get_project_path) "/android/React")"
cd "${react_path}"

# bundle for offline use
react-native bundle \
    --platform android \
    --dev false \
    --entry-file kone.android.js \
    --bundle-output ../FieldService-Android/FieldService-App/src/main/assets/kone.android.bundle \
    --assets-dest ../FieldService-Android/FieldService-App/src/main/res/

exit 0