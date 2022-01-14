//
//  BundleSettingsServiceProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// BundleSettings Service
/// @mockable
public protocol BundleSettingsServiceProtocol {
  /// `environment`  sequance of `Environment` objects
  var environment: AnyPublisher<MovieDBEnvironment, Never> { get }
}
