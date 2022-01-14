//
//  BaseCoordinatorRouter.swift
//  MDBCommonUI
//
//

import Combine
import UIKit

open class BaseCoordinatorRouter: NSObject, CoordinatorRouterProtocol {
  public func getAllModules() -> [PresentableProtocol] {
    guard let navController = navigationController else {
      return []
    }
    return navController.viewControllers
  }

  private weak var currentController: UIViewController?

  public weak var rootViewController: UIViewController?
  public var didPresent = false

  public init(_ rootViewController: UIViewController = UIViewController()) {
    super.init()
    self.rootViewController = rootViewController
    self.rootViewController?.navigationController?.delegate = self
  }

  public func setViewController(_ controller: UIViewController) {
    rootViewController = controller
  }

  public func showScreen(_ module: PresentableProtocol) {
    guard let viewController = module.toPresent() else {
      return
    }

    currentController?.view.removeFromSuperview()
    currentController?.removeFromParent()

    currentController = viewController
    rootViewController?.addChildController(viewController) { view in
      view.edgesToSuperview()
    }
    rootViewController?.setNeedsStatusBarAppearanceUpdate()
  }

  public func push(_ module: PresentableProtocol,
                   animated: Bool,
                   hideBottomBar: Bool,
                   completion: (() -> Void)?)
  {
    guard let controller = module.toPresent() else {
      completion?()
      return
    }

    guard controller is UINavigationController == false else {
      assertionFailure("Deprecated push UINavigationController.")
      completion?()
      return
    }

    controller.hidesBottomBarWhenPushed = hideBottomBar

    let navigationController = navigationController
    guard let baseNavigation = navigationController as? BaseNavigation else {
      CATransaction.begin()
      CATransaction.setCompletionBlock { completion?() }
      navigationController?.pushViewController(controller, animated: animated)
      CATransaction.commit()
      return
    }

    baseNavigation.push(viewController: controller,
                        animated: animated,
                        completion: completion ?? {})
  }

  @discardableResult
  public func setModules(_ modules: [PresentableProtocol],
                         animated: Bool) -> EmptyPublisher
  {
    let controllers = modules.compactMap { $0.toPresent() }

    guard !controllers.isEmpty else {
      return Publishers.createDirectPublisher(())
    }

    setRootControllerIfNeeded(modules)

    let isNotDeprecated = controllers.contains { $0 is UINavigationController == false }
    guard isNotDeprecated else {
      assertionFailure("Deprecated push UINavigationController.")
      return Publishers.createDirectPublisher(())
    }

    let navigationController = navigationController
    let future = Future<Void, Never> { promise in
      CATransaction.begin()
      CATransaction.setCompletionBlock { promise(.success(())) }
      navigationController?.setViewControllers(controllers, animated: animated)
      CATransaction.commit()
    }

    return future.eraseToAnyPublisher()
  }

  public func popModule(animated: Bool) {
    guard let transitioningNavController = navigationController as? BaseNavigation else {
      navigationController?.popViewController(animated: animated)
      return
    }

    transitioningNavController.pop(animated: animated)
  }

  @discardableResult
  public func popToFirstControllerInStack(animated: Bool, completion: (() -> Void)?) -> [UIViewController]? {
    let navigationController = rootViewController?.navigationController ??
      (rootViewController?.children.first as? UINavigationController)
    guard let transitioningNavController = navigationController as? BaseNavigation else {
      navigationController?.popToRootViewController(animated: animated)
      completion?()
      return nil
    }
    return transitioningNavController.popToRoot(animated: animated, completion: completion)
  }

  public func leaveOnlyTopControllerInStack() {
    let navigationController = rootViewController?.navigationController ??
      (rootViewController?.children.first as? UINavigationController)
    if let controllers = navigationController?.viewControllers,
       controllers.count > 1,
       let topController = controllers.last
    {
      navigationController?.viewControllers = [topController]
    }
  }

  public func removeViewControllersFromStack(count cunt: Int) {
    guard let navigationController = rootViewController?.navigationController ??
      (rootViewController?.children.first as? UINavigationController)
    else {
      return
    }
    let currentCount = navigationController.viewControllers.count
    guard
      cunt > 0,
      cunt < currentCount - 1
    else {
      return
    }
    guard let topController = navigationController.viewControllers.last else {
      return
    }

    var newStack = Array(navigationController.viewControllers[0 ... (currentCount - cunt - 2)])
    newStack.append(topController)
    navigationController.viewControllers = newStack
  }

  public func popToRootModule(animated: Bool) {
    navigationController?.popToRootViewController(animated: animated)
  }

  private var navigationController: UINavigationController? {
    rootViewController?.presentedViewController as? UINavigationController ??
      rootViewController as? UINavigationController ??
      (rootViewController?.navigationController ??
        (rootViewController?.children.first as? UINavigationController)) ??
      (currentController?.children.first as? UITabBarController)?.selectedViewController as? UINavigationController
  }

  private func setRootControllerIfNeeded(_ modules: [PresentableProtocol]) {
    if modules.count == 1,
       let mainModule = modules.first as? UIViewController
    {
      setViewController(mainModule)
    } else if !modules
      .compactMap({ $0.toPresent() })
      .contains(where: { $0 === self.rootViewController }),
      let module = modules.first as? UIViewController
    {
      setViewController(module)
    }
  }
}

// MARK: UINavigationController Delegate

extension BaseCoordinatorRouter: UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController,
                                   didShow _: UIViewController,
                                   animated _: Bool)
  {
    guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
          !navigationController.viewControllers.contains(poppedViewController)
    else {
      return
    }
  }
}
