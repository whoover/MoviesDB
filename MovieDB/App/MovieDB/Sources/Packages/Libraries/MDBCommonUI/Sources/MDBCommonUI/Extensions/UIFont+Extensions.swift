//
//  UIFont+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public extension UIFont {
  func adoptFontIfNeeded(minSize: CGFloat = 10) -> UIFont {
    let screenHeight = UIScreen.main.nativeBounds.height
    let iPhone12ScreenHeight = 2532.0
    if screenHeight < iPhone12ScreenHeight {
      var newSize = CGFloat(ceilf(Float(pointSize * screenHeight / iPhone12ScreenHeight)))
      if newSize < minSize {
        newSize = minSize
      }
      return UIFont.systemFont(
        ofSize: newSize,
        weight: weight
      )
    }
    return self
  }

  var weight: UIFont.Weight {
    guard let weightNumber = traits[.weight] as? NSNumber else {
      return .regular
    }
    let weightRawValue = CGFloat(weightNumber.doubleValue)
    let weight = UIFont.Weight(rawValue: weightRawValue)
    return weight
  }

  private var traits: [UIFontDescriptor.TraitKey: Any] {
    fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
      ?? [:]
  }
}

public protocol AnyNumberProtocol {
  func adoptSizeIfNeeded(minSize: CGFloat) -> CGFloat
}

extension CGFloat: AnyNumberProtocol {
  public func adoptSizeIfNeeded(minSize: CGFloat = 10) -> CGFloat {
    let screenHeight = UIScreen.main.nativeBounds.height
    let iPhone12ScreenHeight = 2532.0
    if screenHeight < iPhone12ScreenHeight {
      var newSize = CGFloat(ceilf(Float(self * screenHeight / iPhone12ScreenHeight)))
      if newSize < minSize {
        newSize = minSize
      }
      return newSize
    }
    return self
  }
}

extension Int: AnyNumberProtocol {
  public func adoptSizeIfNeeded(minSize: CGFloat = 10) -> CGFloat {
    CGFloat(self).adoptSizeIfNeeded(minSize: minSize)
  }
}

extension Double: AnyNumberProtocol {
  public func adoptSizeIfNeeded(minSize: CGFloat = 10) -> CGFloat {
    CGFloat(self).adoptSizeIfNeeded(minSize: minSize)
  }
}
