//
//  ActivityIndicatorEventsHandler.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import Combine
import Foundation

final class ActivityIndicatorEventsHandler {
  /// Delay with which the Activity Indicator will be dismissed.
  let dismissDelay: TimeInterval

  var animationMayStopPublisher: AnyPublisher<Void, Never> {
    animationMayStopSubject
      .eraseToAnyPublisher()
  }

  private let animationMayStopSubject = PassthroughSubject<Void, Never>()
  private var subscriptions = Set<AnyCancellable>()

  init(dismissDelay: TimeInterval) {
    self.dismissDelay = dismissDelay
  }

  func animationWillStart() {
    DispatchQueue.main.asyncAfter(deadline: .now() + dismissDelay) {
      self.animationMayStopSubject.send()
    }
  }
}
