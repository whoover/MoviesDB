//
//  ComponentsColorsThemeProtocols.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import UIKit

public protocol ComponentsColorsThemeProtocol {
  var button: ButtonColorsThemeProtocol { get }
  var activityIndicator: ActivityIndicatorColorsThemeProtocol { get }
  var copyView: CopyViewColorsThemeProtocol { get }
  var internetAlert: NetworkingAlertProtocol { get }
}

/// @mockable
public protocol CopyViewColorsThemeProtocol {
  var background: UIColor { get }
  var text: UIColor { get }
}

/// @mockable
public protocol ButtonColorsThemeProtocol {
  var title: UIColor { get }
  var background: UIColor { get }
  var disabledTitle: UIColor { get }
  var disabledBackground: UIColor { get }
}

/// @mockable
public protocol ActivityIndicatorColorsThemeProtocol {
  var background: UIColor { get }
  var text: UIColor { get }
}

public protocol ServerUnavailableViewColorsThemeProtocol {
  var background: UIColor { get }
  var title: UIColor { get }
}

public protocol NetworkingAlertProtocol {
  var background: UIColor { get }
  var text: UIColor { get }
}
