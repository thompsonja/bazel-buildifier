#!/bin/bash

set -eu

# Install buildifier
if ! curl -f -L -o /usr/bin/buildifier \
  "https://github.com/bazelbuild/buildtools/releases/download/${INPUT_BUILDIFIER_VERSION}/buildifier-linux-amd64"; then
  echo "Could not download buildifier ${INPUT_BUILDIFIER_VERSION}"
  exit 1
fi
chmod +x /usr/bin/buildifier

buildifier --version

declare -a BUILDIFIER_ARGS=(
  "--lint=warn"
  "--mode=check"
)
if [[ -n "${INPUT_WARNINGS:-""}" ]]; then
  BUILDIFIER_ARGS+=("--warnings=${INPUT_WARNINGS}")
fi
readonly BUILDIFIER_ARGS

# If defaults are used for filetypes and excludes, just do a recursive check.
if [[ -z "${INPUT_FILETYPES:-""}" && -z "${INPUT_EXCLUDES:-""}" ]]; then
  set -x
  buildifier "${BUILDIFIER_ARGS[@]}" -r .
  exit 0
fi

declare -a FILETYPES
IFS=',' read -r -a FILETYPES <<< \
  "${INPUT_FILETYPES:-"BUILD,bzl,sky,bzl,WORKSPACE,bazel"}"
readonly FILETYPES

# Generate find args for filetypes using -iname
declare FIND_NAME_ARGS
FIND_NAME_ARGS="$(printf -- "-iname %s -o " "${FILETYPES[@]}")"
# Remove the last ' -o ' 4 characters, they are only needed in between args
FIND_NAME_ARGS="${FIND_NAME_ARGS::-4}"
readonly FIND_NAME_ARGS

# Generate find args for any path exclusions using '-not -path'
declare FIND_PATH_EXCLUDES
if [[ -n "${INPUT_EXCLUDES:-""}" ]]; then
  declare EXCLUDES=()
  IFS=',' read -r -a EXCLUDES <<< "${INPUT_EXCLUDES:-""}"
  readonly EXCLUDES

  FIND_PATH_EXCLUDES="$(printf -- "-not -path \"%s\" " "${EXCLUDES[@]}")"
fi
readonly FIND_PATH_EXCLUDES

# Construct our full find command to get the bazel files we want to pass to
# buildifier
declare -a BAZEL_FILES
BAZEL_FILES=(\
  $(eval "find . -type f \( ${FIND_NAME_ARGS} \) ${FIND_PATH_EXCLUDES}"))
readonly BAZEL_FILES

set -x
buildifier "${BUILDIFIER_ARGS[@]}" "${BAZEL_FILES[@]}"
set +x
echo "Success!"
