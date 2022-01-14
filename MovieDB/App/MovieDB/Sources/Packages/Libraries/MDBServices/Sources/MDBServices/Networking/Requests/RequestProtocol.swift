//
//  HTTPRequestProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBDataLayer
import MDBNetworking

// MARK: - ResponseProtocol

public protocol ResponseProtocol {}

// MARK: - HTTP

public protocol HTTPRequestProtocol {
  associatedtype RuntimeModelType: RunTimeModelProtocol

  var runTimeModelType: RuntimeModelType.Type { get }
  var urlRoute: UrlRoute { get }
}

public extension HTTPRequestProtocol {
  var runTimeModelType: RuntimeModelType.Type {
    RuntimeModelType.self
  }
}

public extension HTTPRequestProtocol {
  var urlRoute: UrlRoute {
    .mobile
  }
}

// MARK: - Socket

public protocol SocketRequestProtocol {
  associatedtype RuntimeModelType: RunTimeModelProtocol

  var runTimeModelType: RuntimeModelType.Type { get }
}

public extension SocketRequestProtocol {
  var runTimeModelType: RuntimeModelType.Type {
    RuntimeModelType.self
  }
}
