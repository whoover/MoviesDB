//
//  HTTPResponseStatus.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public enum HTTPResponseStatus: String, Decodable {
  case success
  case unathorized
  case badRequest
  case tokenExpired
  case urlNotFound
  case methodNotAllowed
  case validationException
  case sessionExpired
  case serverUnavailable
  case unknown

  init(code: Int) {
    switch code {
    case 200 ..< 300:
      self = .success
    case 400:
      self = .badRequest
    case 401:
      self = .unathorized
    case 403:
      self = .tokenExpired
    case 404:
      self = .urlNotFound
    case 405:
      self = .methodNotAllowed
    case 410:
      self = .sessionExpired
    case 422:
      self = .validationException
    case 500 ..< 600:
      self = .serverUnavailable
    default:
      self = .unknown
    }
  }
}

public enum NetworkingError: Error, GenericError {
  case httpServiceNilError
  case socketServiceNilError

  case encodingFailed
  case decodingFailed(Error)

  case missingUrl
  case badResponse

  case http(HTTPResponseStatus, String?)
  case serverError(ServerErrorProtocol)

  case generic(Error)

  public static func genericError(with error: Error) -> NetworkingError {
    NetworkingError.generic(error)
  }
}

public protocol ServerErrorProtocol: Decodable {}

public struct HTTPGenericError: ServerErrorProtocol {
  public let status: String
  public let errorCode: Int
  public let errorText: String
}

public struct ServerErrorsContainer: ServerErrorProtocol {
  let code: Int
  let errors: [MessageError]

  public struct MessageError: Decodable {
    let message: String
  }
}
