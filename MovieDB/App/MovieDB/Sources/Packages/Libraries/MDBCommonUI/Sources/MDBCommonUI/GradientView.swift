//
//  GradientView.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import SwiftUI
import UIKit

public typealias GradientDirection = (CGPoint, CGPoint)
public typealias Gradient = (UIColor, UIColor)

/// View with gradient background
public class GradientView: UIView {
  public var startPoint: CGPoint {
    get { gradient.startPoint }
    set { gradient.startPoint = newValue }
  }

  public var endPoint: CGPoint {
    get { gradient.endPoint }
    set { gradient.endPoint = newValue }
  }

  public var colors: [UIColor] = [] {
    willSet {
      gradient.colors = newValue.map(\.cgColor)
    }
  }

  public var type: CAGradientLayerType {
    get { gradient.type }
    set { gradient.type = newValue }
  }

  public var locations: [NSNumber]? {
    get { gradient.locations }
    set { gradient.locations = newValue }
  }

  override public class var layerClass: AnyClass {
    CAGradientLayer.self
  }

  lazy var gradient: CAGradientLayer = layer as? CAGradientLayer ?? CAGradientLayer()

  public init() {
    super.init(frame: .zero)
    setupGradient()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupGradient()
  }

  private func setupGradient() {
    startPoint = CGPoint(x: 0.0, y: 0.5)
    endPoint = CGPoint(x: 1.0, y: 0.5)
  }
}

public extension GradientView {
  func setup(theme: Gradient) {
    colors = [theme.0, theme.1]
  }

  func setup(theme: [UIColor]) {
    colors = theme
  }
}
