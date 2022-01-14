//
//  ApplicationStateHandlerService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import Foundation

public enum ApplicationStateChanges {
  case background
  case foreground
  case resignActivity
  case becomeActive
}

public protocol ApplicationStateHandlerServiceProtocol {
  var applicationStatePublisher: AnyPublisher<ApplicationStateChanges, Never> { get }
}

public final class ApplicationStateHandlerService: ApplicationStateHandlerServiceProtocol {
  public var applicationStatePublisher: AnyPublisher<ApplicationStateChanges, Never> {
    didEnterBackgroundPublisher
      .merge(with: willEnterForegroundPublisher, willResignActivePublisher, didBecomeActivePublisher)
      .eraseToAnyPublisher()
  }

  public init() {}
}

// MARK: - Publisher

private extension ApplicationStateHandlerService {
  var notificationCenter: NotificationCenter {
    NotificationCenter.default
  }

  var didEnterBackgroundPublisher: AnyPublisher<ApplicationStateChanges, Never> {
    notificationCenter
      .publisher(for: UIApplication.didEnterBackgroundNotification)
      .map { _ in ApplicationStateChanges.background }
      .eraseToAnyPublisher()
  }

  var willEnterForegroundPublisher: AnyPublisher<ApplicationStateChanges, Never> {
    notificationCenter
      .publisher(for: UIApplication.willEnterForegroundNotification)
      .map { _ in ApplicationStateChanges.foreground }
      .eraseToAnyPublisher()
  }

  var willResignActivePublisher: AnyPublisher<ApplicationStateChanges, Never> {
    notificationCenter
      .publisher(for: UIApplication.willResignActiveNotification)
      .map { _ in ApplicationStateChanges.resignActivity }
      .eraseToAnyPublisher()
  }

  var didBecomeActivePublisher: AnyPublisher<ApplicationStateChanges, Never> {
    notificationCenter
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .map { _ in ApplicationStateChanges.becomeActive }
      .eraseToAnyPublisher()
  }
}
