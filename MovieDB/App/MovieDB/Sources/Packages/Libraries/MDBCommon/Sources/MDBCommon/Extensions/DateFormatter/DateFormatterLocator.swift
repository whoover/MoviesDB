//
//  DateFormatterLocator.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// @mockable
public protocol DateFormatterLocatorProtocol {
  func dateFormatter() -> DateFormatter
}

public extension DateFormatterLocatorProtocol {
  func dateFormatter() -> DateFormatter {
    DateFormatter()
  }
}
