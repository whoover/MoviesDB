//
//  ArrayExtensionsTests.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import MDBCommon
import XCTest

final class ArrayExtensionsTests: XCTestCase {
  // MARK: - for each modifiable tests

  func testForEachModifiable() {
    var testArray = [1, 2, 3, 4, 5]
    testArray.forEachModifiable { element in
      element += 1
    }

    XCTAssertEqual(testArray, [2, 3, 4, 5, 6])
  }

  // MARK: - type filter tests

  func testTypeFilterWithNeededValues() {
    let testArray: [Any] = [1, 2, "42", 4, "SomeTest"]
    let result: [String] = testArray.filter()

    XCTAssertEqual(result, ["42", "SomeTest"])
  }

  func testTypeFilterWithoutNeededValues() {
    let testArray: [Any] = [1, 2, 3, 4]
    let result: [String] = testArray.filter()

    XCTAssertEqual(result, [])
  }

  func testTypeFilterEmpty() {
    let testArray: [Any] = []
    let result: [String] = testArray.filter()

    XCTAssertEqual(result, [])
  }

  // MARK: - type indexes tests

  func testTypeIndexesWithNeededValues() {
    let testArray: [Any] = [0, "42", 1, "43", 2]
    let result = testArray.indexes(type: Int.self)

    XCTAssertEqual(result, [0, 2, 4])
  }

  func testTypeIndexesWithoutNeededValues() {
    let testArray: [Any] = ["42", "43"]
    let result = testArray.indexes(type: Int.self)

    XCTAssertEqual(result, [])
  }

  // MARK: - unique tests

  func testAllUniqueValues() {
    let testArray = [0, 1, 2, 3, 4]
    let result = testArray.unique()

    XCTAssertEqual(result.count, testArray.count)
  }

  func testPartiallyUniqueValues() {
    let testArray = [0, 1, 2, 2, 0]
    let result = testArray.unique()

    XCTAssertEqual(result.count, 3)
  }

  func testNoUniqueValues() {
    let testArray = [0, 0, 0, 0, 0]
    let result = testArray.unique()

    XCTAssertEqual(result.count, 1)
  }

  // MARK: - all true tests

  func testAllTrueValues() {
    let testArray: [Bool] = [true, true, true, true, true]
    XCTAssertEqual(testArray.allTrue, true)
  }

  func testPartiallyTrueValues() {
    let testArray: [Bool] = [true, true, false, true, true]
    XCTAssertEqual(testArray.allTrue, false)
  }

  func testAllFalseValues() {
    let testArray: [Bool] = [false, false, false, false, false]
    XCTAssertEqual(testArray.allTrue, false)
  }

  // MARK: - make by deleting tests

  func testMakeByDeletingObject() {
    let testArray: [Int] = [0, 1, 2, 3, 4]
    let result = testArray.makeByDeleting(object: 2)
    XCTAssertEqual(result, [0, 1, 3, 4])
  }

  func testMakeByDeletingAtIndex() {
    let testArray: [Int] = [0, 1, 2, 3, 4]
    let result = testArray.makeByDeleting(objectAtIndex: 0)
    XCTAssertEqual(result, [1, 2, 3, 4])
  }

  // MARK: - make by deleting NSArray tests

  func testMakeByDeletingNSArrayObject() {
    let testArray: NSArray = [0, 1, 2, 3, 4]
    let result = testArray.makeByDeleting(object: 2)
    XCTAssertEqual(result, [0, 1, 3, 4])
  }

  func testMakeByDeletingNSArrayAtIndex() {
    let testArray: NSArray = [0, 1, 2, 3, 4]
    let result = testArray.makeByDeleting(objectAtIndex: 0)
    XCTAssertEqual(result, [1, 2, 3, 4])
  }

  static var allTests = [
    ("testForEachModifiable", testForEachModifiable)
  ]
}
