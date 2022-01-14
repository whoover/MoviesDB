//
//  NSAttributedString+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import UIKit

public extension NSAttributedString {
  static func attributedText(
    image: UIImage,
    font: UIFont,
    string: String,
    color: UIColor
  ) -> NSAttributedString {
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = image
    imageAttachment.bounds = CGRect(
      x: 0,
      y: (font.capHeight - image.size.height).rounded() / 2,
      width: image.size.width,
      height: image.size.height
    )
    let imageString = NSAttributedString(attachment: imageAttachment)
    let attributedString = NSMutableAttributedString()
    attributedString.append(imageString)
    attributedString.append(NSAttributedString(string: string))
    attributedString.addAttributes(
      [
        .foregroundColor: color,
        .font: font
      ],
      range: NSRange(location: 0, length: attributedString.string.count)
    )

    return attributedString
  }
}
