//
//  DataReturnableProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public protocol DataReturnableProtocol {
  associatedtype DataType: Decodable

  var data: DataType { get }
}
