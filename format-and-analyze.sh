#!/bin/bash

# Format the codebase. Use 80 characters to match the formatting check we get
# "for free" from the Very Good CLI boilerplate.
echo "Formatting..."
dart format . -l 120 --set-exit-if-changed

# Analyze the codebase
echo "Analyzing codebase..."
flutter analyze . --congratulate --fatal-warnings

echo "Formatting and analysis complete."
