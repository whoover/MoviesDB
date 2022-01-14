//
//  AppInteractor.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBConstants
import MDBDataLayer
import MDBMain
import MDBNetworking
import MDBServices
import MDBUtilities
import UIKit

/// @mockable
/// Represents app's lvl interactor.
public protocol AppInteractorProtocol {
  var reachabilityPublisher: AnyPublisher<Bool, Never> { get }
  var applicationStatePublisher: AnyPublisher<ApplicationStateChanges, Never> { get }

  func initialSetup()
}

/// AppInteractor.
class AppInteractor: AppInteractorProtocol {
  var reachabilityPublisher: AnyPublisher<Bool, Never> {
    networkingService.reachabilityChangePublisher
  }

  var applicationStatePublisher: AnyPublisher<ApplicationStateChanges, Never> {
    appStateHandler.applicationStatePublisher
  }

  private let databaseService: DatabaseServiceProtocol
  private var userDefaults: UserDefaultsProtocol
  private let indexationService: IndexationServiceProtocol
  private let localizer: LocalizerProtocol
  private let appStateHandler: ApplicationStateHandlerServiceProtocol
  private let networkingService: NetworkingServiceProtocol

  private var subscriptions = Set<AnyCancellable>()

  init(dependency: AppCoordinatorDependency) {
    appStateHandler = dependency.applicationStateHandlerService
    databaseService = dependency.databaseService
    networkingService = dependency.networkingProvider.networkingService
    userDefaults = dependency.userDefaults
    indexationService = dependency.indexationService
    localizer = dependency.localizer
  }

  func initialSetup() {
    if !userDefaults.bool(
      forKey: MDBConstants.UserDefaultsKeys.AppInteractor.isFirstAppRun.rawValue
    ) {
      indexationService.addFirstTimeLaunchIndexesIfNeeded(
        description: localizer.l10n.Indexation.description
      )

      userDefaults.setValue(true, forKey: MDBConstants.UserDefaultsKeys.AppInteractor.isFirstAppRun.rawValue)
    }

    databaseService.setup(version: 1, realmURL: nil)
  }
}
