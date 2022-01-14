//
//  UIView+Add.swift
//  MDBCommonUI
//
//

import UIKit

public extension UIViewController {
  @discardableResult
  func add(to controller: UIViewController) -> Self {
    controller.addChildController(self) { _ in }
    return self
  }
}

public extension UIView {
  @discardableResult
  func add(to superview: UIView) -> Self {
    superview.addSubview(self)
    return self
  }

  @discardableResult
  func insert(to superview: UIView, at index: Int) -> Self {
    superview.insertSubview(self, at: index)
    return self
  }

  @discardableResult
  func insert(to superview: UIView, above view: UIView) -> Self {
    superview.insertSubview(self, aboveSubview: view)
    return self
  }

  @discardableResult
  func insert(to superview: UIView, below view: UIView) -> Self {
    superview.insertSubview(self, belowSubview: view)
    return self
  }

  @discardableResult
  func add(to stackview: UIStackView) -> Self {
    stackview.addArrangedSubview(self)
    return self
  }

  @discardableResult
  func insert(to stackview: UIStackView, at index: Int) -> Self {
    stackview.insertArrangedSubview(self, at: index)
    return self
  }

  convenience init(size: CGSize) {
    self.init(frame: CGRect(origin: CGPoint.zero, size: size))
  }
}

public extension UIView {
  func removeAllConstraintsDownInHierarchy() {
    removeSelfConstraints()
    let subviews: [UIView] = findAll()
    subviews.forEach { $0.removeSelfConstraints() }
  }

  func removeSelfConstraints() {
    var superview = superview
    while let notOptionalSuperview = superview {
      for constraint in notOptionalSuperview.constraints {
        if let firstItem = constraint.firstItem as? NSObject,
           firstItem == self
        {
          notOptionalSuperview.removeConstraint(constraint)
        } else if let secondItem = constraint.secondItem as? NSObject,
                  secondItem == self
        {
          notOptionalSuperview.removeConstraint(constraint)
        }
      }
      superview = superview?.superview
    }
    removeConstraints(constraints)
    translatesAutoresizingMaskIntoConstraints = true
  }
}

public extension UIView {
  func pauseLayerAnimations() {
    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
    layer.speed = 0.0
    layer.timeOffset = pausedTime
  }

  func resumeLayerAnimations() {
    let pausedTime = layer.timeOffset
    layer.speed = 1.0
    layer.timeOffset = 0.0
    layer.beginTime = 0.0
    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    layer.beginTime = timeSincePause
  }
}
