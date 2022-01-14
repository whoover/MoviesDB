//
//  InfoAction.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public struct InfoAction: ActionProtocol {
  public let type: String
  public let name: String
  public let value: ActionValueProtocol

  public init(type: String, name: String, value: ActionValueProtocol) {
    self.type = type
    self.name = name
    self.value = value
  }
}
