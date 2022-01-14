//
//  EmptyPrimaryKeyModelStorable.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import AAServicesMocks

final class EmptyPrimaryKeyModelObject: Object, StorableProtocol {
  @Persisted var primaryKeyField: String?

  override init() {
    super.init()
  }

  convenience init(primaryKey: String?) {
    self.init()
  }

  override class func primaryKey() -> String? {
    "primaryKeyField"
  }

  func createRuntimeModel() -> RunTimeModelProtocol {
    EmptyPrimaryKeyModel()
  }
}
