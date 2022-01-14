//
//  Lens.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public struct Lens<View, Projected> {
  public let get: (View) -> Projected
  public let set: (Projected, View) -> View

  public init(
    get: @escaping (View) -> Projected,
    set: @escaping (Projected, View) -> View
  ) {
    self.get = get
    self.set = set
  }
}
