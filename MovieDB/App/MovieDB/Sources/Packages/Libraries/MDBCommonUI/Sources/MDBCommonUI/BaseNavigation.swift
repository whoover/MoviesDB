//
//  BaseNavigation.swift
//  MDBCommonUI
//
//

/// BaseNavigation controller that gives possibility to handle `push`, `pop` completions.
open class BaseNavigation: UINavigationController {
  private var isPushInProgress: Bool = false

  override open var childForStatusBarStyle: UIViewController? {
    topViewController
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.isTranslucent = false
    navigationBar.backgroundColor = .green
    navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
  }

  override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
    push(viewController: viewController, animated: animated) {}
    rootSetNeedsStatusBarAppearanceUpdate()
  }

  @objc
  override open func popViewController(animated: Bool) -> UIViewController? {
    let result = pop(animated: animated)
    rootSetNeedsStatusBarAppearanceUpdate()
    return result
  }

  @objc
  override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
    let result = popToRoot(animated: animated)
    rootSetNeedsStatusBarAppearanceUpdate()
    return result
  }

  @objc
  open func rootSetNeedsStatusBarAppearanceUpdate() {
    view.window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
  }

  @objc
  open func push(viewController: UIViewController,
                 animated: Bool,
                 completion: @escaping () -> Void)
  {
    guard !isPushInProgress else {
      return
    }

    if viewController == viewControllers.last {
      return
    }

    isPushInProgress = true

    super.pushViewController(viewController, animated: animated)
    guard animated, let coordinator = transitionCoordinator else {
      DispatchQueue.main.async {
        self.isPushInProgress = false
        completion()
      }
      rootSetNeedsStatusBarAppearanceUpdate()
      return
    }

    coordinator.animate(alongsideTransition: nil) { [weak self] _ in
      self?.isPushInProgress = false
      completion()
    }
    rootSetNeedsStatusBarAppearanceUpdate()
  }

  @discardableResult
  open func pop(animated: Bool) -> UIViewController? {
    let popped = super.popViewController(animated: animated)
    rootSetNeedsStatusBarAppearanceUpdate()
    return popped
  }

  @discardableResult
  open func popToRoot(animated: Bool,
                      completion: (() -> Void)? = nil) -> [UIViewController]?
  {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    let popped = super.popToRootViewController(animated: animated)
    CATransaction.commit()
    rootSetNeedsStatusBarAppearanceUpdate()
    return popped
  }
}
