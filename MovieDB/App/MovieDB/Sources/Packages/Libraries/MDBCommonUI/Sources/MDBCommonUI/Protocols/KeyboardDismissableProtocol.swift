//
//  KeyboardDismissableProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public protocol KeyboardDismissableProtocol: UIViewController {
  func addKeyboardDismissGesture(ignoreViews: [UIView],
                                 handler: (() -> Void)?)
}

public extension KeyboardDismissableProtocol {
  func addKeyboardDismissGesture(ignoreViews: [UIView],
                                 handler: (() -> Void)?)
  {
    let gesture = TouchRecognizer(callback: { [weak self] in
      self?.view.endEditing(true)
      handler?()
    }, ignoreViews: ignoreViews)
    view.addGestureRecognizer(gesture)
  }
}
