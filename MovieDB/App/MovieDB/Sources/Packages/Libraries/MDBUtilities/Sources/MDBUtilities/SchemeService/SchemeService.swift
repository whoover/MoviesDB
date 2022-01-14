//
//  ShemeService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public enum AppScheme: String, CaseIterable {
  case release
  case debug
  case uiTests
}

/// @mockable
public protocol SchemeServiceProtocol {
  var currentScheme: AppScheme { get set }
}

public struct SchemeService: SchemeServiceProtocol {
  public init() {}

  public var currentScheme: AppScheme = .release
}
