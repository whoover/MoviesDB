//
//  QueueTests.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import MDBCommon
import UIKit
import XCTest

final class QueueTests: XCTestCase {
  func testFifoQueue() {
    var queue = Queue<Int>(direction: .fifo)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.peek(), nil)

    queue.enqueue(0)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.peek(), 0)

    queue.enqueue(42)
    XCTAssertEqual(queue.peek(), 0)
    XCTAssertTrue(queue.contains(42))

    XCTAssertEqual(queue.dequeue(), 0)
    XCTAssertEqual(queue.dequeue(), 42)
    XCTAssertTrue(queue.isEmpty)
  }

  func testLifoQueue() {
    var queue = Queue<Int>(direction: .lifo)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.peek(), nil)

    queue.enqueue(0)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.peek(), 0)

    queue.enqueue(42)
    XCTAssertEqual(queue.peek(), 0)
    XCTAssertTrue(queue.contains(42))

    XCTAssertEqual(queue.dequeue(), 42)
    XCTAssertEqual(queue.dequeue(), 0)
    XCTAssertTrue(queue.isEmpty)
  }

  func testClearQueue() {
    var queue = Queue<Int>(direction: .lifo)
    XCTAssertTrue(queue.isEmpty)

    for i in 1 ... 10 {
      queue.enqueue(i)
    }
    XCTAssertFalse(queue.isEmpty)

    queue.clear()
    XCTAssertTrue(queue.isEmpty)
  }
}
