//
//  LocalizableProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// A type that can be localized
public protocol LocalizableProtocol {
  /// Localization method
  /// - Parameter l10n: Type of localization structure
  func localize(with l10n: L10n.Type)
}
