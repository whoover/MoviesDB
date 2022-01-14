//
//  KeyboardConstraint.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public extension NSLayoutConstraint {
  func convertToKeyboardConstraint() -> KeyboardConstraint {
    .init(
      item: firstItem as Any,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem as Any,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant
    )
  }
}

public class KeyboardConstraint: NSLayoutConstraint {
  public var additionalIndent: CGFloat = 0
  public var originHeight: CGFloat = 0
  public var animatable: Bool = true

  override public init() {
    super.init()

    registerKeyboardNotifications()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard
      let userInfo = notification.userInfo as NSDictionary?,
      let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else {
      return
    }
    let keyboardSize = keyboardInfo.cgRectValue.size
//    let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    let bottomSafeAreaInset: CGFloat = 0
//    let bottomSafeAreaInset = keyWindow?.safeAreaInsets.bottom ?? 0
    constant = originHeight + keyboardSize.height + bottomSafeAreaInset + additionalIndent
    if animatable {
      animate(notification: notification)
    }
  }

  @objc
  private func keyboardWillHide(notification: NSNotification) {
    constant = originHeight
    if animatable {
      animate(notification: notification)
    }
  }

  private func animate(notification: NSNotification) {
    guard
      let userInfo = notification.userInfo,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
      let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
    else {
      return
    }
    let options = UIView.AnimationOptions(rawValue: curve.uintValue)
    UIView.animate(
      withDuration: TimeInterval(duration.doubleValue),
      delay: 0,
      options: options,
      animations: {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        keyWindow?.layoutIfNeeded()
      }
    )
  }
}
