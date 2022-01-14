//
//  SynchronizedDictionary.swift
//  MDBCommon
//
//

/// Class does not fully cover all Dictionary func-s. Add if needed
public class SynchronizedDictionary<Key: Hashable, Value: Any> {
  private let queue = DispatchQueue(label: "com.SynchronizedDictionary", attributes: .concurrent)
  private var dict = [Key: Value]()

  public init() {}

  public convenience init(_ dictionary: [Key: Value]) {
    self.init()
    dict = dictionary
  }

  public var dictionary: [Key: Value] {
    var dictCopy = [Key: Value]()
    queue.sync { dictCopy = self.dict }
    return dictCopy
  }
}

// MARK: - Properties

public extension SynchronizedDictionary {
  /// The first element of the collection.
  var first: (key: Key, value: Value)? {
    var result: (key: Key, value: Value)?
    queue.sync { result = self.dict.first }
    return result
  }

  /// The number of elements in the dict.
  var count: Int {
    var result = 0
    queue.sync { result = self.dict.count }
    return result
  }

  /// A Boolean value indicating whether the collection is empty.
  var isEmpty: Bool {
    var result = false
    queue.sync { result = self.dict.isEmpty }
    return result
  }

  /// A textual representation of the dict and its elements.
  var description: String {
    var result = ""
    queue.sync { result = self.dict.description }
    return result
  }
}

// MARK: - Mutable

public extension SynchronizedDictionary {
  /// Adds a new element at the end of the dict.
  func updateValue(_ value: Value, forKey key: Key) {
    queue.async(flags: .barrier) {
      self.dict.updateValue(value, forKey: key)
    }
  }

  func removeValue(forKey key: Key) {
    queue.async(flags: .barrier) {
      self.dict.removeValue(forKey: key)
    }
  }

  /// Removes all elements from the dict.
  func removeAll(keepingCapacity keepCapacity: Bool = false) {
    queue.async(flags: .barrier) {
      self.dict.removeAll(keepingCapacity: keepCapacity)
    }
  }

  func merge(other: [Key: Value], uniquingKeysWith: @escaping (Value, Value) throws -> Value) {
    queue.async(flags: .barrier) {
      try? self.dict.merge(other, uniquingKeysWith: uniquingKeysWith)
    }
  }
}

public extension SynchronizedDictionary {
  subscript(key: Key) -> Value? {
    get {
      var result: Value?
      queue.sync {
        result = self.dict[key]
      }
      return result
    }
    set {
      guard let newValue = newValue else {
        return
      }
      queue.async(flags: .barrier) {
        self.dict[key] = newValue
      }
    }
  }
}
