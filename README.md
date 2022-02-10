# buildifier

GitHub Workflow Action to run buildifier on bazel files

Optional Inputs:
* filetypes: bazel filetypes to search for. Defaults to all files.
* excludes: filter to pass to find via '-not -path' to exclude paths.
* warnings: filter of warnings to add or exclude to buildifier.
* buildifier_version: version of buildifier to use (defaults to 4.0.1)

By default, buildifier excludes some warnings, so use `warnings: all` to include
all warnings.

## Examples

Simple example, use all buildifier warnings

```ylm
uses: thompsonja/bazel-buildifier@v0.4.0
with:
  warnings: all
```

Same, but with a different version of buildifier

```ylm
uses: thompsonja/bazel-buildifier@v0.4.0
with:
  warnings: all
  buildifier_version: 5.0.0
```

Exclude third\_party BUILD files

```ylm
uses: thompsonja/bazel-buildifier@v0.4.0
with:
  excludes: ./third_party/*
```

Only consider BUILD and .bzl files

```ylm
uses: thompsonja/bazel-buildifier@v0.4.0
with:
  filetypes: BUILD,bzl
```
