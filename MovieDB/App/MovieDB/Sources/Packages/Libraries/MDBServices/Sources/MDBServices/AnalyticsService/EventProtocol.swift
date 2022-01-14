//
//  EventProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol EventProtocol {
  var action: ActionProtocol { get }
  var screen: String { get }
  var path: String { get }
}
