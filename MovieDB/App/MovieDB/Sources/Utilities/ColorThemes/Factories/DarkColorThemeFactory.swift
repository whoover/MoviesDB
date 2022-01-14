//
//  DarkColorThemeFactory.swift
//  MDBCommonUI
//
//

import MDBUtilities
import UIKit

/// Dark color theme factroy
class DarkColorThemeFactory: ColorThemeFactoryProtocol {
  static func create(_ color: ColorTypeProtocol) -> ThemeProtocol {
    switch color {
    case let color as ColorType:
      return color.darkColorTheme()
    default:
      return ColorType.standard.darkColorTheme()
    }
  }
}
