//
//  BaseFlowCoordinator.swift
//  MDBCommonUI
//
//

open class BaseFlowCoordinator<EXITPOINT>: BaseCoordinator<EXITPOINT>, FlowExitPointProtocol {
  open func performRouteForCloseModule(_: CoordinatorProtocol) {}

  @discardableResult
  open func performRouteForCloseRouting(_ coordinator: CoordinatorProtocol) -> EmptyPublisher {
    coordinator.router.dismissModule(animated: true)
  }

  open func performRouteForBackRouting(_ coordinator: CoordinatorProtocol) {
    coordinator.router.popModule()
  }
}
