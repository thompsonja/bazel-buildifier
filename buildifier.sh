#!/bin/bash -eu

if [[ -z "${INPUT_FILETYPES:-""}" && -z "${INPUT_EXCLUDES:-""}" ]]; then
  buildifier --lint=warn -r .
  exit 0
fi

declare -a FILETYPES
IFS=',' read -r -a FILETYPES <<< \
  "${INPUT_FILETYPES:-"BUILD,bzl,sky,bzl,WORKSPACE,bazel"}"
readonly FILETYPES

declare FIND_NAME_ARGS
FIND_NAME_ARGS="$(printf -- "-iname %s -o " "${FILETYPES[@]}")"
# Remove the last ' -o ' 4 characters, they are only needed in between args
FIND_NAME_ARGS="${FIND_NAME_ARGS::-4}"
readonly FIND_NAME_ARGS

declare FIND_PATH_EXCLUDES
if [[ -n "${INPUT_EXCLUDES:-""}" ]]; then
  declare EXCLUDES=()
  IFS=',' read -r -a EXCLUDES <<< "${INPUT_EXCLUDES:-""}"
  readonly EXCLUDES

  FIND_PATH_EXCLUDES="$(printf -- "-not -path \"%s\" " "${EXCLUDES[@]}")"
fi
readonly FIND_PATH_EXCLUDES

declare -a BAZEL_FILES
BAZEL_FILES=($(find . -type f \( ${FIND_NAME_ARGS} \) ${FIND_PATH_EXCLUDES}))
readonly BAZEL_FILES

declare -a BUILDIFIER_ARGS=(
  "--lint=warn"
  "${BAZEL_FILES[@]}"
)
if [[ -n "${INPUT_WARNINGS:-""}" ]]; then
  BUILDIFIER_ARGS=("--warnings=${INPUT_WARNINGS}" "${BUILDIFIER_ARGS[@]}")
fi
readonly BUILDIFIER_ARGS

set -x
buildifier "${BUILDIFIER_ARGS[@]}"
