//
//  LightColorThemeFactory.swift
//  MDBCommonUI
//
//

import MDBUtilities
import UIKit

/// Light color theme factroy
class LightColorThemeFactory: ColorThemeFactoryProtocol {
  static func create(_ color: ColorTypeProtocol) -> ThemeProtocol {
    switch color {
    case let color as ColorType:
      return color.lightColorTheme()
    default:
      return ColorType.standard.lightColorTheme()
    }
  }
}
