//
//  EmptyPrimaryKeyModel.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import AAServicesMocks

final class EmptyPrimaryKeyModel: RunTimeModelProtocol {
  static func storableType() -> StorableProtocol.Type {
    EmptyPrimaryKeyModelObject.self
  }

  func convertToStorable() -> StorableProtocol {
    EmptyPrimaryKeyModelObject(primaryKey: nil)
  }
}
