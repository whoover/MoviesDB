//
//  CoordinatorRouterProtocol.swift
//  MDBCommonUI
//
//

import Combine
import MDBCommon

/// @mockable
public protocol CoordinatorRouterProtocol: AnyObject {
  var rootViewController: UIViewController? { get }

  func setViewController(_ controller: UIViewController)
  func showScreen(_ module: PresentableProtocol)

  @discardableResult
  func present(_ module: PresentableProtocol) -> EmptyPublisher
  @discardableResult
  func present(_ module: PresentableProtocol, style: UIModalPresentationStyle) -> EmptyPublisher
  @discardableResult
  func present(_ module: PresentableProtocol, animated: Bool, style: UIModalPresentationStyle) -> EmptyPublisher

  func push(_ module: PresentableProtocol,
            completion: (() -> Void)?)
  func push(_ module: PresentableProtocol,
            hideBottomBar: Bool,
            completion: (() -> Void)?)
  func push(_ module: PresentableProtocol,
            animated: Bool,
            completion: (() -> Void)?)

  func push(_ module: PresentableProtocol,
            animated: Bool,
            hideBottomBar: Bool,
            completion: (() -> Void)?)

  @discardableResult
  func setModules(_ modules: [PresentableProtocol],
                  animated: Bool) -> EmptyPublisher

  func popModule()
  func popModule(animated: Bool)

  func dismissModule() -> EmptyPublisher
  func dismissModule(animated: Bool) -> EmptyPublisher

  func popToFirstControllerInStack(animated: Bool) -> EmptyPublisher
  func popToRootModule(animated: Bool)

  func leaveOnlyTopControllerInStack()
  func getAllModules() -> [PresentableProtocol]
  /// removs 'count' view controllers below top vc without animation
  func removeViewControllersFromStack(count: Int)
}

public extension CoordinatorRouterProtocol {
  @discardableResult
  func present(_ module: PresentableProtocol) -> EmptyPublisher {
    present(module, style: .overFullScreen)
  }

  @discardableResult
  func present(_ module: PresentableProtocol, style: UIModalPresentationStyle) -> EmptyPublisher {
    present(module, animated: true, style: style)
  }

  @discardableResult
  func present(_ module: PresentableProtocol,
               animated: Bool,
               style: UIModalPresentationStyle) -> EmptyPublisher
  {
    guard let controller = module.toPresent() else {
      return Publishers.createDirectPublisher(())
    }

    let lastControllerInStack = rootViewController?.navigationController?.visibleViewController ?? rootViewController

    controller.modalPresentationStyle = style
    var presentingViewController: UIViewController? = lastControllerInStack
    while let nextPresentedController = presentingViewController?.presentedViewController,
          !nextPresentedController.isBeingDismissed
    {
      presentingViewController = nextPresentedController
    }

    let future = Future<Void, Never> { promise in
      presentingViewController?.present(controller, animated: animated, completion: { [weak self] in
        self?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        promise(.success(()))
      })
    }

    return future.eraseToAnyPublisher()
  }

  func dismissModule() -> EmptyPublisher {
    dismissModule(animated: true)
  }

  func dismissModule(animated: Bool) -> EmptyPublisher {
    var presentingViewController: UIViewController? = rootViewController
    while let nextPresentedController =
      presentingViewController?.presentedViewController
    {
      presentingViewController = nextPresentedController
    }

    let future = Future<Void, Never> { [weak self] promise in
      if presentingViewController?.isModal == true {
        self?.rootViewController?.dismiss(animated: animated, completion: { [weak self] in
          promise(.success(()))
          DispatchQueue.main.async {
            self?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
          }
        })
      } else {
        promise(.success(()))
      }
    }

    return future.eraseToAnyPublisher()
  }

  func push(_ module: PresentableProtocol,
            completion: (() -> Void)?)
  {
    push(module, animated: true, completion: completion)
  }

  func push(_ module: PresentableProtocol,
            hideBottomBar: Bool,
            completion: (() -> Void)?)
  {
    push(module,
         animated: true,
         hideBottomBar: hideBottomBar,
         completion: completion)
  }

  func push(_ module: PresentableProtocol,
            animated: Bool,
            completion: (() -> Void)?)
  {
    push(module,
         animated: animated,
         hideBottomBar: false,
         completion: completion)
  }

  @discardableResult
  func setModules(_ modules: [PresentableProtocol]) -> EmptyPublisher {
    setModules(modules, animated: true)
  }

  func popModule() {
    popModule(animated: true)
  }

  func popToFirstControllerInStack(animated: Bool) -> EmptyPublisher {
    popToFirstControllerInStack(animated: animated)
  }

  // MARK: PresentableProtocol

  func toPresent() -> UIViewController? {
    rootViewController
  }
}
