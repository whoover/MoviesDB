import MDBCommonUI
import MDBComponents
import MDBMain
import MDBUtilities
import UIKit

/// Root router class. Represents UI level abstraction that can run different navigations.
final class RootRouter: BaseCoordinatorRouter {
  /// Main app's window.
  private var window: UIWindow?
  private var networkingAlert: InternetConnectionView?
  private var networkingAlertBottomConstraint: NSLayoutConstraint?

  override init(_ rootViewController: UIViewController = RootViewController()) {
    super.init(rootViewController)

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }

  public func showNetworkingAlert(text: String, theme: NetworkingAlertProtocol) {
    guard let window = window, networkingAlert == nil else {
      return
    }

    let networkingAlert = InternetConnectionView()
    networkingAlert.add(to: window).do {
      $0.setup(theme: theme)
      $0.setupText(text)
      self.networkingAlertBottomConstraint = $0.topToSuperview(offset: -72)
      $0.leftToSuperview()
      $0.rightToSuperview()
      self.networkingAlert = networkingAlert
      window.bringSubviewToFront($0)
    }

    networkingAlert.layoutIfNeeded()
    window.layoutIfNeeded()

    UIView.animate(withDuration: 0.5) {
      self.networkingAlertBottomConstraint?.constant = 0
      networkingAlert.layoutIfNeeded()
      window.layoutIfNeeded()
    }
  }

  public func hideNetworkingAlert() {
    guard networkingAlert != nil else {
      return
    }

    UIView.animateKeyframes(withDuration: 0.5, delay: 0, animations: {
      self.networkingAlertBottomConstraint?.constant = -72
      self.networkingAlert?.layoutIfNeeded()
      self.window?.layoutIfNeeded()
    }, completion: { _ in
      self.networkingAlert?.removeFromSuperview()
      self.networkingAlert = nil
    })
  }
}

/// Represents root view controller instance that uses preferred status bar style from it's top child.
final class RootViewController: UIViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    childForStatusBarStyle?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
  }

  override var childForStatusBarStyle: UIViewController? {
    var topController: UIViewController = self
    while let presentedViewController = topController.presentedViewController,
          !(presentedViewController is UIAlertController),
          !presentedViewController.isBeingDismissed
    {
      topController = presentedViewController
    }

    topController = topController.children.last?.topMostViewController() ??
      topController.topMostViewController()

    return (topController !== self) ? topController : children.first
  }
}

extension UIViewController {
  func topMostViewController() -> UIViewController {
    if let presented = presentedViewController {
      return presented.topMostViewController()
    }

    if let navigation = self as? UINavigationController {
      return navigation.visibleViewController?.topMostViewController() ?? navigation
    }

    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostViewController() ?? tab
    }

    return self
  }
}
