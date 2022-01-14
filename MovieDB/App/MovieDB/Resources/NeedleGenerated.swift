//
//  Copyright (c) 2022. whoover
//
//

import Firebase
import Foundation
import MDBCommonUI
import MDBDataLayer
import MDBMain
import MDBServices
import MDBUtilities
import NeedleFoundation
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash: String? = nil

// MARK: - Registration

public func registerProviderFactories() {
  __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent") { component in
    EmptyDependencyProvider(component: component)
  }
  __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent->AppDIComponent") { component in
    AppDependency015ea769ff99e08ab5b2Provider(component: component)
  }
  __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent") { component in
    AppCoordinatorDependencyccca0bd947bfa256c9a1Provider(component: component)
  }
  __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent->AppDIComponent->AppAppearanceDIComponent") { component in
    AppAppearanceDependency1c9f8e8d9fe7b2984b2eProvider(component: component)
  }
  __DependencyProviderRegistry.instance
    .registerDependencyProviderFactory(for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent") { component in
      EmptyDependencyProvider(component: component)
    }
  __DependencyProviderRegistry.instance
    .registerDependencyProviderFactory(
      for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MovieDetailsCoordinatorDIComponent"
    ) { component in
      EmptyDependencyProvider(component: component)
    }
  __DependencyProviderRegistry.instance
    .registerDependencyProviderFactory(
      for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MovieDetailsCoordinatorDIComponent->MovieDetailsInteractorDIComponent"
    ) { component in
      MovieDetailsInteractorDependencye4244ee403df69a777fcProvider(component: component)
    }
  __DependencyProviderRegistry.instance
    .registerDependencyProviderFactory(
      for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MovieDetailsCoordinatorDIComponent->MovieDetailsPresenterDIComponent"
    ) { component in
      MovieDetailsPresenterDependencya78123d0b27bb6e029cbProvider(component: component)
    }
  __DependencyProviderRegistry.instance
    .registerDependencyProviderFactory(
      for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MoviesListCoordinatorDIComponent"
    ) { component in
      EmptyDependencyProvider(component: component)
    }
  __DependencyProviderRegistry.instance
    .registerDependencyProviderFactory(
      for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MoviesListCoordinatorDIComponent->MoviesListInteractorDIComponent"
    ) { component in
      MoviesListInteractorDependencyc9ca9600d2351b21fc9bProvider(component: component)
    }
  __DependencyProviderRegistry.instance
    .registerDependencyProviderFactory(
      for: "^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MoviesListCoordinatorDIComponent->MoviesListPresenterDIComponent"
    ) { component in
      MoviesListPresenterDependencya5a6614e28535127763bProvider(component: component)
    }
}

// MARK: - Providers

private class AppDependency015ea769ff99e08ab5b2BaseProvider: AppDependency {
  var databaseService: DatabaseServiceProtocol {
    rootDIComponent.databaseService
  }

  var networkingProvider: NetworkingProviderProtocol {
    rootDIComponent.networkingProvider
  }

  var analyticsService: AnalyticsServiceProtocol {
    rootDIComponent.analyticsService
  }

  var userDefaults: UserDefaultsProtocol {
    rootDIComponent.userDefaults
  }

  var themeManager: ThemeManagerProtocol {
    rootDIComponent.themeManager
  }

  var localizer: LocalizerProtocol {
    rootDIComponent.localizer
  }

  private let rootDIComponent: RootDIComponent
  init(rootDIComponent: RootDIComponent) {
    self.rootDIComponent = rootDIComponent
  }
}

/// ^->RootDIComponent->AppDIComponent
private class AppDependency015ea769ff99e08ab5b2Provider: AppDependency015ea769ff99e08ab5b2BaseProvider {
  init(component: NeedleFoundation.Scope) {
    super.init(rootDIComponent: component.parent as! RootDIComponent)
  }
}

private class AppCoordinatorDependencyccca0bd947bfa256c9a1BaseProvider: AppCoordinatorDependency {
  var analyticsService: AnalyticsServiceProtocol {
    rootDIComponent.analyticsService
  }

  var databaseService: DatabaseServiceProtocol {
    rootDIComponent.databaseService
  }

  var networkingProvider: NetworkingProviderProtocol {
    rootDIComponent.networkingProvider
  }

  var userDefaults: UserDefaultsProtocol {
    rootDIComponent.userDefaults
  }

  var indexationService: IndexationServiceProtocol {
    rootDIComponent.indexationService
  }

  var localizer: LocalizerProtocol {
    rootDIComponent.localizer
  }

  var applicationStateHandlerService: ApplicationStateHandlerServiceProtocol {
    rootDIComponent.applicationStateHandlerService
  }

  private let rootDIComponent: RootDIComponent
  init(rootDIComponent: RootDIComponent) {
    self.rootDIComponent = rootDIComponent
  }
}

