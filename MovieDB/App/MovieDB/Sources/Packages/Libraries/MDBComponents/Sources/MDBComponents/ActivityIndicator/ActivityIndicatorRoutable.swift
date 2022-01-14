//
//  ActivityIndicatorRoutable.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBUtilities
import UIKit

private var subscriptions = [String: AnyCancellable]()
private var activityIndicatorContainer: WeakContainer<ActivityIndicator>?

public protocol ActivityIndicatorRoutable {
  /// Method for start Activity Indicator if not started before.
  ///
  /// - Parameters:
  ///   - loadingText: ActivityIndicator's on loading text;
  ///   - animationDelay: `TimeInterval` delay with which the Activity Indicator is displayed;
  ///   - dismissDelay: `TimeInterval` delay with which the Activity Indicator will be dismissed;
  ///   - colors: `ActivityIndicatorColorsThemeProtocol` colors theme;
  func startIndicatorIfNeeded(
    loadingText: String,
    animationDelay: TimeInterval,
    dismissDelay: TimeInterval,
    colors: ActivityIndicatorColorsThemeProtocol?
  )

  /// Method for stop Activity Indicator.
  func stopIndicator(completion: (() -> Void)?)
}

public extension ActivityIndicatorRoutable where Self: UIViewController {
  /// Method for start Activity Indicator if not started before.
  ///
  /// - Parameters:
  ///   - loadingText: ActivityIndicator's on loading text;
  ///   - animationDelay: `TimeInterval` delay with which the Activity Indicator is displayed. Defaults to 0.5;
  ///   - dismissDelay: `TimeInterval` delay with which the Activity Indicator will be dismissed. Defaults to 1;
  func startIndicatorIfNeeded(
    loadingText: String,
    animationDelay: TimeInterval = 0.5,
    dismissDelay: TimeInterval = 1
  ) {
    startIndicatorIfNeeded(loadingText: loadingText,
                           animationDelay: animationDelay,
                           dismissDelay: dismissDelay,
                           colors: nil)
  }

  func startIndicatorIfNeeded(
    loadingText: String,
    animationDelay: TimeInterval,
    dismissDelay: TimeInterval,
    colors: ActivityIndicatorColorsThemeProtocol?
  ) {
    guard activityIndicator == nil else {
      return
    }

    let indicator = ActivityIndicator(animationDelay: animationDelay, dismissDelay: dismissDelay)
    indicator.setupWith(loadingText: loadingText, colors: colors)

    activityIndicator = indicator
  }

  func startIndicatorIfNeeded(configuration: OnLoadingStateConfigurator) {
    startIndicatorIfNeeded(
      loadingText: configuration.loadingText,
      animationDelay: 0.5,
      dismissDelay: 1,
      colors: configuration.colors
    )
  }

  /// Dismiss without animation.
  func stopIndicator() {
    stopIndicator(completion: nil)
  }

  func stopIndicator(completion: (() -> Void)?) {
    guard let indicator = activityIndicator else {
      completion?()
      return
    }

    guard !indicator.canDismiss else {
      activityIndicator = nil
      completion?()
      return
    }

    let subscriptionId = UUID().uuidString
    func stop() {
      activityIndicator = nil
      removeSubscriptionWith(id: subscriptionId)
      completion?()
    }

    subscriptions[subscriptionId] = indicator
      .$canDismiss
      .filter { $0 }
      .sink { _ in
        stop()
      }
  }
}

// MARK: - Private Helpers

private extension UIViewController {
  var activityIndicator: ActivityIndicator? {
    get {
      getIndicator()
    }
    set {
      guard let newValue = newValue else {
        if let indicator = getIndicator() {
          indicator.stop()
          indicator.removeFromSuperview()
          activityIndicatorContainer = nil
        }
        return
      }

      activityIndicatorContainer = WeakContainer(value: newValue)

      guard let window = view.window else {
        newValue.add(to: view).do {
          $0.edgesToSuperview()
          $0.start()
        }
        return
      }

      newValue.add(to: window).do {
        $0.edgesToSuperview()
        $0.start()
      }
    }
  }

  func getIndicator() -> ActivityIndicator? {
    activityIndicatorContainer?.value
  }

  func removeSubscriptionWith(id: String) {
    subscriptions.removeValue(forKey: id)
  }
}
