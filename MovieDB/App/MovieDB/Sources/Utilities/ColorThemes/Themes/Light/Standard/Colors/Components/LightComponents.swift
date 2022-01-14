//
//  LightComponents.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBUtilities
import UIKit

struct LightComponents: ComponentsColorsThemeProtocol {
  let button: ButtonColorsThemeProtocol = LightButton()
  let activityIndicator: ActivityIndicatorColorsThemeProtocol = LightActivityIndicator()
  let copyView: CopyViewColorsThemeProtocol = LightCopyView()
  let internetAlert: NetworkingAlertProtocol = LightNetworkingAlert()
}

struct LightButton: ButtonColorsThemeProtocol {
  let title = Asset.Colors.Light.white.color
  let background = Asset.Colors.Light.white.color
  let disabledTitle = Asset.Colors.Light.white.color
  let disabledBackground = Asset.Colors.Light.white.color
}

struct LightActivityIndicator: ActivityIndicatorColorsThemeProtocol {
  let background = Asset.Colors.Light.white.color
  let text = Asset.Colors.Light.white.color
}

struct LightCopyView: CopyViewColorsThemeProtocol {
  let background = Asset.Colors.Light.white.color
  let text = Asset.Colors.Light.white.color
}

struct LightNetworkingAlert: NetworkingAlertProtocol {
  let background = Asset.Colors.Light.white.color
  let text = Asset.Colors.Light.white.color
}
