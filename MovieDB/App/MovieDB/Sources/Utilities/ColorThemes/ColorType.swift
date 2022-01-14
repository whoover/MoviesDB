//
//  ColorType.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBUtilities

/// MovieDB color types
enum ColorType: String, ColorTypeProtocol {
  case standard

  static func defaultValue() -> ColorTypeProtocol {
    ColorType.standard
  }

  func isEqual(_ other: ColorTypeProtocol) -> Bool {
    guard let other = other as? ColorType else {
      return false
    }

    return self == other
  }
}

/// Extension to get dark color theme for app's color
extension ColorType {
  func darkColorTheme() -> ThemeProtocol {
    switch self {
    case .standard:
      return DarkTheme()
    }
  }
}

/// Extension to get light color theme for app's color
extension ColorType {
  func lightColorTheme() -> ThemeProtocol {
    switch self {
    case .standard:
      return LightTheme()
    }
  }
}
