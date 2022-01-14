import UIKit

class EmptyState<EmptyStateView: EmptyViewProtocol>: EmptyStatable {
  private let containerView: UIView
  private let stateViewType: EmptyStateView.Type

  init(containerView: UIView, stateViewType: EmptyStateView.Type) {
    self.containerView = containerView
    self.stateViewType = stateViewType
  }

  func enterEmptyState(_ string: String) {
    let stateView = stateViewType.init()
    containerView.addSubview(stateView)
    stateView.edgesToSuperview()
    stateView.setup(string)
  }
}

protocol EmpyStateHolderViewControllerProtocol: UIViewController {
  var emptyStatable: EmptyStatable { get }
}

protocol EmptyViewProtocol: UIView {
  func setup(_ text: String)
}
