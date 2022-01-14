@_exported import MDBServices

public class DataInteractorProtocolMock: DataInteractorProtocol {
  public private(set) var resetCacheCallCout = 0
  public var resetCacheHandler: (() -> Void)?
  public func resetCache() {
    resetCacheCallCout += 1
    if let resetCacheHandler = resetCacheHandler {
      return resetCacheHandler()
    }
    fatalError("resetCacheHandler returns can't have a default value thus its handler must be set")
  }

  public func publisher<Request, Response, Decoder>(for request: Request, fetchingStrategy: FetchingStrategy) -> AnyPublisher<Response?, DataInteractorError>
    where Request: BaseSocketRequest<Response, Decoder>, Response: BaseSocketResponseProtocol, Decoder: CustomDecoder, Decoder.Input == Data
  {
    Just(nil).setFailureType(
      to: DataInteractorError.self
    ).eraseToAnyPublisher()
  }

  public var reachabilityChangeSubscriber = PassthroughSubject<Bool, Never>()
  public var reachabilityChangePublisher: AnyPublisher<Bool, Never> {
    reachabilityChangeSubscriber.eraseToAnyPublisher()
  }

  public var _isReachable = true
  public func isReachable() -> Bool {
    _isReachable
  }

  public init() {}

  public private(set) var publisherCallCount = 0
  public var publisherHandler: ((Any, FetchingStrategy) -> (Any))?
  public func publisher<Response, Decoder, Request, Result>(for request: Request,
                                                            fetchingStrategy: FetchingStrategy) -> AnyPublisher<[Result], DataInteractorError>
    where Request: BaseHTTPRequest<Response, Decoder> & HTTPRequestProtocol,
    Result == Request.RuntimeModelType,
    Response: BaseResponseProtocol,
    Decoder: CustomDecoder,
    Decoder.Input == Data,
    Decoder.Decoder.Input == Data
  {
    publisherCallCount += 1
    if let publisherHandler = publisherHandler {
      return publisherHandler(request, fetchingStrategy) as! AnyPublisher<[Result], DataInteractorError>
    }
    fatalError("publisherHandler returns can't have a default value thus its handler must be set")
  }

  public private(set) var publisherForCallCount = 0
  public var publisherForHandler: ((Any, FetchingStrategy) -> (Any))?
  public func publisher<Request, Response, Decoder>(for request: Request, fetchingStrategy: FetchingStrategy) -> AnyPublisher<Response, DataInteractorError>
    where Response: BaseResponseProtocol,
    Decoder: CustomDecoder,
    Decoder.Input == Data,
    Request: BaseSocketRequest<Response, Decoder>
  {
    publisherForCallCount += 1
    if let publisherForHandler = publisherForHandler {
      return publisherForHandler(request, fetchingStrategy) as! AnyPublisher<Response, DataInteractorError>
    }
    fatalError("publisherForHandler returns can't have a default value thus its handler must be set")
  }
}
