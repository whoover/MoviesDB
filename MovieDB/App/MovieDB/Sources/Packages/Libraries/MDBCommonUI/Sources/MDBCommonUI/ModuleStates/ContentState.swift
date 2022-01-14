//
//  ContentState.swift
//  MDBCommonUI
//
//

import UIKit

class ContentState: ContentStatable {
  private let containerView: UIView
  private let stateView: UIView

  init(containerView: UIView, stateView: UIView) {
    self.containerView = containerView
    self.stateView = stateView
  }

  func enterContentState() {
    containerView.addSubview(stateView)
    stateView.edgesToSuperview()
  }
}

protocol ContentStateHolderViewControllerProtocol: UIViewController {
  var contentStatable: ContentStatable { get }
}
