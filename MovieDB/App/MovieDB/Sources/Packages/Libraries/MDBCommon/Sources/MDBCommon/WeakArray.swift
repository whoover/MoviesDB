//
//  WeakArray.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public class WeakArray<Element: Any> {
  public private(set) var innerArray: [WeakContainer<Element>] = []

  public var count: Int {
    innerArray.count
  }

  public var isEmpty: Bool {
    innerArray.isEmpty
  }

  public var last: Element? {
    innerArray.last?.value
  }

  public init() {}

  public func append(_ object: Element) {
    reap()

    innerArray.append(WeakContainer(value: object))
  }

  public func remove(_ object: Element) {
    reap()

    let object = object as AnyObject
    let firstIndex = innerArray
      .map { $0.value as AnyObject }
      .firstIndex(where: { $0 === object })

    if let index = firstIndex {
      innerArray.remove(at: index)
    }
  }

  public func contains(where predicate: (Element) -> Bool) -> Bool {
    reap()

    return innerArray
      .compactMap(\.value)
      .contains(where: predicate)
  }

  public subscript(index: Int) -> Element? {
    innerArray[index].value
  }

  public func reap() {
    innerArray = innerArray.filter { $0.value != nil }
  }

  public func forEach(_ handler: (Element?) -> Void) {
    innerArray.forEach { handler($0.value) }
  }
}
