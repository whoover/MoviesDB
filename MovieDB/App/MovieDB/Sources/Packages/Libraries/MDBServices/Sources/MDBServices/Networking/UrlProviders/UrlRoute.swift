//
//  UrlRoute.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public enum UrlRoute {
  case mobile
  case common
  case custom(String)

  public func stringRepresentation() -> String {
    switch self {
    case .mobile:
      return ""
    case .common:
      return "common"
    case let .custom(string):
      return string
    }
  }
}
