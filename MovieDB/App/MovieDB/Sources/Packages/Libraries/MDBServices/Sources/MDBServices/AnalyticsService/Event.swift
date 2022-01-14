//
//  Event.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public struct Event: EventProtocol {
  public let action: ActionProtocol
  public let screen: String
  public let path: String

  public init(action: ActionProtocol, screen: String, path: String) {
    self.action = action
    self.screen = screen
    self.path = path
  }
}
