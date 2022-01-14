//
//  UISegmentedControl+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public extension UISegmentedControl {
  func replaceSegments(segments: [String]) {
    removeAllSegments()
    for segment in segments {
      insertSegment(withTitle: segment, at: numberOfSegments, animated: false)
    }
  }
}
