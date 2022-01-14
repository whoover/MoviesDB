//
//  DatabaseServiceProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// DatabaseServiceProtocol
/// @mockable
public protocol DatabaseServiceProtocol: PersistenceDataInteractorProtocol {
  /// Method for setup schema version.
  ///
  /// - Parameter version: specified schema version.
  /// - Parameter realmURL: The local URL of the Realm file. If nil than will be used default path from `Realm.Configuration` configuration.
  ///
  func setup(version: UInt64, realmURL: URL?)

  /// Method for adding (if not previously stored) or updating Realm `Object`.
  ///
  /// - Parameter object: `RunTimeModelProtocol` object to add / update.
  ///
  /// - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
  func addOrUpdate(object: RunTimeModelProtocol) -> AnyPublisher<Void, DatabaseError>

  /// Method for adding (if not previously stored) or updating Realm `Object`s.
  ///
  /// - Parameter objects: `RunTimeModelProtocol` objects to add / update.
  ///
  /// - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
  func addOrUpdate(objects: [RunTimeModelProtocol]) -> AnyPublisher<Void, DatabaseError>

  /// Method for fetching all Realm `Object`s of specified type `T`.
  ///
  /// - Parameter type: Type of objects to fetch.
  ///
  /// - Returns: `AnyPublisher<[T], DatabaseError>` with emmited list of objects with type of `T` (without error) or `DatabaseError` if some occurs.
  func getAll<T: RunTimeModelProtocol>(of type: T.Type) -> AnyPublisher<[T], DatabaseError>

  /// Method for fetching Realm `Object` for primary key.
  ///
  /// - Parameter primaryKey: `Any` primary key.
  ///
  /// - Returns: `AnyPublisher<T, DatabaseError>` with emmited value object with type of `T` (without error) or `DatabaseError` if some occurs.
  func get<T: RunTimeModelProtocol>(primaryKey: Any) -> AnyPublisher<T, DatabaseError>

  /// Method for removing Realm `Object`.
  ///
  /// - Parameter object: `RunTimeModelProtocol` object to remove.
  ///
  /// - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
  func remove<T: RunTimeModelProtocol>(object: T) -> AnyPublisher<Void, DatabaseError>

  /// Method for removing all Realm `Object`s of specified type `T`.
  ///
  /// - Parameter type: Type of objects to remove.
  ///
  /// - Returns: `AnyPublisher<T.Type, DatabaseError>` with emmited value of `T.Type` (without error) or `DatabaseError` if some occurs.
  func removeAll<T: RunTimeModelProtocol>(of type: T.Type) -> AnyPublisher<T.Type, DatabaseError>

  /// Method for removing all Realm `Object`s.
  ///
  /// - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
  func removeAll() -> AnyPublisher<Void, DatabaseError>
}
