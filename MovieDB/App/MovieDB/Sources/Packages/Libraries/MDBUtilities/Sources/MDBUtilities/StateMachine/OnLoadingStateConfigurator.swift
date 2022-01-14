//
//  OnLoadingStateConfigurator.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// OnLoading state configuration
public struct OnLoadingStateConfigurator {
  public let loadingText: String
  public let colors: ActivityIndicatorColorsThemeProtocol?

  public init(
    loadingText: String,
    colors: ActivityIndicatorColorsThemeProtocol? = nil
  ) {
    self.loadingText = loadingText
    self.colors = colors
  }
}

extension OnLoadingStateConfigurator: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(loadingText)

    if let colors = colors {
      hasher.combine(colors.background)
      hasher.combine(colors.text)
    }
  }

  public static func == (
    lhs: OnLoadingStateConfigurator,
    rhs: OnLoadingStateConfigurator
  ) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}

extension OnLoadingStateConfigurator: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(loadingText: value)
  }
}
