//
//  HTTPConnectionConfigurationProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public protocol HTTPConnectionConfigurationProtocol: ConnectionConfigurationProtocol {
  var sessionConfiguration: URLSessionConfigurationProtocol { get }
}
