//
//  ModeType.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBUtilities

/// iOS app mode type. Dark/Light/System with default value as system.
enum ModeType: String, Codable, ModeTypeProtocol {
  /// default mode
  static func defaultValue() -> ModeTypeProtocol {
    ModeType.system
  }

  case system
  case dark
  case light

  /// Factory type for selected app mode.
  func factoryType() -> ColorThemeFactoryProtocol.Type {
    switch self {
    case .dark:
      return DarkColorThemeFactory.self
    case .light:
      return LightColorThemeFactory.self
    case .system:
      switch UIScreen.main.traitCollection.userInterfaceStyle {
      case .dark:
        return DarkColorThemeFactory.self
      case .light, .unspecified:
        return LightColorThemeFactory.self
      @unknown default:
        return LightColorThemeFactory.self
      }
    }
  }

  func isEqual(_ other: ModeTypeProtocol) -> Bool {
    guard let other = other as? ModeType else {
      return false
    }

    return self == other
  }
}
