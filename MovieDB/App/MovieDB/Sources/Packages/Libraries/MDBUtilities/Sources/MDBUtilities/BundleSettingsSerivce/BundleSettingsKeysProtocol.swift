//
//  BundleSettingsKeysProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// BundleSettings keys of UserDefaults
/// - Important: For each new variable you need to use `@obc dynamic` keywords to create dynamic key and keypath for it.
protocol BundleSettingsKeysProtocol {
  var environment: String? { get }
}
