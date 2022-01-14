//
//  AppStateHandler.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

import Foundation
import MDBConstants
import MDBServices
import MDBUtilities

/// Protocol that represents object to handle app state changing.
protocol AppStateHandlerProtocol {
  /// Method to run initial setup on application launch.
  func initialSetup(completion: ((Bool) -> Void)?)
}

/// Default implementation for `AppStateHandlerProtocol`.
final class AppStateHandler: AppStateHandlerProtocol {
  private let analyticsService: AnalyticsServiceProtocol
  private let networkingService: NetworkingServiceProtocol
  private let userDefaults: UserDefaultsProtocol
  private var subscriptions = Set<AnyCancellable>()

  init(
    analyticsService: AnalyticsServiceProtocol,
    networkingProvider: NetworkingProviderProtocol,
    userDefaults: UserDefaultsProtocol
  ) {
    self.analyticsService = analyticsService
    networkingService = networkingProvider.networkingService
    self.userDefaults = userDefaults
  }

  func initialSetup(completion: ((Bool) -> Void)?) {
    (analyticsService as? AnalyticsServiceConfigurableProtocol)?.configure()

    let isAnalyticsEnabled = userDefaults.getValue(
      forKey: MDBConstants.UserDefaultsKeys.UserPreferences.analyticsEnabled.rawValue
    ) as? Bool ?? true
    let isNotificationsEnabled = userDefaults.getValue(
      forKey: MDBConstants.UserDefaultsKeys.UserPreferences.notificationsEnabled.rawValue
    ) as? Bool ?? true

    guard networkingService.isReachable() else {
      networkingService
        .reachabilityChangePublisher
        .sink { [weak self] isReachable in
          if isReachable {
            self?.analyticsService.configureOnStart(enabled: isAnalyticsEnabled)
            self?.subscriptions.removeAll()
            completion?(isNotificationsEnabled)
          }
        }.store(in: &subscriptions)
      return
    }
    analyticsService.configureOnStart(enabled: isAnalyticsEnabled)
    completion?(isNotificationsEnabled)
  }
}
