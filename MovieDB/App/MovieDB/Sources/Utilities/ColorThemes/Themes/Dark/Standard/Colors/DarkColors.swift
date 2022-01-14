//
//  DarkColors.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBUtilities

/// Standard dark theme colors
struct DarkColors: ColorsThemeProtocol {
  let main: MainColorsThemeProtocol = DarkMainColors()
  let components: ComponentsColorsThemeProtocol = DarkComponents()
}
