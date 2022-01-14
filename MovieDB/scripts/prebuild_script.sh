#!/bin/sh

#swiftgen
/usr/bin/xcrun --sdk macosx swift run --package-path "./../BuildTools/" swiftgen
#needle
$(dirname $0)/generate_needle_di.sh
# #mockolo
$(dirname $0)/generate_mocks.sh
