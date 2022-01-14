//
//  NetworkingStubService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine

public enum StubError: Error {
  case someError
}

public final class NetworkingStubService: NetworkingServiceProtocol {
  public var reachabilityChangePublisher: AnyPublisher<Bool, Never> {
    Just(isReachablePrivate).eraseToAnyPublisher()
  }

  var isReachablePrivate = false

  public func isReachable() -> Bool {
    isReachablePrivate
  }

  public let httpService: HTTPServiceProtocol? = nil

  public var delayTime: TimeInterval
  public var error: NetworkingError?

  public init(taskDelay: TimeInterval = 0.1, error: NetworkingError? = nil) {
    delayTime = taskDelay
    self.error = error
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
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    return Future { [unowned self] resolve in
      request.connectionConfiguration.workQueue.asyncAfter(deadline: .now() + self.delayTime) {
        guard
          let mock = (request.responseModelType as? MockModelReturnableProtocol.Type)?.mock() as? Response
        else {
          request.connectionConfiguration.resultQueue.async {
            resolve(.failure(NetworkingError.decodingFailed(StubError.someError)))
          }
          return
        }

        request.connectionConfiguration.resultQueue.async {
          resolve(.success(mock))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
