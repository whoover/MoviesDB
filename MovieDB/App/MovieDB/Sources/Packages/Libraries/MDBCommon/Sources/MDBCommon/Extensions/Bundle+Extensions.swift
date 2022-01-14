//
//  Bundle+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public extension Bundle {
  var appName: String {
    guard let name = object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String else {
      return ""
    }

    return name
  }
}
