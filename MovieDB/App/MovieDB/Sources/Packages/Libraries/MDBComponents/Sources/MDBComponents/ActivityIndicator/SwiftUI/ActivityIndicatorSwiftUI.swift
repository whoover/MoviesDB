//
//  ActivityIndicatorSwiftUI.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBUtilities
import SwiftUI

public final class ActivityIndicatorSwiftUI: UIViewRepresentable {
  private let activityIndicator: ActivityIndicator

  private var subscriptions = Set<AnyCancellable>()

  public init(
    animationDelay: TimeInterval = 0.5,
    dismissDelay: TimeInterval = 1
  ) {
    activityIndicator = ActivityIndicator(
      animationDelay: animationDelay, dismissDelay: dismissDelay
    )
  }

  public func makeUIView(context: Context) -> ActivityIndicator {
    activityIndicator
  }

  public func updateUIView(_ uiView: ActivityIndicator, context: Context) {}
}

// MARK: - Modifiers

public extension ActivityIndicatorSwiftUI {
  func setup(
    loadingText: String,
    colors: ActivityIndicatorColorsThemeProtocol? = nil
  ) -> ActivityIndicatorSwiftUI {
    activityIndicator.setupWith(loadingText: loadingText, colors: colors)

    return self
  }

  func start() -> ActivityIndicatorSwiftUI {
    activityIndicator.start()

    return self
  }

  func canDismiss(_ handler: @escaping (Bool) -> Void) -> ActivityIndicatorSwiftUI {
    activityIndicator
      .$canDismiss
      .sink(
        receiveValue: {
          handler($0)
        }
      )
      .store(in: &subscriptions)

    return self
  }
}
