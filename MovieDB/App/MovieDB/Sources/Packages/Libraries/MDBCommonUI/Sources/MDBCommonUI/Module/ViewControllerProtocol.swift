import UIKit

public protocol ViewControllerProtocol where Self: UIViewController {
  associatedtype InteractorInput
  associatedtype RoutingHandler

  var interactor: InteractorInput? { get set }
  var routingHandler: RoutingHandler? { get set }

  static func initFromNib(bundle: Bundle) -> Self
}

public extension ViewControllerProtocol {
  static func initFromNib(bundle: Bundle) -> Self {
    Self(nibName: String(describing: Self.self), bundle: bundle)
  }
}

public extension ViewControllerProtocol {
  func didGoBack() {
    (routingHandler as? ModuleRoutingHandlingProtocol)?.performRouteForBackRouting()
  }

  func didClose() {
    (routingHandler as? ModuleRoutingHandlingProtocol)?.performRouteForCloseRouting()
  }
}
