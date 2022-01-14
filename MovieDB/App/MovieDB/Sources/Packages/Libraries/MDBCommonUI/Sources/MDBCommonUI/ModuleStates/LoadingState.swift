import UIKit

class LoadingState<LoadingStateView: LoadingViewProtocol>: LoadingStatable {
  private let containerView: UIView
  private let stateViewType: LoadingStateView.Type

  init(containerView: UIView, stateViewType: LoadingStateView.Type) {
    self.containerView = containerView
    self.stateViewType = stateViewType
  }

  func enterLoadingState(_ string: String) {
    let stateView = stateViewType.init()
    containerView.addSubview(stateView)
    stateView.edgesToSuperview()
    stateView.startLoading(string)
  }
}

protocol LoadingStateHolderViewControllerProtocol: UIViewController {
  var loadingStatable: LoadingStatable { get }
}

protocol LoadingViewProtocol: UIView {
  func startLoading(_ text: String)
  func stopLoading()
}
