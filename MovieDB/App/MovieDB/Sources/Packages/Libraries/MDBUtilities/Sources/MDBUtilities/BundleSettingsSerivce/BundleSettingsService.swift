//
//  BundleSettingsService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public final class BundleSettingsService: BundleSettingsServiceProtocol {
  private let userDefaults: UserDefaultsProtocol
  private let schemeService: SchemeServiceProtocol

  private let unknownValue = "unknown"

  public var environment: AnyPublisher<MovieDBEnvironment, Never> {
    userDefaults.publisher(for: \.environment)
      .compactMap { $0 }
      .compactMap { MovieDBEnvironment(rawValue: $0) }
      .eraseToAnyPublisher()
  }

  private var subscriptions = Set<AnyCancellable>()

  public init(userDefaults: UserDefaultsProtocol, schemeService: SchemeServiceProtocol) {
    self.userDefaults = userDefaults
    self.schemeService = schemeService
    registerDefaults()

    registerDefaultEnvironment()
    setVersion()
    setScheme()
  }

  private func registerDefaults() {
    let rootPlist = "Root.plist"
    let settingsName = "Settings"
    let settingsExtension = "bundle"
    let settingsPreferencesItems = "PreferenceSpecifiers"
    let settingsPreferenceKey = "Key"
    let settingsPreferenceDefaultValue = "DefaultValue"

    guard let settingsBundleURL = Bundle.main.url(forResource: settingsName, withExtension: settingsExtension),
          let settingsData = try? Data(contentsOf: settingsBundleURL.appendingPathComponent(rootPlist)),
          let settingsPlist = try? PropertyListSerialization.propertyList(
            from: settingsData,
            options: [],
            format: nil
          ) as? [String: Any],
          let settingsPreferences = settingsPlist[settingsPreferencesItems] as? [[String: Any]]
    else {
      return
    }

    var defaultsToRegister = [String: Any]()

    settingsPreferences.forEach { preference in
      if let key = preference[settingsPreferenceKey] as? String {
        defaultsToRegister[key] = preference[settingsPreferenceDefaultValue]
      }
    }

    userDefaults.register(defaults: defaultsToRegister)
  }

  private func setVersion() {
    let version = Bundle.main.releaseVersionNumber ?? unknownValue
    let build = Bundle.main.buildVersionNumber ?? unknownValue
    userDefaults.setValue("\(version) (\(build))", forKey: "movie-db_version")
  }

  private func setScheme() {
    userDefaults.setValue(schemeService.currentScheme.rawValue, forKey: "movie-db_scheme")
  }

  private func registerDefaultEnvironment() {
    let key = "environment"
    let environment = userDefaults.getValue(forKey: key) as? String

    guard environment == unknownValue else {
      return
    }

    userDefaults.setValue(schemeService.currentScheme.rawValue, forKey: "environment")
  }
}

public extension Bundle {
  var releaseVersionNumber: String? {
    infoDictionary?["CFBundleShortVersionString"] as? String
  }

  var buildVersionNumber: String? {
    infoDictionary?["CFBundleVersion"] as? String
  }

  var releaseVersionNumberPretty: String {
    "v\(releaseVersionNumber ?? "1.0.0")"
  }
}
