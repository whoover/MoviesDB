//
//  ActivityIndicatorSwiftUIRoutable.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBUtilities
import SwiftUI

public struct ActivityIndicatorSwiftUIModel {
  public let loadingText: String
  public let animationDelay: TimeInterval
  public let dismissDelay: TimeInterval
  public let colors: ActivityIndicatorColorsThemeProtocol?

  public init(
    loadingText: String,
    animationDelay: TimeInterval,
    dismissDelay: TimeInterval,
    colors: ActivityIndicatorColorsThemeProtocol?
  ) {
    self.loadingText = loadingText
    self.animationDelay = animationDelay
    self.dismissDelay = dismissDelay
    self.colors = colors
  }
}

public protocol ActivityIndicatorSwiftUIRoutable {
  /// Method creating and setuping.
  ///
  /// - Parameters:
  ///   - loadingText: ActivityIndicator's on loading text;
  ///   - animationDelay: `TimeInterval` delay with which the Activity Indicator is displayed;
  ///   - dismissDelay: `TimeInterval` delay with which the Activity Indicator will be dismissed;
  ///   - colors: `ActivityIndicatorColorsThemeProtocol` colors theme;
  ///
  /// - Returns: SwifUI representation of `ActivityIndicator`.
  func activityIndicatorWith(
    loadingText: String,
    animationDelay: TimeInterval,
    dismissDelay: TimeInterval,
    colors: ActivityIndicatorColorsThemeProtocol?
  ) -> ActivityIndicatorSwiftUI

  /// Method creating and setuping.
  ///
  /// - Parameter model: ActivityIndicator's setup model.
  ///
  /// - Returns: SwifUI representation of `ActivityIndicator`.
  func activityIndicatorWith(model: ActivityIndicatorSwiftUIModel) -> ActivityIndicatorSwiftUI
}

// MARK: - Default Implementation

public extension ActivityIndicatorSwiftUIRoutable {
  func activityIndicatorWith(
    loadingText: String,
    animationDelay: TimeInterval = 0.5,
    dismissDelay: TimeInterval = 1,
    colors: ActivityIndicatorColorsThemeProtocol? = nil
  ) -> ActivityIndicatorSwiftUI {
    ActivityIndicatorSwiftUI(animationDelay: animationDelay, dismissDelay: dismissDelay)
      .setup(loadingText: loadingText, colors: colors)
  }

  func activityIndicatorWith(model: ActivityIndicatorSwiftUIModel) -> ActivityIndicatorSwiftUI {
    activityIndicatorWith(
      loadingText: model.loadingText,
      animationDelay: model.animationDelay,
      dismissDelay: model.dismissDelay,
      colors: model.colors
    )
  }

  func activityIndicatorWith(
    animationDelay: TimeInterval = 0.5,
    dismissDelay: TimeInterval = 1
  ) -> ActivityIndicatorSwiftUI {
    ActivityIndicatorSwiftUI(animationDelay: animationDelay, dismissDelay: dismissDelay)
  }
}
