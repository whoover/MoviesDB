//
//  UIScrollView+Paging.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public extension UIScrollView {
  var currentPage: Int {
    guard frame.width > 0 else {
      return 0
    }
    return Int((contentOffset.x + (0.5 * frame.width)) / frame.width)
  }
}
