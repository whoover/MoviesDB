//
//  CoordinatorProtocol.swift
//  MDBCommonUI
//
//

public typealias CoordinatorSetupBlock = (PresentableProtocol) -> Void
public protocol ModuleBuilder {}

/// @mockable
public protocol CoordinatorProtocol: AnyObject, PresentableProtocol {
  var startModuleSubject: PassthroughSubject<CoordinatorProtocol, Never> { get }
  var path: String? { get set }
  var router: CoordinatorRouterProtocol { get }
  var childCoordinators: WeakArray<CoordinatorProtocol> { get }

  func start()
  func start(with option: DeepLinkOptionProtocol?)
  func start(_ setupBlock: CoordinatorSetupBlock?)
  func start(with option: DeepLinkOptionProtocol?,
             setupBlock: CoordinatorSetupBlock?)

  func addChild(_ coordinator: CoordinatorProtocol)

  func close()
  func goBack()
}

public extension CoordinatorProtocol {
  func toPresent() -> UIViewController? {
    router.toPresent()
  }

  func start() {
    start(nil)
  }

  func start(with option: DeepLinkOptionProtocol?) {
    start(with: option, setupBlock: nil)
  }

  func start(_ setupBlock: CoordinatorSetupBlock?) {
    start(with: nil, setupBlock: setupBlock)
  }
}

/// @mockable
public protocol CoordinationExitPointProtocol: AnyObject {
  func performRouteForBackRouting(_ coordinator: CoordinatorProtocol)
  @discardableResult
  func performRouteForCloseRouting(_ coordinator: CoordinatorProtocol) -> EmptyPublisher
}

/// @mockable
public protocol FlowExitPointProtocol: CoordinationExitPointProtocol {}
