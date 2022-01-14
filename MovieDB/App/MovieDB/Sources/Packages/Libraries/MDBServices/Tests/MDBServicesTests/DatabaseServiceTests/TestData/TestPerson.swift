//
//  TestPerson.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import AAServicesMocks

final class TestPerson: RunTimeModelProtocol {
  var firstName: String
  var lastName: String
  var primaryKey: String

  init(firstName: String, lastName: String, primaryKey: String = UUID().uuidString) {
    self.firstName = firstName
    self.lastName = lastName
    self.primaryKey = primaryKey
  }

  static func storableType() -> StorableProtocol.Type {
    TestPersonStorable.self
  }

  func convertToStorable() -> StorableProtocol {
    TestPersonStorable(firstName: firstName, lastName: lastName, primaryKey: primaryKey)
  }
}
