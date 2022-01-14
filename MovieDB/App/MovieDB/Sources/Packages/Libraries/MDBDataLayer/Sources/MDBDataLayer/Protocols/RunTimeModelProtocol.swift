//
//  RunTimeModelProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public protocol RunTimeModelReturnableProtocol {
  /// Method for converting "Realm Object" to the type `RunTimeModelProtocol`.
  func createRuntimeModel() -> RunTimeModelProtocol
}

/// StorableProtocol
public protocol StorableProtocol: Object, RunTimeModelReturnableProtocol {}

/// RunTimeModelProtocol
public protocol RunTimeModelProtocol {
  /// Static method returns "Realm Object" type to store.
  static func storableType() -> StorableProtocol.Type

  /// Method for converting "Runtime Model" to the type `StorableProtocol`.
  func convertToStorable() -> StorableProtocol
}

public class EmptyStorable: Object, StorableProtocol {
  private let runtimeModel: RunTimeModelProtocol

  @objc
  var emptyId = ""

  public init(runtimeModel: RunTimeModelProtocol) {
    self.runtimeModel = runtimeModel
    super.init()
  }

  override public init() {
    runtimeModel = EmptyRuntimeModel()
    super.init()
  }

  public func createRuntimeModel() -> RunTimeModelProtocol {
    runtimeModel
  }
}

public struct EmptyRuntimeModel: RunTimeModelProtocol {
  public static func storableType() -> StorableProtocol.Type {
    EmptyStorable.self
  }

  public func convertToStorable() -> StorableProtocol {
    EmptyStorable(runtimeModel: self)
  }

  public init() {}
}
