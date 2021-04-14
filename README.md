# buildifier

GitHub Workflow Action to run buildifier on bazel files

Optional Inputs:
* filetypes: bazel filetypes to search for. Defaults to all files.
* excludes: filter to pass to find via '-not -path' to exclude paths.
* warnings: filter of warnings to add or exclude to buildifier.

By default, buildifier excludes some warnings, so use `warnings: all` to include
all warnings.

## Examples

Simple example, use all buildifier warnings

```ylm
uses: thompsonja/bazel-buildifier@v0.3.0
with:
  warnings: all
```

Exclude third\_party BUILD files

```ylm
uses: thompsonja/bazel-buildifier@v0.3.0
with:
  excludes: ./third_party/*
```

Only consider BUILD and .bzl files

```ylm
uses: thompsonja/bazel-buildifier@v0.3.0
with:
  filetypes: BUILD,bzl
```
