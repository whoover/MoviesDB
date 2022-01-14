//
//  HTTPServiceProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// @mockable
public protocol HTTPServiceProtocol {
  var ignoreSecurityCheck: Bool { get set }
  var reachabilityChangePublisher: AnyPublisher<Bool, Never> { get }

  func isReachable() -> Bool

  func httpTaskWith<Response, Decoder, Request>(
    request: Request,
    configurationType: URLSessionConfigurationType
  ) -> AnyPublisher<Data, Error>
    where Request: BaseHTTPRequest<Response, Decoder>,
    Response: BaseResponseProtocol,
    Decoder: CustomDecoder,
    Decoder.Decoder.Input == Data

  func hashTaskWith(url: URLRequest) -> AnyPublisher<Data, NetworkingError>
}

public extension HTTPServiceProtocol {
  func httpTaskWith<Response, Decoder, Request>(
    request: Request
  ) -> AnyPublisher<Data, Error>
    where Request: BaseHTTPRequest<Response, Decoder>,
    Response: BaseResponseProtocol,
    Decoder: CustomDecoder,
    Decoder.Decoder.Input == Data
  {
    httpTaskWith(
      request: request,
      configurationType: .default
    )
  }
}