/// ^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent
private class AppCoordinatorDependencyccca0bd947bfa256c9a1Provider: AppCoordinatorDependencyccca0bd947bfa256c9a1BaseProvider {
  init(component: NeedleFoundation.Scope) {
    super.init(rootDIComponent: component.parent.parent as! RootDIComponent)
  }
}

private class AppAppearanceDependency1c9f8e8d9fe7b2984b2eBaseProvider: AppAppearanceDependency {
  var themeManager: ThemeManagerProtocol {
    rootDIComponent.themeManager
  }

  private let rootDIComponent: RootDIComponent
  init(rootDIComponent: RootDIComponent) {
    self.rootDIComponent = rootDIComponent
  }
}

/// ^->RootDIComponent->AppDIComponent->AppAppearanceDIComponent
private class AppAppearanceDependency1c9f8e8d9fe7b2984b2eProvider: AppAppearanceDependency1c9f8e8d9fe7b2984b2eBaseProvider {
  init(component: NeedleFoundation.Scope) {
    super.init(rootDIComponent: component.parent.parent as! RootDIComponent)
  }
}

private class MovieDetailsInteractorDependencye4244ee403df69a777fcBaseProvider: MovieDetailsInteractorDependency {
  var saveImagesService: ImageSaveServiceProtocol {
    rootDIComponent.saveImagesService
  }

  var networkingProvider: NetworkingProviderProtocol {
    rootDIComponent.networkingProvider
  }

  private let rootDIComponent: RootDIComponent
  init(rootDIComponent: RootDIComponent) {
    self.rootDIComponent = rootDIComponent
  }
}

/// ^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MovieDetailsCoordinatorDIComponent->MovieDetailsInteractorDIComponent
private class MovieDetailsInteractorDependencye4244ee403df69a777fcProvider: MovieDetailsInteractorDependencye4244ee403df69a777fcBaseProvider {
  init(component: NeedleFoundation.Scope) {
    super.init(rootDIComponent: component.parent.parent.parent.parent.parent as! RootDIComponent)
  }
}

private class MovieDetailsPresenterDependencya78123d0b27bb6e029cbBaseProvider: MovieDetailsPresenterDependency {
  var localizer: LocalizerProtocol {
    rootDIComponent.localizer
  }

  var themeManager: ThemeManagerProtocol {
    rootDIComponent.themeManager
  }

  private let rootDIComponent: RootDIComponent
  init(rootDIComponent: RootDIComponent) {
    self.rootDIComponent = rootDIComponent
  }
}

/// ^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MovieDetailsCoordinatorDIComponent->MovieDetailsPresenterDIComponent
private class MovieDetailsPresenterDependencya78123d0b27bb6e029cbProvider: MovieDetailsPresenterDependencya78123d0b27bb6e029cbBaseProvider {
  init(component: NeedleFoundation.Scope) {
    super.init(rootDIComponent: component.parent.parent.parent.parent.parent as! RootDIComponent)
  }
}

private class MoviesListInteractorDependencyc9ca9600d2351b21fc9bBaseProvider: MoviesListInteractorDependency {
  var saveImagesService: ImageSaveServiceProtocol {
    rootDIComponent.saveImagesService
  }

  var networkingProvider: NetworkingProviderProtocol {
    rootDIComponent.networkingProvider
  }

  var databaseService: DatabaseServiceProtocol {
    rootDIComponent.databaseService
  }

  private let rootDIComponent: RootDIComponent
  init(rootDIComponent: RootDIComponent) {
    self.rootDIComponent = rootDIComponent
  }
}

/// ^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MoviesListCoordinatorDIComponent->MoviesListInteractorDIComponent
private class MoviesListInteractorDependencyc9ca9600d2351b21fc9bProvider: MoviesListInteractorDependencyc9ca9600d2351b21fc9bBaseProvider {
  init(component: NeedleFoundation.Scope) {
    super.init(rootDIComponent: component.parent.parent.parent.parent.parent as! RootDIComponent)
  }
}

private class MoviesListPresenterDependencya5a6614e28535127763bBaseProvider: MoviesListPresenterDependency {
  var localizer: LocalizerProtocol {
    rootDIComponent.localizer
  }

  var themeManager: ThemeManagerProtocol {
    rootDIComponent.themeManager
  }

  private let rootDIComponent: RootDIComponent
  init(rootDIComponent: RootDIComponent) {
    self.rootDIComponent = rootDIComponent
  }
}

/// ^->RootDIComponent->AppDIComponent->AppCoordinatorDIComponent->MainFlowCoordinatorDIComponent->MoviesListCoordinatorDIComponent->MoviesListPresenterDIComponent
private class MoviesListPresenterDependencya5a6614e28535127763bProvider: MoviesListPresenterDependencya5a6614e28535127763bBaseProvider {
  init(component: NeedleFoundation.Scope) {
    super.init(rootDIComponent: component.parent.parent.parent.parent.parent as! RootDIComponent)
  }
}
