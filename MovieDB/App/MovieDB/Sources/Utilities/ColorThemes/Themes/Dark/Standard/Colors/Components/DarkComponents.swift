//
//  DarkComponents.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBUtilities

struct DarkComponents: ComponentsColorsThemeProtocol {
  let button: ButtonColorsThemeProtocol = DarkButton()
  let activityIndicator: ActivityIndicatorColorsThemeProtocol = DarkActivityIndicator()
  let copyView: CopyViewColorsThemeProtocol = DarkCopyView()
  let internetAlert: NetworkingAlertProtocol = DarkNetworkingAlert()
}

struct DarkButton: ButtonColorsThemeProtocol {
  let title = Asset.Colors.Light.white.color
  let background = Asset.Colors.Light.white.color
  let disabledTitle = Asset.Colors.Light.white.color
  let disabledBackground = Asset.Colors.Light.white.color
}

struct DarkActivityIndicator: ActivityIndicatorColorsThemeProtocol {
  let background = Asset.Colors.Light.white.color
  let text = Asset.Colors.Light.white.color
}

struct DarkCopyView: CopyViewColorsThemeProtocol {
  let background = Asset.Colors.Light.white.color
  let text = Asset.Colors.Light.white.color
}

struct DarkNetworkingAlert: NetworkingAlertProtocol {
  let background = Asset.Colors.Light.white.color
  let text = Asset.Colors.Light.white.color
}
