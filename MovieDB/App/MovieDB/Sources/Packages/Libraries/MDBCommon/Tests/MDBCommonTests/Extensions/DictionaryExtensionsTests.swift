//
//  DictionaryExtensionsTests.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import MDBCommon
import UIKit
import XCTest

final class DictionaryExtensionsTests: XCTestCase {
  func testCustomPlusOperatorAllUnique() {
    let testLeftDictionary = [0: 0, 2: 2]
    let testRightDictionary = [1: 1]
    let result = testLeftDictionary + testRightDictionary

    XCTAssertEqual(result.count, 3)
  }

  func testCustomPlusOperatorPartiallyUnique() {
    let testLeftDictionary = [0: 0, 1: 1]
    let testRightDictionary = [1: 3]
    let result = testLeftDictionary + testRightDictionary

    XCTAssertEqual(result.count, 2)
    XCTAssertEqual(result[1], 3)
  }

  func testCustomPlusEqualOperatorAllUnique() {
    var testLeftDictionary = [0: 0]
    let testRightDictionary = [1: 1]
    testLeftDictionary += testRightDictionary

    XCTAssertEqual(testLeftDictionary.count, 2)
  }

  func testCustomPlusEqualOperatorPartiallyUnique() {
    var testLeftDictionary = [0: 0, 1: 1]
    let testRightDictionary = [1: 3]
    testLeftDictionary += testRightDictionary

    XCTAssertEqual(testLeftDictionary.count, 2)
    XCTAssertEqual(testLeftDictionary[1], 3)
  }

  static var allTests = [
    ("testCustomPlusEqualOperator", testCustomPlusOperatorAllUnique)
  ]
}
