//
//  LocalizerProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// @mockable
/// Localizer service for handling localization strings and current language in realtime
public protocol LocalizerProtocol {
  /// A value representing current language of application
  var currentLanguage: Language { get }

  /// A publisher of current language of app
  var languagePublisher: AnyPublisher<Language, Never> { get }

  /// Tree structure for getting localizable strings
  var l10n: L10n.Type { get }

  /// Change current language of application
  func change(language: Language)
}
