//
//  UILabel+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import UIKit

public extension UILabel {
  var textWidth: CGFloat {
    intrinsicContentSize.width
  }

  var textHeight: CGFloat {
    intrinsicContentSize.height
  }

  var optimalFontSize: CGFloat {
    calculateFontSize(width: frame.width, fontSize: font.pointSize)
  }

  func calculateFontSize(width: CGFloat, fontSize: CGFloat) -> CGFloat {
    guard width > 0.0 else {
      return 0.0
    }

    return autoreleasepool { () -> CGFloat in
      let label = UILabel()
      label.text = text
      label.font = .systemFont(ofSize: fontSize)

      if label.textWidth > width {
        return calculateFontSize(width: width, fontSize: fontSize - 1)
      }
      return fontSize
    }
  }
}
