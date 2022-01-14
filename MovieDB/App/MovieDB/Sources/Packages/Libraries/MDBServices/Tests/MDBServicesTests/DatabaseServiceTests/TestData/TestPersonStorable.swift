//
//  TestPersonStorable.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import AAServicesMocks

final class TestPersonStorable: Object, StorableProtocol {
  @Persisted var personID: String = ""
  @Persisted var firstName: String = ""
  @Persisted var lastName: String = ""

  override init() {
    super.init()
  }

  convenience init(firstName: String, lastName: String, primaryKey: String) {
    self.init()
    self.firstName = firstName
    self.lastName = lastName
    personID = primaryKey
  }

  override class func primaryKey() -> String? {
    "personID"
  }

  func createRuntimeModel() -> RunTimeModelProtocol {
    TestPerson(firstName: firstName, lastName: lastName, primaryKey: personID)
  }
}
