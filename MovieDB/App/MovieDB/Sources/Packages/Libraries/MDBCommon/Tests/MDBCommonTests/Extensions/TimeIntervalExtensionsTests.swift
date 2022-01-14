//
//  TimeIntervalExtensionsTests.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import MDBCommon
import UIKit
import XCTest

final class TimeIntervalExtensionsTests: XCTestCase {
  func testTimeIntervalToTurple() {
    let testTimeInterval: TimeInterval = 10000
    let result = testTimeInterval.secondsToHoursMinutesSeconds

    XCTAssertEqual(result.0, 2)
    XCTAssertEqual(result.1, 46)
    XCTAssertEqual(result.2, 40)
  }

  func testTimeIntervalToCustomString() {
    let result = TimeInterval.timeFormattedToHMS(10000)

    XCTAssertEqual(result, "02:46:40")
  }

  static var allTests = [
    ("testTimeIntervalToTurple", testTimeIntervalToTurple)
  ]
}
