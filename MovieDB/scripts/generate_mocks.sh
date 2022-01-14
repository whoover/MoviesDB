#!/bin/sh

declare -a libs_arr=("MDBCommon" "MDBCommonUI" "MDBNetworking" "MDBDataLayer" "MDBModels" "MDBUtilities" "MDBServices")
declare -a modules_arr=("MDBMain")


# mockolo
/usr/bin/xcrun --sdk macosx swift run --package-path "./../BuildTools/" mockolo -s "$PROJECT_DIR/MovieDB/Sources/App/" -s "$PROJECT_DIR/MovieDB/Sources/Utilities/" -d "$PROJECT_DIR/Tests/MovieDBTests/Mocks/MockoloMocks.swift"

for i in "${libs_arr[@]}"; do
	/usr/bin/xcrun --sdk macosx swift run --package-path "./../BuildTools/" mockolo -s "$PROJECT_DIR/MovieDB/Sources/Packages/Libraries/$i" -d "$PROJECT_DIR/MovieDB/Sources/Packages/Libraries/$i/Tests/${i}Mocks/MockoloMocks.swift" -i $i
done

for i in "${modules_arr[@]}"; do
	/usr/bin/xcrun --sdk macosx swift run --package-path "./../BuildTools/" mockolo -s "$PROJECT_DIR/MovieDB/Sources/Packages/Modules/$i" -d "$PROJECT_DIR/MovieDB/Sources/Packages/Modules/$i/Tests/${i}Mocks/MockoloMocks.swift" -i $i
done
