//
//  UIButton+Common.swift
//  MDBCommonUI
//
//

import UIKit

/// Extension to `UIButton` that helps set some background color for specified state.
public extension UIButton {
  func set(backgroundColor: UIColor, for state: UIControl.State) {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(backgroundColor.cgColor)
    context?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    setBackgroundImage(image, for: state)
  }

  func set(image: UIImage?) {
    setImage(image, for: .normal)
    setImage(image?.alpha(0.5), for: .highlighted)
  }
}
