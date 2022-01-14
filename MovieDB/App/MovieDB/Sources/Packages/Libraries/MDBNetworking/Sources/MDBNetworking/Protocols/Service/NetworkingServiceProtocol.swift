//
//  NetworkingServiceProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// @mockable
public protocol NetworkingServiceProtocol {
  var httpService: HTTPServiceProtocol? { get }
  var reachabilityChangePublisher: AnyPublisher<Bool, Never> { get }

  func isReachable() -> Bool

  func httpTaskWith<Response, Decoder, Request>(
    request: Request,
    configurationType: URLSessionConfigurationType
  ) -> AnyPublisher<Response, Error>
    where Request: BaseHTTPRequest<Response, Decoder>,
    Response: BaseResponseProtocol,
    Decoder: CustomDecoder,
    Decoder.Decoder.Input == Data
}
