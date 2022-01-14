//
//  Combine+DataLayer.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public extension Publisher {
  /**
   Operator for adding (if not previously stored) or updating Realm `Object`.

   Upstream `Publisher.Output` should conforms to `RunTimeModelProtocol`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - databaseService: the type of `DatabaseServiceProtocol`.

   ### Usage Example: ###
   ```
     ...
       .map { _ in RealmOject }
       .addOrUpdateObject(in: databaseService)
     ...
   ```

   - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
   */
  func addOrUpdateObject(in databaseService: DatabaseServiceProtocol)
    -> AnyPublisher<Void, DatabaseError>
    where Self.Output: RunTimeModelProtocol
  {
    anyPublisherWithMappedError(ofType: DatabaseError.self)
      .flatMap {
        databaseService.addOrUpdate(object: $0)
      }
      .eraseToAnyPublisher()
  }

  /**
   Operator for adding (if not previously stored) or updating Realm `Object`s.

   Upstream `Publisher.Output` should conforms to `Sequence` of `RunTimeModelProtocol`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - databaseService: the type of `DatabaseServiceProtocol`.

   ### Usage Example: ###
   ```
     ...
       .map { _ in [RealmOject1, RealmOject2, RealmOject3 ...] }
       .addOrUpdateObjects(in: databaseService)
     ...
   ```

   - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
   */
  func addOrUpdateObjects(in databaseService: DatabaseServiceProtocol)
    -> AnyPublisher<Void, DatabaseError>
    where Self.Output: Sequence,
    Self.Output.Element: RunTimeModelProtocol
  {
    anyPublisherWithMappedError(ofType: DatabaseError.self)
      .flatMap {
        databaseService.addOrUpdate(objects: $0 as? [Self.Output.Element] ?? [])
      }
      .eraseToAnyPublisher()
  }

  /**
   Operator for removing Realm `Object`.

   Upstream `Publisher.Output` should conforms to `RunTimeModelProtocol`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - databaseService: the type of `DatabaseServiceProtocol`.

   ### Usage Example: ###
   ```
     ...
       .map { _ in RealmOject }
       .removeObject(in: databaseService)
     ...
   ```

   - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
   */
  func removeObject(in databaseService: DatabaseServiceProtocol)
    -> AnyPublisher<Void, DatabaseError>
    where Self.Output: RunTimeModelProtocol
  {
    anyPublisherWithMappedError(ofType: DatabaseError.self)
      .flatMap {
        databaseService.remove(object: $0)
      }
      .eraseToAnyPublisher()
  }

  /**
   Operator for removing all Realm `Object`s of specified type `T`.

   Upstream `Publisher.Output` should be `T.Type`. `T` itself should conforms to `RunTimeModelProtocol`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - databaseService: the type of `DatabaseServiceProtocol`.

   ### Usage Example: ###
   ```
     ...
       .map { _ in T.self }
       .removeAll(in: databaseService)
     ...
   ```

   - Returns: `AnyPublisher<T.Type, DatabaseError>` with emmited value of `T.Type` (without error) or `DatabaseError` if some occurs.
   */
  func removeAll<T>(in databaseService: DatabaseServiceProtocol)
    -> AnyPublisher<T.Type, DatabaseError>
    where T: RunTimeModelProtocol,
    Self.Output == T.Type
  {
    anyPublisherWithMappedError(ofType: DatabaseError.self)
      .flatMap {
        databaseService.removeAll(of: $0)
      }
      .eraseToAnyPublisher()
  }

  /**
   Operator for removing all Realm `Object`s.

   Upstream `Publisher.Output` is ommiting..
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - databaseService: the type of `DatabaseServiceProtocol`.

   ### Usage Example: ###
   ```
     ...
       .removeAll(in: databaseService)
     ...
   ```

   - Returns: `AnyPublisher<Void, DatabaseError>` with empty emmited value (without error) or `DatabaseError` if some occurs.
   */
  func removeAll(in databaseService: DatabaseServiceProtocol) -> AnyPublisher<Void, DatabaseError> {
    anyPublisherWithMappedError(ofType: DatabaseError.self)
      .flatMap { _ in
        databaseService.removeAll()
      }
      .eraseToAnyPublisher()
  }

  /**
   Operator for fetching all Realm `Object`s of specified type `T`.

   Upstream `Publisher.Output` is ommiting. `T` itself should conforms to `RunTimeModelProtocol`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - databaseService: the type of `DatabaseServiceProtocol`.

   ### Usage Example: ###
   ```
     ...
       .getAll(in: databaseService)
       .sink(
         receiveCompletion: { _ in },
         receiveValue: { (ojects: [T]) in
           ...
         }
       )
     ...
   ```

   - Returns: `AnyPublisher<[T], DatabaseError>` with emmited list of objects with type of `T` (without error) or `DatabaseError` if some occurs.
   */
  func getAll<T>(in databaseService: DatabaseServiceProtocol)
    -> AnyPublisher<[T], DatabaseError>
    where T: RunTimeModelProtocol,
    Self.Output: Any
  {
    anyPublisherWithMappedError(ofType: DatabaseError.self)
      .flatMap { _ in
        databaseService.getAll(of: T.self)
      }
      .eraseToAnyPublisher()
  }

  /**
   Operator for fetching Realm `Object` for primary key.

   Upstream `Publisher.Output` with  type of `Any` is primary key. `T` itself should conforms to `RunTimeModelProtocol`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - databaseService: the type of `DatabaseServiceProtocol`.

   ### Usage Example: ###
   ```
     ...
       .map { _ in somePrimaryKey }
       .get(in: databaseService)
       .sink(
         receiveCompletion: { _ in },
         receiveValue: { (oject: T) in
           ...
         }
       )
     ...
   ```

   - Returns: `AnyPublisher<T, DatabaseError>` with emmited value object with type of `T` (without error) or `DatabaseError` if some occurs.
   */
  func get<T>(in databaseService: DatabaseServiceProtocol) -> AnyPublisher<T, DatabaseError>
    where T: RunTimeModelProtocol,
    Self.Output: Any
  {
    anyPublisherWithMappedError(ofType: DatabaseError.self)
      .flatMap {
        databaseService.get(primaryKey: $0)
      }
      .eraseToAnyPublisher()
  }
}
