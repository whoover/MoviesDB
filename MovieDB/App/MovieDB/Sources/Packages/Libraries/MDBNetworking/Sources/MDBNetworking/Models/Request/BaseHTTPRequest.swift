//
//  BaseHTTPRequest.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public typealias URLParameters = [String: String]
public typealias HTTPHeaders = [String: String]

open class GetHttpRequest
<
  ResponseModelType: BaseResponseProtocol,
  Decoder: CustomDecoder
>: BaseHTTPRequest
<
  ResponseModelType,
  Decoder
> {
  override open func createBaseURLRequest() throws -> URLRequest {
    var urlRequest = try super.createBaseURLRequest()
    urlRequest.httpMethod = HTTPMethod.get.rawValue
    return urlRequest
  }
}

open class DeleteHttpRequest
<
  ResponseModelType: BaseResponseProtocol,
  Decoder: CustomDecoder,
  BodyParameters: Encodable
>: BaseHTTPRequest
<
  ResponseModelType,
  Decoder
> {
  open var bodyParameters: BodyParameters? {
    nil
  }

  open var jsonEncoder: JSONParameterEncoderProtocol {
    JSONParameterEncoder()
  }

  override open func createBaseURLRequest() throws -> URLRequest {
    var urlRequest = try super.createBaseURLRequest()
    urlRequest.httpMethod = HTTPMethod.delete.rawValue
    try jsonEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
    return urlRequest
  }
}

open class MultipartHttpRequest<
  ResponseModelType: BaseResponseProtocol,
  Decoder: CustomDecoder
>: BaseHTTPRequest
<
  ResponseModelType,
  Decoder
> {
  override open var headers: [String: String] {
    [
      "Content-Type": "multipart/form-data; boundary=\(String.boundaryString)"
    ]
  }

  override open func createBaseURLRequest() throws -> URLRequest {
    var urlRequest = try createBaseURLRequest()
    urlRequest.httpMethod = HTTPMethod.post.rawValue
    urlRequest.httpBody = body

    return urlRequest
  }

  public var multipartValues: [MultipartValueContainer] {
    []
  }

  public var multipartParameters: MultipartParameters {
    [:]
  }

  private var body: Data {
    let lineBreak = "\r\n"
    let boundary = String.boundaryString
    var body = Data()

    for (key, value) in multipartParameters {
      if let arrayValue = value as? [Any] {
        body.append(generateArrayBody(array: arrayValue, key: key, boundary: boundary))
      } else {
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        body.append("\(value)\(lineBreak)")
      }
    }

    for value in multipartValues {
      body.append("--\(boundary + lineBreak)")
      let bodyData = "Content-Disposition: form-data; " +
        "name=\"\(value.valueKey.rawValue)\"; filename=\"\(value.fileName)\"\(lineBreak)"
      body.append(bodyData)
      body.append("Content-Type: \(value.mimeType + lineBreak + lineBreak)")
      body.append(value.data)
      body.append(lineBreak)
    }

    body.append("--\(boundary)--\(lineBreak)")

    return body
  }

  private func generateArrayBody(array: [Any], key: String, boundary: String) -> String {
    var bodyString = ""
    let lineBreak = "\r\n"
    for value in array {
      bodyString.append("--\(boundary + lineBreak)")
      bodyString.append("Content-Disposition: form-data; name=\"\(key)[]\"\(lineBreak + lineBreak)")
      bodyString.append("\(value)\(lineBreak)")
    }
    return bodyString
  }
}

open class PostHttpRequest<
  ResponseModelType: BaseResponseProtocol,
  Decoder: CustomDecoder,
  BodyParameters: Encodable
>: BaseHTTPRequest
<
  ResponseModelType,
  Decoder
> {
  open var bodyParameters: BodyParameters? {
    nil
  }

  open var jsonEncoder: JSONParameterEncoderProtocol {
    JSONParameterEncoder()
  }

  override public init() {}

  override open func createBaseURLRequest() throws -> URLRequest {
    var urlRequest = try super.createBaseURLRequest()
    urlRequest.httpMethod = HTTPMethod.post.rawValue
    try jsonEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
    return urlRequest
  }
}

public protocol CustomErrorHandler {
  func checkIfDataHasError(_ data: Data) -> Error?
}

public protocol CustomErrorHolder: CustomErrorHandler {
  associatedtype ErrorType: FailureResponseModelProtocol
  associatedtype Decoder: CustomDecoder

  var decoder: Decoder { get }
  static var validationErrorType: ErrorType.Type { get }
}

open class BaseHTTPRequest<
  ResponseModelType: BaseResponseProtocol,
  Decoder: CustomDecoder
> {
  public let decoder = Decoder.create()
  public var responseModelType: ResponseModelType.Type {
    ResponseModelType.self
  }

  open var requestDescription: String {
    String(describing: type(of: self))
  }

  open var path: String {
    ""
  }

  open var route: String {
    ""
  }

  open var headers: HTTPHeaders {
    [
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
  }

  open var headerValuesToReplace: HTTPHeaders = [:]

  open var urlComponents: URLComponents {
    baseUrlProvider?.createComponents(
      path: path,
      route: route,
      urlParameters: urlParameters
    ) ?? URLComponents()
  }

  open var urlParameters: URLParameters {
    [:]
  }

  open var workQueue: DispatchQueue {
    .global()
  }

  public var connectionConfiguration: HTTPConnectionConfiguration {
    let sessionConfiguration = HTTPURLSessionConfiguration(
      configurationType: .default,
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      sessionIdentifier: sessionIdentifier
    )

    return .init(sessionConfiguration: sessionConfiguration, workQueue: workQueue)
  }

  var sessionIdentifier: String {
    "default"
  }

  public var baseUrlProvider: BaseUrlProvider?

  public init() {}

  open func createBaseURLRequest() throws -> URLRequest {
    guard let taskURL = urlComponents.url else {
      throw NetworkingError.missingUrl
    }

    var urlRequest = URLRequest(
      url: taskURL,
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      timeoutInterval: 60
    )

    urlRequest.allHTTPHeaderFields = (headers + headerValuesToReplace)
    return urlRequest
  }
}

public protocol BaseUrlProvider {
  var host: String { get }
  var scheme: String { get }
  var version: String { get }
  var port: Int? { get }

  func createComponents(
    path: String,
    route: String,
    urlParameters: [String: String]
  ) -> URLComponents
}

public extension BaseUrlProvider {
  func createComponents(
    path: String,
    route: String,
    urlParameters: [String: String]
  ) -> URLComponents {
    var pathComponents: [String] = []
    if !route.isEmpty {
      pathComponents.append(route)
    }
    if !version.isEmpty {
      pathComponents.append(version)
    }
    if !path.isEmpty {
      pathComponents.append(path)
    }

    var composedPath = ""
    if !pathComponents.isEmpty {
      composedPath = "/" + pathComponents.joined(separator: "/")
    }

    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    if !host.isEmpty {
      urlComponents.host = host
    }
    urlComponents.path = composedPath
    urlComponents.port = port

    if !urlParameters.isEmpty {
      urlComponents.queryItems = urlParameters.map {
        URLQueryItem(name: $0.key, value: $0.value)
      }
    }
    return urlComponents
  }
}
