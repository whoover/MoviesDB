//
//  Dictionary+Additions.swift
//  MDBCommon
//
//

/// Custom Dictionary methods
public extension Dictionary {
  /**
        Custom `+` operator which returns merging result of right dictionary to the left one.
        - Parameters:
           - left : dictionary to merge another one.
           - right : dictionary to merge in the left one.

        ### Usage Example: ###
        ````
        let newDict = [1: 1, 2: 2] + [1: 42, 3: 3]
        ````

        ### Expected result: ###
        ````
        [1: 42, 2: 2, 3: 3]
        ````
   */
  static func + (left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
    left.merging(right, uniquingKeysWith: { _, second in second })
  }

  /**
        Custom `+=` operator which merges right dict to the left one.
        - Parameters:
           - left : dictionary to merge another one.
           - right : dictionary to merge in the left one.

        ### Usage Example: ###
        ````
        var newDict = [1: 1, 2: 2]
        newDict += [1: 42, 3: 3]
        ````

        ### Expected result: ###
        ````
        [1: 42, 2: 2, 3: 3]
        ````
   */
  static func += (left: inout [Key: Value], right: [Key: Value]) {
    left.merge(right, uniquingKeysWith: { _, second in second })
  }
}
