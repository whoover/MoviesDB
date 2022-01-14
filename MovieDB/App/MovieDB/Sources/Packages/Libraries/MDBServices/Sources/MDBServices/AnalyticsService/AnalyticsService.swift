//
//  AnalyticsService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import FirebaseAnalytics
import Foundation

public final class AnalyticsService: AnalyticsServiceProtocol, AnalyticsServiceConfigurableProtocol {
  public let eventSubject = PassthroughSubject<EventProtocol, Never>()
  private let dispatchQueue = DispatchQueue(label: "com.movie-db.AnalyticsService.queue")
  private var subscriptions = Set<AnyCancellable>()
  private var services: [AnalyticsServiceProtocol] = []
  private let servicesTypes: [AnalyticsServiceProtocol.Type]

  public init(servicesTypes: [AnalyticsServiceProtocol.Type]) {
    self.servicesTypes = servicesTypes
  }

  public func configure() {
    services = servicesTypes.compactMap { $0.service() }
  }

  public func configureOnStart(enabled: Bool) {
    services.forEach { $0.configureOnStart(enabled: enabled) }
  }

  public func start() {
    subscribeOnEvents()
    services.forEach { $0.start() }
  }

  public func stop() {
    unsubscribeFromEvents()
    services.forEach { $0.stop() }
  }

  private func subscribeOnEvents() {
    eventSubject
      .subscribe(on: dispatchQueue)
      .receive(on: dispatchQueue)
      .sink { [weak self] event in
        self?.services.forEach {
          $0.eventSubject.send(event)
        }
      }
      .store(in: &subscriptions)
  }

  private func unsubscribeFromEvents() {
    subscriptions.forEach { $0.cancel() }
    subscriptions = []
  }
}
