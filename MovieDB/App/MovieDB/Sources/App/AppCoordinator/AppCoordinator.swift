//
//  AppCoordinator.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

import Combine
import MDBComponents
import MDBMain
import MDBServices
import MDBUtilities
import UIKit

/// Represents all children modules exit points. AppCoordinator conformed to these protocols.
typealias AppCoordinatorExitPoints = MainFlowRoutingExitHandler

/// Represents app coordinator protocol.
protocol AppCoordinatorProtocol: CoordinatorProtocol, AppCoordinatorExitPoints {
  /// Indicates if app is already loaded.
  func isAppLoaded() -> Bool
  func initialSetup()
  func handle(option: DeepLinks.UrlPaths)
}

/// App's lvl coordinator.
final class AppCoordinator: BaseFlowCoordinator<ExpressibleByNilLiteral>, AppCoordinatorProtocol {
  var isLoggedInPublisher: AnyPublisher<Void, Never> {
    loggedInSubject.eraseToAnyPublisher()
  }

  private let loggedInSubject = PassthroughSubject<Void, Never>()

  /// App's lvl interactor.
  private let appInteractor: AppInteractorProtocol
  /// Subscriptions set.
  private var subscriptions = Set<AnyCancellable>()
  /// Stores DI builder to create child coordinators.
  private let builder: AppCoordinatorBuilder
  /// Calculates needed route using deepLinks.
  private let routeCalculator: AppRoutingCalculatorProtocol
  private let themeManager: ThemeManagerProtocol
  private let localizer: LocalizerProtocol
  /// Stores last opened deepLink.
  private var lastDeepLink: DeepLinks?

  private var currentTheme: ThemeProtocol
  private var isApplicationInBackground = false
  private var isBeingPresentedSubscriprion: AnyCancellable?
  private var sessionExpiredSubject = EmptyPassthroughSubject()

  /// Init with DI builder.
  init(builder: AppCoordinatorBuilder, dependency: AppDependency) {
    self.builder = builder
    appInteractor = builder.appInteractor
    routeCalculator = builder.routingCalculator()
    themeManager = dependency.themeManager
    currentTheme = dependency.themeManager.currentTheme
    localizer = dependency.localizer

    super.init(router: builder.rootRouter)
    path = String(describing: self)
  }

  func isAppLoaded() -> Bool {
    true
  }

  func initialSetup() {
    themeManager.themePublisher.sink { [weak self] theme in
      self?.currentTheme = theme
    }.store(in: &subscriptions)

    appInteractor.initialSetup()
    handleReachability()
  }

  func handleApplicationState() {
    appInteractor
      .applicationStatePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self = self else {
          return
        }

        switch state {
        case .background:
          self.isApplicationInBackground = true
        case .foreground:
          self.isApplicationInBackground = false
        default:
          break
        }
      }.store(in: &subscriptions)
  }

  func handle(option: DeepLinks.UrlPaths) {}

  private func handleReachability() {
    appInteractor
      .reachabilityPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isEnabled in
        guard let self = self,
              let rootRouter = self.router as? RootRouter
        else {
          return
        }

        if isEnabled {
          rootRouter.hideNetworkingAlert()
        } else {
          rootRouter.showNetworkingAlert(
            text: self.localizer.l10n.Error.internet,
            theme: self.themeManager.currentTheme.colors.components.internetAlert
          )
        }
      }.store(in: &subscriptions)
  }

  override func start(with option: DeepLinkOptionProtocol?,
                      setupBlock: CoordinatorSetupBlock?)
  {
    lastDeepLink = option as? DeepLinks ?? .main
    performRouting(routeCalculator.directRoute(lastDeepLink))
  }

  /// Handles given deepLink and start needed flow.
  private func performRouting(_ route: DeepLinks) {
    switch route {
    case .main:
      startMainFlow()
    }
    lastDeepLink = route
  }

  func topMostViewController() -> UIViewController? {
    var viewController = router.rootViewController

    while let presentedController = viewController?.presentedViewController {
      viewController = presentedController
    }

    switch viewController {
    case let controller as BaseNavigation:
      return controller.topViewController
    default:
      return viewController
    }
  }
}

// MARK: - Main Flow

extension AppCoordinator {
  /// start main flow.
  func startMainFlow() {
    loggedInSubject.send()

    let coordinator = builder.mainCoordinator(exitPoint: self)
    addChild(coordinator)
    coordinator.start { [weak self] in
      self?.router.showScreen($0)
    }
  }
}

// MARK: - Exit points

extension AppCoordinator {
  func performRoute(
    _ coordinator: CoordinatorProtocol,
    outputModel: ModuleOutputModelProtocol
  ) {
    let option = routeCalculator.createOption(from: outputModel)
    let routePublisher = routeCalculator.nextAfter(option)

    routePublisher
      .sink(receiveValue: { [weak self] in
        self?.performRouting($0)
      })
      .store(in: &subscriptions)
  }
}

extension UIViewController: AlertRoutableProtocol {}

extension UIViewController: ActivityIndicatorRoutable {}
