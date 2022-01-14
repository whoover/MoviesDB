//
//  FailureResponseModelProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol FailureResponseModelProtocol: Decodable {
  associatedtype ErrorsModels: Decodable

  var errors: ErrorsModels { get }
}

public struct MessageResponseError: FailureResponseModelProtocol {
  public struct MessageErrorData: Decodable, Equatable {
    public let message: String
  }

  public let errors: MessageErrorData
  public var status: HTTPResponseStatus?
  public var internalError: String?

  public var isTokenBlacklisted: Bool {
    errors.message == "Token is blacklisted"
  }

  public var isInvalidCredentials: Bool {
    errors.message == "Invalid credentials."
  }

  public var isTokenExpired: Bool {
    errors.message == "Token expired"
  }

  public var isUnauthorized: Bool {
    errors.message == "Unauthorized"
  }
}

public enum ServerRequestError<T: FailureResponseModelProtocol>: Error {
  case networking(NetworkingError)
  case serverResponse(T)
}
