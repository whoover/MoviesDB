//
//  UIScreen+Additions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public extension UIScreen {
  static var safeAreaInsets: UIEdgeInsets {
    guard
      let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    else {
      return .zero
    }

    return keyWindow.safeAreaInsets
  }
}
