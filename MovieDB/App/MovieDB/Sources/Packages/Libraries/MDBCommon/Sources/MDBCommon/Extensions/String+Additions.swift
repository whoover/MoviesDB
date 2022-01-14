//
//  String+Additions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import UIKit

/// Custom String methods
public extension String {
  /// Removes all whitespaces and newlines and returns new value
  func removeWhitespacesAndNewlines() -> String {
    let characterSet = CharacterSet.whitespacesAndNewlines
    return components(separatedBy: characterSet).joined()
  }
}
