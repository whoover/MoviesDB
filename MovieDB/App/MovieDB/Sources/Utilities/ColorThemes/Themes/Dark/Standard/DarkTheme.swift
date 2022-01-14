//
//  DarkTheme.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBUtilities

/// Standard dark theme
struct DarkTheme: ThemeProtocol {
  let images: ImagesThemeProtocol = DarkImages()
  let colors: ColorsThemeProtocol = DarkColors()
}
