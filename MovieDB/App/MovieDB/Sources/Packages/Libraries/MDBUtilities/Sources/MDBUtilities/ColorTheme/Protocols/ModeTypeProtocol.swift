//
//  ThemeTypeProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// @mockable
public protocol ModeTypeProtocol {
  func factoryType() -> ColorThemeFactoryProtocol.Type
  func isEqual(_ other: ModeTypeProtocol) -> Bool
}
