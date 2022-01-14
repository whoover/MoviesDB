//
//  GradientLabel.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import Foundation
import MDBCommonUI
import SwiftUI
import UIKit

public enum LabelGradientDirection {
  case top
  case topLeft
  case topRight
  case left
  case right
}

public class GradientLabel: UILabel {
  public var gradientColors: MDBCommonUI.Gradient = (.clear, .clear)

  override public func drawText(in rect: CGRect) {
    if let gradientImage = gradientImage(
      size: rect.size,
      color1: colorToRGB(uiColor: gradientColors.0),
      color2: colorToRGB(uiColor: gradientColors.1.withAlphaComponent(0.7)),
      direction: .right
    ) {
      textColor = UIColor(patternImage: gradientImage)
    }

    super.drawText(in: rect)
  }

  func colorToRGB(uiColor: UIColor) -> CIColor {
    CIColor(color: uiColor)
  }

  func gradientImage(
    size: CGSize,
    color1: CIColor,
    color2: CIColor,
    direction: LabelGradientDirection = .topRight
  ) -> UIImage? {
    let context = CIContext(options: nil)
    guard let filter = CIFilter(name: "CILinearGradient") else {
      return nil
    }
    var startVector: CIVector
    var endVector: CIVector

    filter.setDefaults()

    switch direction {
    case .top:
      startVector = CIVector(x: size.width * 0.5, y: 0)
      endVector = CIVector(x: size.width * 0.5, y: size.height)
    case .left:
      startVector = CIVector(x: size.width, y: size.height * 0.5)
      endVector = CIVector(x: 0, y: size.height * 0.5)
    case .topLeft:
      startVector = CIVector(x: size.width, y: 0)
      endVector = CIVector(x: 0, y: size.height)
    case .topRight:
      startVector = CIVector(x: 0, y: 0)
      endVector = CIVector(x: size.width, y: size.height)
    case .right:
      startVector = CIVector(x: 0, y: size.height)
      endVector = CIVector(x: size.width / 2, y: 0)
    }

    filter.setValue(startVector, forKey: "inputPoint0")
    filter.setValue(endVector, forKey: "inputPoint1")
    filter.setValue(color1, forKey: "inputColor0")
    filter.setValue(color2, forKey: "inputColor1")

    guard let outputImage = filter.outputImage,
          let cgImage = context.createCGImage(
            outputImage,
            from: CGRect(x: 0, y: 0, width: size.width, height: size.height)
          )
    else {
      return nil
    }

    let image = UIImage(cgImage: cgImage)
    return image
  }
}
