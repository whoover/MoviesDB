//
//  UIStackView+RemoveAll.swift
//  MDBCommonUI
//
//

import UIKit

/// Extension to `UIStackView` that allows to remove all arranged subviews.
public extension UIStackView {
  func removeAllArrangedSubviews() {
    let removedSubviews = arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }
    NSLayoutConstraint.deactivate(removedSubviews.flatMap(\.constraints))
    removedSubviews.forEach { $0.removeFromSuperview() }
  }
}
