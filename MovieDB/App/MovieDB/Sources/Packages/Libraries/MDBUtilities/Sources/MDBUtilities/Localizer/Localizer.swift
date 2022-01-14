//
//  Localizer.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import Foundation

public final class Localizer: LocalizerProtocol {
  @Published private var language: Language {
    didSet {
      userDefaults.setValue([language.rawValue], forKey: languageKey)
    }
  }

  public var currentLanguage: Language {
    language
  }

  public var languagePublisher: AnyPublisher<Language, Never> {
    $language.eraseToAnyPublisher()
  }

  public var l10n: L10n.Type {
    L10n.self
  }

  private let userDefaults: UserDefaultsProtocol
  private let languageKey = "AppleLanguages"

  public init(userDefaults: UserDefaultsProtocol) {
    self.userDefaults = userDefaults

    let preferredLanguages = Locale.preferredLanguages
      .compactMap { Locale(identifier: $0).languageCode }
      .compactMap { Language(rawValue: $0) }

    language = preferredLanguages.first ?? .english
  }

  public func change(language: Language) {
    self.language = language
  }
}

// MARK: - SwiftGen lookupFunction

extension L10n {
  static func localize(_ key: String, _ table: String) -> String {
    let language = Locale.autoupdatingCurrent.languageCode ?? Language.english.rawValue
    guard
      let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
      let bundle = Bundle(path: bundlePath)
    else {
      return ""
    }

    return bundle.localizedString(forKey: key, value: nil, table: table)
  }
}
