//
//  BundleSettingsItems.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// Represents cases of environment which can be chosen from `Settings` of Application
public enum MovieDBEnvironment: String, CaseIterable {
  /// Production environment
  case prod

  /// Stage environment
  case dev

  /// Debug environment
  case debug
}
