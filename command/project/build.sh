#!/bin/sh

set -e
. "${ROOT_DIR}/utils.sh"

show_help() {
  echo ""
  echo "Usage: kone project build [options]"
  echo ""
  echo "Options:"
  echo "  -h, --help                      Show command line help." 
  echo "  --build-type <BUILD_TYPE>       The version of the app that you want to build."
  echo "  --no-dependencies               Doesn't reinstall project dependencies when running the command."
  echo "  --output <OUTPUT_DIRECTORY>     Specifies the path for the output directory."
  echo "  --refresh-dependencies          Execute an implicit gradle dependencies refresh when running the command."
  echo "  --stacktrace                    Show truncated stacktraces from the configured build task." 
  echo ""
  echo "Examples:"
  echo "  kone project build"  
  echo "  kone project build --no-dependencies" 
  echo "  kone project build --stacktrace"      
  echo "  kone project build --build-type assembleDebug"
  echo ""
}

build_type="${BUILD_TYPE}"
no_dependencies=false
non_dynamic_params=""
output=""

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
      build_type=="${1}"
      ;;   
    --no-dependencies)
      no_dependencies=true
      ;;  
    --output)
      shift
      output="${1}"
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

# # bundles the react-native dependencies for offline use
# if [ "${no_dependencies}" != true ]; then
#   ( exec "${ROOT_DIR}/command/dev/bundle.sh" "--reinstall" "--update-apply" )
# fi

# gradlew_path="$(combine_paths $(get_project_path) "/android/FieldService-Android")"
# cd "${gradlew_path}"

# ./gradlew clean ${build_type} ${non_dynamic_params}

# output_dir="android/FieldService-Android/FieldService-App/build/outputs/apk/qa/release"
# apk_path="$(combine_paths $(get_project_path) ${output_dir})"

cp -R "${apk_path}"/. "${output}"

exit 0