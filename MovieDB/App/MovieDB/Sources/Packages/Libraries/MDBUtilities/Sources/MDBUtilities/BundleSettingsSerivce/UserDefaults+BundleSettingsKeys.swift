//
//  UserDefaults+BundleSettingsKeys.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBConstants

extension UserDefaults: BundleSettingsKeysProtocol {
  @objc
  dynamic
  var environment: String? {
    string(forKey: MDBConstants.UserDefaultsKeys.BundleSettings.environment.rawValue)
  }
}
