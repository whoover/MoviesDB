//
//  Animatable.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// Key for storing animations in layer typealias of `String`
public typealias AnimatableKey = String

/// Animatable struct grouping animation methods
public struct Animatable<Component> {
  private let component: Component

  public init(_ component: Component) {
    self.component = component
  }
}

public extension Animatable where Component: UIView {
  /// Create and run rotating animation by `z` axis
  /// - Parameters:
  ///   - duration: duration time of animation. Default value is - `10`
  ///   - angle: angle of ending animation. Default value is - `Double.pi * 2`
  ///   - repeatCount: repeat count of animation. Default value is - `infinity`
  ///   - timing: timing function name. Default value is - `default`
  /// - Returns: key of animation. As `function name + UUID`
  @discardableResult
  func rotate(
    duration: Double = 10,
    angle: Double = Double.pi * 2,
    repeatCount: Float = .infinity,
    timing: CAMediaTimingFunctionName = .default
  ) -> AnimatableKey {
    let key = #function + UUID().uuidString
    let rotation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
    rotation.valueFunction = CAValueFunction(name: .rotateZ)
    rotation.timingFunction = CAMediaTimingFunction(name: timing)
    rotation.fromValue = NSNumber(value: 0)
    rotation.toValue = NSNumber(value: angle)
    rotation.duration = duration
    rotation.isCumulative = true
    rotation.repeatCount = repeatCount
    rotation.isRemovedOnCompletion = false

    component.layer.add(rotation, forKey: key)
    return key
  }

  /// Animation for fading component
  /// - Parameters:
  ///   - duration: Duration time of animation. Default value is - `0.1`
  ///   - fromColor: Color from which to start fading. Default value is `clear`
  ///   - toColor: Color from which to end fading. Default value is `clear`
  ///   - fillMode: Determines if the receiver’s presentation is frozen or removed once its active duration has completed.. Default value is - `forwards`
  ///   - isRemovedOnCompletion: Determines if the animation is removed upon completion. Default value is - `true`
  /// - Returns: key of animation. As `function name + UUID`
  @discardableResult
  func fade(
    duration: Double = 0.1,
    fromColor: UIColor = .clear,
    toColor: UIColor = .black.withAlphaComponent(0.25),
    fillMode: CAMediaTimingFillMode = .forwards,
    isRemovedOnCompletion _: Bool = false
  ) -> AnimatableKey {
    let key = #function + UUID().uuidString

    let colorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
    colorAnimation.duration = duration
    colorAnimation.fromValue = fromColor.cgColor
    colorAnimation.toValue = toColor.cgColor
    colorAnimation.fillMode = fillMode
    colorAnimation.isRemovedOnCompletion = false

    component.layer.add(colorAnimation, forKey: key)

    return key
  }

  /// Remove animation by animation key
  /// - Parameter key: key of animation
  func remove(_ key: AnimatableKey) {
    component.layer.removeAnimation(forKey: key)
  }

  /// Remove all animation of current component layer
  func removeAll() {
    component.layer.removeAllAnimations()
  }
}
