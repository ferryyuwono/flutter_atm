#!/usr/bin/env bash

escapedPath="$(echo `pwd` | sed 's/\//\\\//g')"

if grep flutter pubspec.yaml > /dev/null; then
  if [ -d "coverage" ]; then
    # combine line coverage info from package tests to a common file
    if [ ! -d "$MELOS_ROOT_PATH/coverage_report" ]; then
      mkdir "$MELOS_ROOT_PATH/coverage_report"
    fi
    lcov --remove coverage/lcov.info '*.g.dart' '*.config.dart' '*.gr.dart' -o coverage/new_lcov.info
    sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/new_lcov.info >> "$MELOS_ROOT_PATH/coverage_report/lcov.info"
    rm -rf "coverage"
  fi
fi