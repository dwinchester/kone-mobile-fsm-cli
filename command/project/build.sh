#!/bin/sh

set -e
. "${ROOT_DIR}/utils/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone project build [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                        Show command line help." 
  echo "  --build-type <BUILD_TYPE>         The version of the app that you want to build. Available options are 'qa' or 'production'."
  echo "  --copy-to <COPY_TO_DIRECTORY>     Specifies the path for the output directory."
  echo "  --no-dependencies                 Doesn't reinstall project dependencies when running the command."
  echo "  --refresh-dependencies            Execute an implicit gradle dependencies refresh when running the command."
  echo "  --stacktrace                      Show truncated stacktraces from the configured build task." 
  echo ""
  echo "Examples:"
  echo "  kone project build"  
  echo "  kone project build --no-dependencies" 
  echo "  kone project build --stacktrace"      
  echo "  kone project build --build-type assembleDebug"
  echo ""
}

build="${BUILD_TYPE}"
no_dependencies=false
non_dynamic_params=""
copy_to=""

while [ $# -ne 0 ]
do
  key="${1}" 
  case "${key}" in
    -h|--help|help)
      show_help
      exit 3
      ;;
    build)
      ;;
    --build-type)
      shift
      build=="${1}"
      ;;  
    --copy-to)
      shift
      copy_to="${1}"
      ;;     
    --no-dependencies)
      no_dependencies=true
      ;;  
    --stacktrace)
      non_dynamic_params+=" --stacktrace"
      ;;
    --refresh-dependencies)
      non_dynamic_params+=" --refresh-dependencies"
      ;;
    *)
      say_err "$(unknown_command_message "${key}")"
      exit 3
      ;;
  esac
  shift
done

# bundles the react-native dependencies for offline use
if [ "${no_dependencies}" != true ]; then
  ( exec "${ROOT_DIR}/command/project/bundle.sh" "--reinstall" "--update-apply" )
fi

gradlew_path="$(combine_paths $(get_project_path) "/android/FieldService-Android")"
cd "${gradlew_path}"

./gradlew clean assembleRelease ${non_dynamic_params}

output_dir="android/FieldService-Android/FieldService-App/build/outputs/apk/${build}/release"
apk_path="$(combine_paths $(get_project_path) ${output_dir})"

cp -R "${apk_path}"/. "${copy_to}"

exit 0