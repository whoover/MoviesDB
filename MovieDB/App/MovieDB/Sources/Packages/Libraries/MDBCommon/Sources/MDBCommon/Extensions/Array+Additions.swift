//
//  Array+Modify.swift
//  MDBCommon
//
//

/// Custom array methods
public extension Array {
  /**
        Call this function for using forEach with objects modify possibility.
        - Parameters:
           - block : closure that called with each array's element.

        ### Usage Example: ###
        ````
        [1, 2, 3].forEachModifiable { element in
          ...
        }
        ````
   */
  mutating func forEachModifiable(_ block: (_ element: inout Element) -> Void) {
    guard !isEmpty else {
      return
    }
    for index in 0 ..< count {
      block(&self[index])
    }
  }

  /**
        This function is for filtering array with specific type.

        ### Usage Example: ###
        ````
        let filteredArray: [String] = [1, 2, 3, "someString"].filter()

        ````

        ### Expected Result: ###
        ````
        ["someString"]

        ````
   */
  func filter<T: Any>() -> [T] {
    filter { $0 is T } as? [T] ?? []
  }

  /**
        This function will return indexes array of values of specific type.
        - Parameters:
           - type : type of values, which indexes you want to obtain.

        ### Usage Example: ###
        ````
        let ourIndexes: [Int] = [1, 2, 3, "someString"].filter()
        ````
        ### Expected Result: ###
        ````
        [0, 1, 2]

        ````
   */
  func indexes<T: Any>(type _: T.Type) -> [Int] {
    enumerated().reduce([]) { $1.element is T ? $0 + [$1.offset] : $0 }
  }
}

// MARK: - Custom array methods with hashable elements

public extension Array where Element: Hashable {
  /**
        This function will return unique values inside array by hash.

        ### Usage Example: ###
        ````
        let uniqueValues: [Int] = [1, 2, 3, 3, 2].unique()
        ````
        ### Expected Result (won't be sorted): ###
        ````
        [1, 2, 3]

        ````
   */
  func unique() -> [Element] {
    Array(Set(self))
  }
}

// MARK: - Custom array methods with bool elements

public extension Array where Element == Bool {
  /// Indicates if all bool values inside array are `true`.
  var allTrue: Bool {
    !isEmpty && !contains(false)
  }
}

// MARK: - Extension for making new Array from existing one

public extension Array where Element: Equatable {
  /**
        This function will make new array by deleting specified element.
        - Parameters:
           - object : element you want to remove from array.

        ### Usage Example: ###
        ````
        let newArray: [Int] = [1, 2, 3].makeByDeleting(object: 3)
        ````
        ### Expected Result (won't be sorted): ###
        ````
        [1, 2]

        ````
   */
  func makeByDeleting(object: Element) -> [Element] {
    var result = self
    if let index = firstIndex(of: object) {
      result.remove(at: index)
    }
    return result
  }

  /**
        This function will make new array by deleting element at index.
        - Parameters:
           - index : index of element you want to remove from array.

        ### Usage Example: ###
        ````
        let newArray: [Int] = [1, 2, 3].makeByDeleting(objectAtIndex: 0)
        ````
        ### Expected Result (same sorting not guaranted): ###
        ````
        [2, 3]

        ````
   */
  func makeByDeleting(objectAtIndex index: Int) -> [Element] {
    guard index < count else {
      return self
    }
    var result = self
    result.remove(at: index)
    return result
  }
}

// MARK: - Extension for making new NSArray from existing one

@objc public extension NSArray {
  /**
        This function will make new array by deleting specified element.
        - Parameters:
           - object : element you want to remove from array.

        ### Usage Example: ###
        ````
        let newArray: [Int] = [1, 2, 3].makeByDeleting(object: 3)
        ````
        ### Expected Result (will stay originally sorted): ###
        ````
        [1, 2]

        ````
   */
  func makeByDeleting(object: Any) -> NSArray {
    let mutableCopy = NSMutableArray(array: self)
    mutableCopy.remove(object)
    return mutableCopy
  }

  /**
        This function will make new array by deleting element at index.
        - Parameters:
           - index : index of element you want to remove from array.

        ### Usage Example: ###
        ````
        let newArray: [Int] = [1, 2, 3].makeByDeleting(objectAtIndex: 0)
        ````
        ### Expected Result (won't be sorted): ###
        ````
        [2, 3]

        ````
   */
  func makeByDeleting(objectAtIndex index: Int) -> NSArray {
    guard index < count else {
      return self
    }
    let mutableCopy = NSMutableArray(array: self)
    mutableCopy.removeObject(at: index)
    return mutableCopy
  }
}
