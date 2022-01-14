//
//  ButtonAction.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public struct ButtonAction: ActionProtocol {
  public let type: String
  public let name: String

  public init(type: String, name: String) {
    self.type = type
    self.name = name
  }
}
