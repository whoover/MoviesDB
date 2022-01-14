//
//  RootDIComponent.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBCommonUI
import MDBDataLayer
import MDBMain
import MDBServices
import MDBUtilities
import NeedleFoundation
import UIKit

/// Root DI component that holds dependencies net.
class RootDIComponent: BootstrapComponent {
  /// Returns default app instance. `MovieDB`by default.
  var movieDB: ApplicationProtocol {
    MovieDB(appBuilder: appDIComponent)
  }

  // MARK: DI components

  /// Returns application DI component.
  var appDIComponent: AppDIComponent {
    AppDIComponent(parent: self)
  }
}

/// AppBuilder protocol represents `MovieDB` DI container to build it on init.
protocol AppBuilder {
  /// appCoordinator handles DeepLinks coordination to needed screen.
  var appCoordinator: AppCoordinatorProtocol { get }
  /// handles application state updates (UIApplicationDelegate methods calls).
  var appStateHandler: AppStateHandlerProtocol { get }
}

/// Represents application properties dependencies.
/// @mockable
protocol AppDependency: Dependency {
  /// `DatabaseServiceProtocol` default implementation.
  var databaseService: DatabaseServiceProtocol { get }
  /// `NetworkingProviderProtocol` default implementation.
  var networkingProvider: NetworkingProviderProtocol { get }
  /// `FirebaseProtocol` default implementation.
  var analyticsService: AnalyticsServiceProtocol { get }
  var userDefaults: UserDefaultsProtocol { get }

  var themeManager: ThemeManagerProtocol { get }
  var localizer: LocalizerProtocol { get }
}

/// Represents Application DI Component.
class AppDIComponent: Component<AppDependency>, AppBuilder {
  // MARK: Builder properties

  var appCoordinator: AppCoordinatorProtocol {
    let appCoordinator = AppCoordinator(builder: appCoordinatorDIComponent, dependency: dependency)
    return appCoordinator
  }

  var appStateHandler: AppStateHandlerProtocol {
    AppStateHandler(
      analyticsService: dependency.analyticsService,
      networkingProvider: dependency.networkingProvider,
      userDefaults: dependency.userDefaults
    )
  }

  // MARK: Components

  var appCoordinatorDIComponent: AppCoordinatorDIComponent {
    AppCoordinatorDIComponent(parent: self)
  }

  var appAppearanceDIComponent: AppAppearanceDIComponent {
    AppAppearanceDIComponent(parent: self)
  }
}

/// @mockable
/// Represents DI properties builder for `AppCoordinator`.
public protocol AppCoordinatorBuilder {
  /// Root router that holds window's root controller.
  var rootRouter: CoordinatorRouterProtocol { get }
  /// App level interactor to interact with services.
  var appInteractor: AppInteractorProtocol { get }

  /// Creates and returns app's lvl routing calculator.
  func routingCalculator() -> AppRoutingCalculatorProtocol

  /// Creates and returns main flow coordinator.
  func mainCoordinator(exitPoint: MainFlowRoutingExitHandler)
    -> MainFlowCoordinatorProtocol
}

/// Protocol to access parent components shared dependencies for `AppCoordinator`.
protocol AppCoordinatorDependency: Dependency {
  /// returns shared analytics service
  var analyticsService: AnalyticsServiceProtocol { get }
  var databaseService: DatabaseServiceProtocol { get }
  var networkingProvider: NetworkingProviderProtocol { get }
  /// Gives access to shared userDefaults service in children components. `UserDefaults.standart` by default.
  var userDefaults: UserDefaultsProtocol { get }
  var indexationService: IndexationServiceProtocol { get }
  var localizer: LocalizerProtocol { get }
  var applicationStateHandlerService: ApplicationStateHandlerServiceProtocol { get }
}

/// DI component for app coordinator.
class AppCoordinatorDIComponent: Component<AppCoordinatorDependency>, AppCoordinatorBuilder {
  // MARK: Builder properties

  var rootRouter: CoordinatorRouterProtocol {
    RootRouter()
  }

  var appInteractor: AppInteractorProtocol {
    AppInteractor(dependency: dependency)
  }

  func routingCalculator() -> AppRoutingCalculatorProtocol {
    AppRoutingCalculator()
  }

  // Main
  func mainCoordinator(exitPoint: MainFlowRoutingExitHandler)
    -> MainFlowCoordinatorProtocol
  {
    let coordinator = MainFlowCoordinator(builder: mainCoordinatorComponent)
    coordinator.coordinationExitPoint = exitPoint
    return coordinator
  }

  // Components
  /// Main
  var mainCoordinatorComponent: MainFlowCoordinatorBuilder {
    MainFlowCoordinatorDIComponent(parent: self)
  }
}

/// Protocol that represents app appearance instance dependencies.
protocol AppAppearanceDependency: Dependency {
  /// shared theme manager
  var themeManager: ThemeManagerProtocol { get }
}

/// DI component to use in `AppAppearance`.
class AppAppearanceDIComponent: Component<AppAppearanceDependency> {}
