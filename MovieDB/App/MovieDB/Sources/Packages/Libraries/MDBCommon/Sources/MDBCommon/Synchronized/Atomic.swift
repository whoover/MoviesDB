//
//  Atomic.swift
//  MDBCommon
//
//

import Foundation

/**
 A thread-safe property wrapper.

 ### Usage Example: ###
 ```
 @Atomic var atomicValue = 1
 atomicValue = 10 // atomic

 atomicValue += 1 // not atomic -> use projected value `$atomicValue` instead
 $atomicValue.mutate { $0 += 1 } // atomic

 @Atomic var atomicArray = [1, 2, 3]
 atomicArray[1] = 10 // not atomic
 $atomicArray.mutate { $0[1] = 10 } // atomic
 ```
 */
@propertyWrapper
public class Atomic<T> {
  public var projectedValue: Atomic<T> {
    self
  }

  public var wrappedValue: T {
    get {
      lockQueue.sync(flags: .barrier) { value }
    }
    set {
      lockQueue.sync(flags: .barrier) { value = newValue }
    }
  }

  // Atomic core
  private var value: T
  private let lockQueue: DispatchQueue = {
    let separator = "_"
    let name = ["AtomicProperty", UUID().uuidString, String(describing: T.self)]
      .joined(separator: separator)
    return DispatchQueue(label: name)
  }()

  public init(wrappedValue: T) {
    value = wrappedValue
  }

  public func mutate(_ mutation: (inout T) -> Void) {
    lockQueue.sync(flags: .barrier) {
      mutation(&value)
    }
  }
}
