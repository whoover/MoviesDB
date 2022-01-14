import UIKit

/// @mockable
public protocol PresentableProtocol {
  func toPresent() -> UIViewController?
}

public extension PresentableProtocol {
  func lastPresentedController() -> UIViewController? {
    var controller = toPresent()
    while controller?.presentedViewController != nil {
      controller = controller?.presentedViewController
    }
    return controller
  }
}

extension UIViewController: PresentableProtocol {
  public func toPresent() -> UIViewController? {
    self
  }
}
