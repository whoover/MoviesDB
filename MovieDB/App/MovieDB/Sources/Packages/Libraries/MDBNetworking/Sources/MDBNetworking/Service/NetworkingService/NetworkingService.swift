//
//  NetworkingService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import MDBCommon

public final class NetworkingService: NetworkingServiceProtocol {
  public private(set) var httpService: HTTPServiceProtocol?
  public let httpUrlProvider: BaseUrlProvider
  public var reachabilityChangePublisher: AnyPublisher<Bool, Never> {
    httpService?.reachabilityChangePublisher ?? Just(false).eraseToAnyPublisher()
  }

  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  public init(
    httpService: HTTPServiceProtocol?,
    httpUrlProvider: BaseUrlProvider,
    ignoreSecurityCheck: Bool
  ) {
    self.httpService = httpService
    self.httpUrlProvider = httpUrlProvider
    self.httpService?.ignoreSecurityCheck = ignoreSecurityCheck
  }

  public func isReachable() -> Bool {
    httpService?.isReachable() ?? false
  }

  public func httpTaskWith<Response, Decoder, Request>(
    request: Request,
    configurationType: URLSessionConfigurationType
  ) -> AnyPublisher<Response, Error>
    where Request: BaseHTTPRequest<Response, Decoder>,
    Response: BaseResponseProtocol,
    Decoder: CustomDecoder,
    Decoder.Decoder.Input == Data
  {
    request.baseUrlProvider = httpUrlProvider

    guard let httpService = httpService else {
      return Fail(error: NetworkingError.httpServiceNilError).eraseToAnyPublisher()
    }

    return httpService.httpTaskWith(request: request)
      .decode(type: Response.self, decoder: request.decoder)
      .mapError {
        switch $0 {
        case is DecodingError:
          return NetworkingError.decodingFailed($0)
        case let error as NetworkingError:
          return error
        default:
          return $0
        }
      }
      .receive(on: request.connectionConfiguration.resultQueue)
      .eraseToAnyPublisher()
  }
}
