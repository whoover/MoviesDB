//
//  ParameterEncoder.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public protocol JSONParameterEncoderProtocol {
  func encode<RequestParameters: Encodable>(
    urlRequest: inout URLRequest,
    with requestParameters: RequestParameters
  ) throws
}

public protocol URLParameterEncoderProtocol {
  func encode(urlRequest: inout URLRequest, with parameters: URLParameters) throws
}
