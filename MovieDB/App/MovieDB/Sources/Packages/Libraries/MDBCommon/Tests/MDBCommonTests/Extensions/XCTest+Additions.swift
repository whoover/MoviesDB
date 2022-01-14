//
//  XCTest+Additions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import XCTest

extension XCTest {
  func expectToEventually(
    _ isFulfilled: @autoclosure () -> Bool,
    timeout: TimeInterval,
    message: String = "",
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    func wait() { RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01)) }

    let timeout = Date(timeIntervalSinceNow: timeout)
    func isTimeout() -> Bool { Date() >= timeout }

    repeat {
      if isFulfilled() { return }
      wait()
    } while !isTimeout()

    XCTFail(message, file: file, line: line)
  }
}
