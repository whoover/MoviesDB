//
//  FirebaseProtocol.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Firebase
import FirebaseAnalytics
import FirebasePerformance
import Foundation

/// @mockable
/// Firebase protocol
public protocol FirebaseProtocol: AnalyticsServiceProtocol {}

extension FirebaseApp: FirebaseProtocol {
  private static let _eventSubject = PassthroughSubject<EventProtocol, Never>()

  public var eventSubject: PassthroughSubject<EventProtocol, Never> {
    FirebaseApp._eventSubject
  }

  public func configureOnStart(enabled: Bool) {
    if enabled {
      start()
    } else {
      stop()
    }
  }

  public func start() {
    make(enabled: true)
  }

  public func stop() {
    make(enabled: false)
  }

  public static func service() -> AnalyticsServiceProtocol? {
//    configure()
    app()
  }

  private func make(enabled: Bool) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 5) { [weak self] in
      Analytics.setAnalyticsCollectionEnabled(enabled)
      self?.isDataCollectionDefaultEnabled = enabled
      FirebaseConfiguration.shared.setLoggerLevel(enabled ? .warning : .min)
      Performance.sharedInstance().isDataCollectionEnabled = enabled
      Performance.sharedInstance().isInstrumentationEnabled = enabled
    }
  }
}
