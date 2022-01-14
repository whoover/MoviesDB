//
//  AnalyticsServiceProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import Foundation

public protocol AnalyticsServiceProtocol {
  var eventSubject: PassthroughSubject<EventProtocol, Never> { get }

  func configureOnStart(enabled: Bool)
  func start()
  func stop()

  static func service() -> AnalyticsServiceProtocol?
}

public protocol AnalyticsServiceConfigurableProtocol {
  func configure()
}

public extension AnalyticsServiceProtocol where Self: AnalyticsServiceConfigurableProtocol {
  static func service() -> AnalyticsServiceProtocol? {
    nil
  }
}
