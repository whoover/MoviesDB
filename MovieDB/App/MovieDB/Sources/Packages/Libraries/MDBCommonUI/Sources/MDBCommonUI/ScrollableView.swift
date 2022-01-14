//
//  ScrollableView.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public class ScrollableView: UIScrollView {
  /// Extra padding for scroll. Scroll height equal to 'keyboard.height + additionalScrollIndet'
  public var additionalIndent: CGFloat = 0

  public var keyboardHeight: CGFloat = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    registerKeyboardNotifications()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    registerKeyboardNotifications()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  @objc
  func keyboardWillShow(notification: NSNotification) {
    guard let userInfo: NSDictionary = notification.userInfo as NSDictionary?,
          let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else {
      return
    }
    let keyboardSize = keyboardInfo.cgRectValue.size
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + additionalIndent, right: 0)
    contentInset = contentInsets
    scrollIndicatorInsets = contentInsets

    keyboardHeight = keyboardSize.height
  }

  @objc
  func keyboardWillHide(notification _: NSNotification) {
    contentInset = .zero
    scrollIndicatorInsets = .zero
  }

  func scrollTo(view: UIView) {
    setContentOffset(CGPoint(x: 0, y: view.frame.maxY - frame.height + keyboardHeight), animated: true)
  }
}
