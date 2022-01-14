//
//  AppRoutingCalculator.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

import Combine
import Foundation
import MDBCommonUI
import MDBMain
import MDBServices

/// @mockable
/// Represents app's lvl routing calculator protocol.
public protocol AppRoutingCalculatorProtocol {
  /// Performs direct route by given deepLink.
  func directRoute(_ route: DeepLinks?) -> DeepLinks
  /// Performs route for next module after module that represents by given deepLink.
  func nextAfter(
    _ route: DeepLinks?
  ) -> AnyPublisher<DeepLinks, Never>

  func createOption(from output: ModuleOutputModelProtocol?) -> DeepLinks?
}

/// Represents app's lvl routing calculator protocol.
class AppRoutingCalculator: AppRoutingCalculatorProtocol {
  func directRoute(_ route: DeepLinks?) -> DeepLinks {
    guard let route = route else {
      return .main
    }

    return route
  }

  func nextAfter(
    _ route: DeepLinks?
  ) -> AnyPublisher<DeepLinks, Never> {
    Just(DeepLinks.main).eraseToAnyPublisher()
  }

  func createOption(from output: ModuleOutputModelProtocol?) -> DeepLinks? {
    nil
  }
}
