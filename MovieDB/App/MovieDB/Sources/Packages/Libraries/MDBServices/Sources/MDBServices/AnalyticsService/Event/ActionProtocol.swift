//
//  ActionProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol ActionProtocol {
  var type: String { get }
  var name: String { get }
}
