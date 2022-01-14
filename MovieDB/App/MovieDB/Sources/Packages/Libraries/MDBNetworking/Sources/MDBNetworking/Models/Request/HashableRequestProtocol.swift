//
//  HashableRequestProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol HashableRequestProtocol {
  var hashEndPoint: String { get }
  var headers: [String: String] { get }
}
