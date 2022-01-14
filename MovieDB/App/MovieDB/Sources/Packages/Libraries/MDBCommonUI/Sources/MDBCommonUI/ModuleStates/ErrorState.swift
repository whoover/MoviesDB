import UIKit

class ErrorState<ErrorStateView: ErrorViewProtocol>: ErrorStatable {
  private let containerView: UIView
  private let stateViewType: ErrorStateView.Type

  init(containerView: UIView, stateViewType: ErrorStateView.Type) {
    self.containerView = containerView
    self.stateViewType = stateViewType
  }

  func enterErrorState(_ error: Error) {
    let stateView = stateViewType.init()
    containerView.addSubview(stateView)
    stateView.edgesToSuperview()
    stateView.setup(error)
  }
}

protocol ErrorStateHolderViewControllerProtocol: UIViewController {
  var errorStatable: ErrorStatable { get }
}

protocol ErrorViewProtocol: UIView {
  func setup(_ error: Error)
}
