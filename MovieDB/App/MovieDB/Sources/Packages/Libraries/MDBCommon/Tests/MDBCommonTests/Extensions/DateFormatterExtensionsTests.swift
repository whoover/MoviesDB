//
//  DateFormatterExtensionsTests.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import MDBCommon
@testable import MDBCommonMocks
import UIKit
import XCTest

final class DateFormatterExtensionsTests: XCTestCase {
  var testDateFormatterLocator = DateFormatterLocatorProtocolMock()
  var testDateFormatter = DateFormatter()

  override func setUp() {
    super.setUp()
    testDateFormatterLocator.dateFormatterHandler = { [unowned self] in self.testDateFormatter
    }
  }

  func testIsUses24HourTimePositive() {
    testDateFormatter.dateFormat = "HH:mm"
    XCTAssertTrue(DateFormatter.isUses24HourTime(testDateFormatterLocator))
  }

  func testIsUses24HourTimeNegative() {
    testDateFormatter.dateFormat = "h:mm a"
    XCTAssertFalse(DateFormatter.isUses24HourTime(testDateFormatterLocator))
  }

  static var allTests = [
    ("testIsUses24HourTimePositive", testIsUses24HourTimePositive)
  ]
}
