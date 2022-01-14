//
//  JSONParameterEncoder.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

struct JSONParameterEncoder: JSONParameterEncoderProtocol {
  func encode<RequestParameters: Encodable>(
    urlRequest: inout URLRequest,
    with requestParameters: RequestParameters
  ) throws {
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let jsonData = try encoder.encode(requestParameters)
      urlRequest.httpBody = jsonData
    } catch {
      throw NetworkingError.encodingFailed
    }
  }
}
