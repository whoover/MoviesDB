//
//  UIColor+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public extension UIColor {
  var inverted: UIColor {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
  }

  private convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
    self.init(
      red: CGFloat(red) / 255.0,
      green: CGFloat(green) / 255.0,
      blue: CGFloat(blue) / 255.0,
      alpha: alpha
    )
  }

  convenience init(rgb: Int, alpha: CGFloat = 1.0) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF,
      alpha: alpha
    )
  }
}
