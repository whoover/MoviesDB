//
//  URLSessionConfigurationProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public enum URLSessionConfigurationType {
  case sharedSession
  case `default`
  case ephemeral
}

public protocol URLSessionConfigurationProtocol {
  var configurationType: URLSessionConfigurationType { get }
  var cachePolicy: NSURLRequest.CachePolicy { get }
  var sessionIdentifier: String? { get }
}

public extension URLSessionConfigurationProtocol {
  var composedIdentifier: String {
    if let sessionIdentifier = sessionIdentifier {
      return sessionIdentifier
    }

    return String(describing: configurationType) + String(describing: cachePolicy)
  }
}
