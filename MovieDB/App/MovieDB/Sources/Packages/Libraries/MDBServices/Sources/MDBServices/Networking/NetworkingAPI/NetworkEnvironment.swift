//
//  NetworkEnvironment.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBConstants
import MDBUtilities

public enum NetworkEnvironment {
  case dev
  case production

  public var baseUrl: String {
    switch self {
    case .dev:
      return "api.themoviedb.org"
    case .production:
      return "api.themoviedb.org"
    }
  }

  public static func environmentForScheme(
    _ scheme: AppScheme,
    environment: MovieDBEnvironment
  ) -> NetworkEnvironment {
    guard scheme == .debug ||
      scheme == .uiTests
    else {
      switch scheme {
      case .debug, .uiTests:
        return .dev
      case .release:
        return .production
      }
    }

    switch environment {
    case .debug, .dev:
      return .dev
    case .prod:
      return .production
    }
  }
}
