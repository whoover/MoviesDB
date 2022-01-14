#!/bin/sh

# swiftformat
/usr/bin/xcrun --sdk macosx swift run --package-path "./../BuildTools/" swiftformat --config ./../.swiftformat "./../App"

# swiftlint
/usr/bin/xcrun --sdk macosx swift run --package-path "./../BuildTools/" swiftlint --config ./../.swiftlint.yml
