//
//  Theme.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBUtilities

/// Standard light theme
struct LightTheme: ThemeProtocol {
  let images: ImagesThemeProtocol = LightImages()
  let colors: ColorsThemeProtocol = LightColors()
}
