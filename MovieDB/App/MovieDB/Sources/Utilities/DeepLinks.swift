//
//  DeepLinks.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBCommonUI
import MDBMain

/// Application's lvl deep links
public enum DeepLinks: DeepLinkOptionProtocol {
  /// to main flow
  case main
}

public extension DeepLinks {
  enum UrlPaths {
    case some

    public init?(paths: [String]) {
      guard !paths.isEmpty else {
        return nil
      }

      return nil
    }
  }

  static func create(from url: URL) -> UrlPaths? {
    guard let host = url.host else {
      return nil
    }

    return UrlPaths(paths: createUrlPaths(host: host, path: url.path))
  }

  private static func createUrlPaths(host: String, path: String) -> [String] {
    (host + path).components(separatedBy: "/")
  }
}

extension DeepLinks: Equatable {
  public static func == (
    lhs: DeepLinks,
    rhs: DeepLinks
  ) -> Bool {
    switch (lhs, rhs) {
    case (.main, .main):
      return true
    }
  }
}
