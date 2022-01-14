//
//  NameDescribableProtocol.swift
//  MDBCommon
//
//

/// NameDescribable protocol
public protocol NameDescribable {
  var typeName: String { get }
  static var typeName: String { get }
}

public extension NameDescribable {
  var typeName: String {
    String(describing: type(of: self))
  }

  static var typeName: String {
    String(describing: self)
  }
}
