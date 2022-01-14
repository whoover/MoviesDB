//
//  ActivityIndicator.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBUtilities
import UIKit

public final class ActivityIndicator: UIView {
  @Published var canDismiss = true

  private let eventsHandler: ActivityIndicatorEventsHandler
  private let indicatorView = UIActivityIndicatorView()
  private let loadingLabel = UILabel()

  private var subscriptions = Set<AnyCancellable>()

  init(
    animationDelay: TimeInterval = 0.5,
    dismissDelay: TimeInterval = 1
  ) {
    eventsHandler = ActivityIndicatorEventsHandler(dismissDelay: dismissDelay)
    super.init(frame: .zero)

    setupSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { nil }

  func setupWith(
    loadingText: String,
    colors: ActivityIndicatorColorsThemeProtocol?
  ) {
    loadingLabel.text = loadingText

    indicatorView.backgroundColor = colors?.background ?? defaultBackgroundColor
    loadingLabel.textColor = colors?.text ?? defaultTextColor
  }
}

// MARK: - UI Setup

private extension ActivityIndicator {
  func setupSubviews() {
    backgroundColor = .clear

    indicatorView.add(to: self).do {
      $0.centerInSuperview()
      $0.roundingCorners(corners: .allCorners, radius: 10)
      $0.hidesWhenStopped = true
    }

    loadingLabel.add(to: indicatorView).do {
      $0.centerX(to: indicatorView)
      $0.width(to: indicatorView, multiplier: 0.9)
      $0.height(20)
      $0.bottom(to: indicatorView, offset: -24)
      $0.textAlignment = .center
      $0.font = .systemFont(ofSize: 16)
    }
  }
}

// MARK: - Animation

extension ActivityIndicator {
  func start() {
    subscribeOnPublishers()
    indicatorView.stopAnimating()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.animate()
    }
  }

  private func animate() {
    let duration = 0.1

    canDismiss = false
    eventsHandler.animationWillStart()

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.indicatorView.startAnimating()
    }
  }

  private func subscribeOnPublishers() {
    eventsHandler
      .animationMayStopPublisher
      .sink(
        receiveValue: { [weak self] in
          self?.canDismiss = true
        }
      )
      .store(in: &subscriptions)
  }

  func stop() {
    indicatorView.stopAnimating()
  }
}

// MARK: - Default values

// Remove after all screen will be setuped for working with ActivityIndicator
private extension ActivityIndicator {
  var defaultBackgroundColor: UIColor { .white }

  var defaultTextColor: UIColor { .black }
}
