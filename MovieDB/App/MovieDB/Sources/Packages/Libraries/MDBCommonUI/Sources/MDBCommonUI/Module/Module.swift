import UIKit

public struct Module<Input, Output>: PresentableProtocol {
  public var view: UIViewController

  public var input: Input
  public var output: WeakContainer<Output>?

  public init(view: UIViewController, input: Input, output: Output?) {
    self.view = view

    self.input = input
    if let output = output {
      self.output = WeakContainer(value: output)
    }
  }

  public func toPresent() -> UIViewController? {
    view
  }
}
