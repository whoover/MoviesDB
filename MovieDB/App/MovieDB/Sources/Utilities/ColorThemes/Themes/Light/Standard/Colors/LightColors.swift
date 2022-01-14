//
//  LightColors.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBUtilities

/// Standard light theme colors
struct LightColors: ColorsThemeProtocol {
  let main: MainColorsThemeProtocol = LightMainColors()
  let components: ComponentsColorsThemeProtocol = LightComponents()
}
