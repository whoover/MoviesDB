#!/bin/sh
  
# needle
# not working currently as SwiftSyntax should be updated inside github repository
#export SOURCEKIT_LOGGING=0 && $PROJECT_DIR/../BuildTools/.build/checkouts/needle/Generator/bin/needle generate "$PROJECT_DIR/MovieDB/Resources/NeedleGenerated.swift" "$PROJECT_DIR/MovieDB/Sources" --header-doc "$PROJECT_DIR/../copyright_header.txt" --pluginized --exclude-suffixes Test

arch_name="$(uname -m)"
needle_path=needle

if [ "$(echo "$arch_name")" = "arm64" ]; then
  needle_path=/opt/homebrew/bin/needle
fi
  
if which $needle_path >/dev/null; then
  $needle_path generate "$PROJECT_DIR/MovieDB/Resources/NeedleGenerated.swift" "$PROJECT_DIR/MovieDB/Sources" --header-doc "$PROJECT_DIR/../copyright_header.txt"
else
  echo "warning: needle not installed, download from https://github.com/uber/needle"
fi