//
//  BaseCoordinator.swift
//  MDBCommonUI
//
//

import Combine

open class BaseCoordinator<EXITPOINT>: CoordinatorProtocol {
  public weak var parentCoordinator: CoordinatorProtocol?
  public var startModuleSubject = PassthroughSubject<CoordinatorProtocol, Never>()
  //  private var anyPublisher: AnyPublisher<CoordinatorProtocol, Never> {
//    startModuleSubject
//      .eraseToAnyPublisher()
  //  }

  public var path: String?
  public let router: CoordinatorRouterProtocol
  public private(set) var childCoordinators = WeakArray<CoordinatorProtocol>()

  public var coordinationExitPoint: EXITPOINT?
  private var subscriptions = Set<AnyCancellable>()

  public init(router: CoordinatorRouterProtocol) {
    self.router = router
  }

  public init() {
    router = BaseCoordinatorRouter()
  }

  open func start(with _: DeepLinkOptionProtocol?,
                  setupBlock _: CoordinatorSetupBlock?) {}

  public func close() {
    performRouteForCloseRouting()
  }

  public func goBack() {
    performRouteForBackRouting()
  }

  // add only unique object
  public func addChild(_ coordinator: CoordinatorProtocol) {
    guard !childCoordinators.contains(where: { $0 === coordinator }) else {
      return
    }

    childCoordinators.append(coordinator)
    setupPath(for: coordinator)
    coordinator
      .startModuleSubject
      .subscribe(startModuleSubject)
      .store(in: &subscriptions)
    startModuleSubject.send(coordinator)
  }

  private func setupPath(for coordinator: CoordinatorProtocol) {
    guard let path = path else {
      print("Path not installed for", coordinator)
      return
    }

    coordinator.path = path + "->" + String(describing: coordinator)
  }
}

extension BaseCoordinator: ModuleRoutingHandlingProtocol {
  public func performRouteForCloseRouting() {
    (coordinationExitPoint as? CoordinationExitPointProtocol)?.performRouteForCloseRouting(self)
  }

  public func performRouteForBackRouting() {
    (coordinationExitPoint as? CoordinationExitPointProtocol)?.performRouteForBackRouting(self)
  }
}
