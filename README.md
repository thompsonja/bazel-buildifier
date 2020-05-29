# cpplint

GitHub Workflow Action to run buildifier on bazel files

Optional Inputs:
* filetypes: bazel filetypes to search for. Defaults to all files.
* excludes: filter to pass to find via '-not -path' to exclude paths.
* warnings: filter of warnings to add or exclude to buildifier.

By default, buildifier excludes some warnings, so use `warnings: all` to include
all warnings.

The buildifier tool also does some basic autoformatting which is not surfaced as
a lint warning. Therefore this action does not currently fail if this
autoformatting occurs.

## Examples

Simple example, use all buildifier warnings

```ylm
uses: thompsonja/bazel-buildifier@0.1.0
with:
  warnings: all
```

Exclude third\_party BUILD files

```ylm
uses: thompsonja/bazel-buildifier@0.1.0
with:
  excludes: third_party/*
```

Only consider BUILD and .bzl files

```ylm
uses: thompsonja/bazel-buildifier@0.1.0
with:
  filetypes: BUILD,bzl
```
