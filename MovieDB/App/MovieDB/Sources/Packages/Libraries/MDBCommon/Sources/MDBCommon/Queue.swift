//
//  Queue.swift
//  MDBCommon
//
//

/// Queue data structure  implementation
public struct Queue<T: Equatable> {
  /// Direction of dequeuing.
  public enum Direction {
    case fifo
    case lifo
  }

  private var array: [T] = []
  private(set) var direction: Direction

  /// Indicates if queue is empty
  public var isEmpty: Bool {
    array.isEmpty
  }

  /**
         Init with`Direction`.
         - Parameters:
            - direction : `lifo`/`fifo` direction of dequeuing.
   */
  public init(direction: Direction = .fifo) {
    self.direction = direction
  }

  /// Indicates if queue contains element.
  public func contains(_ element: T) -> Bool {
    array.contains(element)
  }

  /// Enqueue new element to queue.
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  /// Dequeue element from queue, depending on direction (first if fifo, last if lifo).
  public mutating func dequeue() -> T? {
    guard !isEmpty else {
      return nil
    }

    switch direction {
    case .fifo:
      let first = array.first
      array.removeFirst()

      return first
    case .lifo:
      let last = array.last
      array.removeLast()

      return last
    }
  }

  /// Returns the head of queue. Returns nil if empty.
  public func peek() -> T? {
    array.first
  }

  /// Removes all elements from queue.
  public mutating func clear() {
    array.removeAll()
  }
}

extension Queue: CustomStringConvertible {
  public var description: String {
    array.description
  }
}
