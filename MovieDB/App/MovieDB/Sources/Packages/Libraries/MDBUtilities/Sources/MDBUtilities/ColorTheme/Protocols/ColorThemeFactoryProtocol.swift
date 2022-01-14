//
//  ColorThemeFactoryProtocol.swift
//  MDBCommonUI
//
//

import UIKit

public protocol ColorThemeFactoryProtocol {
  static func create(_ color: ColorTypeProtocol) -> ThemeProtocol
}
