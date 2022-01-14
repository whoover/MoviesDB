//
//  HTTPDefaultService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public final class HTTPDefaultService: NSObject, HTTPServiceProtocol {
  public var publicKeyValidator: PublicKeyValidatorProtocol
  public var ignoreSecurityCheck: Bool = false

  private lazy var hashSession: URLSession = {
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.timeoutIntervalForResource = 60
    sessionConfiguration.timeoutIntervalForRequest = 60
    return URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
  }()

  private let _reachabilityChangeSubject = PassthroughSubject<Bool, Never>()
  public var reachabilityChangePublisher: AnyPublisher<Bool, Never> {
    _reachabilityChangeSubject.eraseToAnyPublisher()
  }

  let reachabilityService: Reachability? = try? Reachability()
  private var sessionsContainers: [URLSessionContainer] = []

  deinit {
    reachabilityService?.stopNotifier()
  }

  public init(
    publicKeyValidator: PublicKeyValidatorProtocol
  ) {
    self.publicKeyValidator = publicKeyValidator
    super.init()

    setupReachabilityListeners()
  }

  public func isReachable() -> Bool {
    reachabilityService?.connection != .unavailable
  }

  public func hashTaskWith(url: URLRequest) -> AnyPublisher<Data, NetworkingError> {
    hashSession
      .dataTaskPublisher(for: url)
      .map(\.data)
      .anyPublisherWithMappedError(ofType: NetworkingError.self)
      .eraseToAnyPublisher()
  }

  public func httpTaskWith<Response, Decoder, Request>(
    request: Request,
    configurationType: URLSessionConfigurationType
  ) -> AnyPublisher<Data, Error>
    where Request: BaseHTTPRequest<Response, Decoder>,
    Response: BaseResponseProtocol,
    Decoder: CustomDecoder,
    Decoder.Decoder.Input == Data
  {
    let connectionConfiguration = connectionConfiguration(
      identifier: request.sessionIdentifier,
      configurationType: configurationType,
      workQueue: request.workQueue
    )

    let urlRequest: URLRequest

    do {
      urlRequest = try request.createBaseURLRequest()
    } catch {
      guard let networkingError = error as? NetworkingError else {
        return Fail(error: NetworkingError.genericError(with: error)).eraseToAnyPublisher()
      }
      return Fail(error: networkingError).eraseToAnyPublisher()
    }

    return urlSession(for: connectionConfiguration.sessionConfiguration)
      .dataTaskPublisher(for: urlRequest)
      .subscribe(on: connectionConfiguration.workQueue)
      .tryMap { data, response -> Data in
        guard let response = response as? HTTPURLResponse else {
          throw NetworkingError.badResponse
        }

        let httpStatus = HTTPResponseStatus(code: response.statusCode)
        if httpStatus != .success {
          guard var serverRequestError = try? request.decoder.decode(MessageResponseError.self, from: data) else {
            guard let errorModel = (request as? CustomErrorHandler)?.checkIfDataHasError(data) else {
              guard let errorModel = try? request.decoder.decode(HTTPGenericError.self, from: data) else {
                guard let errorModel = try? request.decoder.decode(ServerErrorsContainer.self, from: data) else {
                  throw NetworkingError.http(httpStatus, String(data: data, encoding: .utf8))
                }
                throw NetworkingError.serverError(errorModel)
              }
              throw NetworkingError.serverError(errorModel)
            }
            throw errorModel
          }
          serverRequestError.status = httpStatus
          serverRequestError.internalError = String(data: data, encoding: .utf8)
          throw ServerRequestError.serverResponse(serverRequestError)
        }

        return data
      }
      .eraseToAnyPublisher()
  }

  private func connectionConfiguration(
    identifier: String,
    configurationType: URLSessionConfigurationType,
    workQueue: DispatchQueue
  ) -> HTTPConnectionConfiguration {
    let sessionConfiguration = HTTPURLSessionConfiguration(
      configurationType: configurationType,
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      sessionIdentifier: identifier
    )

    return .init(sessionConfiguration: sessionConfiguration, workQueue: workQueue)
  }

  private func setupReachabilityListeners() {
    reachabilityService?.whenReachable = { [weak self] _ in
      self?._reachabilityChangeSubject.send(true)
    }

    reachabilityService?.whenUnreachable = { [weak self] _ in
      self?._reachabilityChangeSubject.send(false)
    }
    try? reachabilityService?.startNotifier()
  }
}

// MARK: - URLSession

private extension HTTPDefaultService {
  struct URLSessionContainer {
    let identifier: String
    let session: URLSession
  }

  func urlSession(for configuration: URLSessionConfigurationProtocol) -> URLSession {
    if let sessionContainer = sessionsContainers
      .first(where: { $0.identifier == configuration.composedIdentifier })
    {
      return sessionContainer.session
    }

    let session: URLSession

    switch configuration.configurationType {
    case .sharedSession:
      let urlconfig = URLSessionConfiguration.default
      urlconfig.timeoutIntervalForRequest = 60
      urlconfig.timeoutIntervalForResource = 60
      session = URLSession(configuration: urlconfig)
    case .default:
      let sessionConfiguration = URLSessionConfiguration.default
      sessionConfiguration.requestCachePolicy = configuration.cachePolicy
      sessionConfiguration.timeoutIntervalForRequest = 60
      sessionConfiguration.timeoutIntervalForResource = 60
      session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
    case .ephemeral:
      let sessionConfiguration = URLSessionConfiguration.ephemeral
      sessionConfiguration.timeoutIntervalForRequest = 60
      sessionConfiguration.timeoutIntervalForResource = 60
      session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: .current)
    }

    sessionsContainers.append(URLSessionContainer(identifier: configuration.composedIdentifier,
                                                  session: session))

    return session
  }
}

// MARK: - URLSessionDelegate

extension HTTPDefaultService: URLSessionDelegate {
  public func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    guard let serverTrust = challenge.protectionSpace.serverTrust else {
      return completionHandler(.performDefaultHandling, nil)
    }

    guard !ignoreSecurityCheck else {
      return completionHandler(.performDefaultHandling, nil)
    }

    if publicKeyValidator.validate(serverTrust: serverTrust, domain: challenge.protectionSpace.host) {
      let credential = URLCredential(trust: serverTrust)
      challenge.sender?.use(credential, for: challenge)
      completionHandler(.useCredential, credential)
    } else {
      completionHandler(.cancelAuthenticationChallenge, nil)
    }
  }
}
