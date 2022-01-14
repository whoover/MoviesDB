//
//  DatabaseService.swift
//  MDBDataLayer
//
//

import MDBDataLayer
import Realm

/// DatabaseService. Uses "Realm".
public final class DatabaseService: DatabaseServiceProtocol {
  private let queue = DispatchQueue(label: "com.movie-db.DatabaseService.queue")
  private var realmInstance: RealmInstanceProtocol?
  private var realm: Realm? { realmInstance as? Realm }

  private var subscriptions = Set<AnyCancellable>()

  public init() {}

  public func setup(version: UInt64, realmURL: URL?) {
    queue.sync {
      var configuration = Realm.Configuration.defaultConfiguration
      configuration.schemaVersion = version

      if let realmURL = realmURL {
        configuration.fileURL = realmURL
      }

      do {
        self.realmInstance = try Realm(configuration: configuration, queue: self.queue)
      } catch {
        print("Error creating realm")
      }
    }
  }

  // MARK: - Get

  public func getAll<T: RunTimeModelProtocol>(of type: T.Type) -> AnyPublisher<[T], DatabaseError> {
    guard let realm = realm else {
      return Fail(error: DatabaseError.databaseDoesntExists).eraseToAnyPublisher()
    }

    return Future { [unowned self] resolve in
      self.queue.async {
        autoreleasepool {
          let results = realm.objects(type.storableType())
            .compactMap { ($0 as? StorableProtocol)?.createRuntimeModel() }
          let array = Array(results) as? [T] ?? []

          resolve(.success(array))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func get<T: RunTimeModelProtocol>(primaryKey: Any) -> AnyPublisher<T, DatabaseError> {
    guard let realm = realm else {
      return Fail(error: DatabaseError.databaseDoesntExists).eraseToAnyPublisher()
    }

    return Future { [unowned self] resolve in
      self.queue.async {
        autoreleasepool {
          let result = self.fetchObject(of: T.storableType(), forPrimaryKey: primaryKey, in: realm)
          if let runtimeModel = result?.createRuntimeModel() as? T {
            resolve(.success(runtimeModel))
          } else {
            resolve(.failure(DatabaseError.objectDoesntExists))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }

  // MARK: - Set

  public func addOrUpdate(object: RunTimeModelProtocol) -> AnyPublisher<Void, DatabaseError> {
    addOrUpdate(objects: [object])
  }

  public func addOrUpdate(objects: [RunTimeModelProtocol]) -> AnyPublisher<Void, DatabaseError> {
    guard let realm = realm else {
      return Fail(error: DatabaseError.databaseDoesntExists).eraseToAnyPublisher()
    }

    return Future { [unowned self] resolve in
      self.queue.async {
        do {
          try realm.write {
            autoreleasepool {
              let objectsToStore = objects.map { $0.convertToStorable() }
              realm.add(objectsToStore, update: .modified)

              resolve(.success(()))
            }
          }
        } catch {
          resolve(.failure(DatabaseError.generic(error)))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  // MARK: - Remove

  public func remove<T: RunTimeModelProtocol>(object: T) -> AnyPublisher<Void, DatabaseError> {
    guard let realm = realm else {
      return Fail(error: DatabaseError.databaseDoesntExists).eraseToAnyPublisher()
    }

    let objectStorableType = type(of: object).storableType()

    guard
      let primaryFieldName = objectStorableType.primaryKey(),
      let primaryKey = object.convertToStorable().value(forKey: primaryFieldName)
    else {
      return Fail(error: DatabaseError.objectsKeyDoesntExists).eraseToAnyPublisher()
    }

    return Future { [unowned self] resolve in
      self.queue.async {
        do {
          try realm.write {
            autoreleasepool {
              if let object = fetchObject(of: objectStorableType, forPrimaryKey: primaryKey, in: realm) {
                realm.delete(object)
                resolve(.success(()))
              } else {
                resolve(.failure(DatabaseError.objectDoesntExists))
              }
            }
          }
        } catch {
          resolve(.failure(DatabaseError.generic(error)))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func removeAll<T: RunTimeModelProtocol>(of type: T.Type) -> AnyPublisher<T.Type, DatabaseError> {
    guard let realm = realm else {
      return Fail(error: DatabaseError.databaseDoesntExists).eraseToAnyPublisher()
    }

    return Future { [unowned self] resolve in
      self.queue.async {
        do {
          let objects = realm.objects(type.storableType())

          try realm.write {
            realm.delete(objects)

            resolve(.success(type))
          }
        } catch {
          resolve(.failure(DatabaseError.generic(error)))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func removeAll() -> AnyPublisher<Void, DatabaseError> {
    guard let realm = realm else {
      return Fail(error: DatabaseError.databaseDoesntExists).eraseToAnyPublisher()
    }

    return Future { [unowned self] resolve in
      self.queue.async {
        do {
          try realm.write {
            realm.deleteAll()

            resolve(.success(()))
          }
        } catch {
          resolve(.failure(DatabaseError.generic(error)))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - Helpers

private extension DatabaseService {
  func generateEncryptionKey() -> AnyPublisher<Data, DatabaseError> {
    guard let key = NSMutableData(length: 64) else {
      return Fail(error: DatabaseError.encryptionKeyGeneratingError).eraseToAnyPublisher()
    }

    let result = SecRandomCopyBytes(kSecRandomDefault, key.length, UnsafeMutableRawPointer(key.mutableBytes))

    guard result == errSecSuccess else {
      return Fail(error: DatabaseError.encryptionKeyGeneratingError).eraseToAnyPublisher()
    }

    return Just(key as Data)
      .setFailureType(to: DatabaseError.self)
      .eraseToAnyPublisher()
  }

  func fetchObject(
    of storableType: StorableProtocol.Type,
    forPrimaryKey: Any,
    in realmInstance: Realm
  ) -> StorableProtocol? {
    realmInstance.object(ofType: storableType, forPrimaryKey: forPrimaryKey) as? StorableProtocol
  }

  func remove(storables: [RealmSwiftObject]) -> AnyPublisher<Void, DatabaseError> {
    Future { [unowned self] resolve in
      guard let realm = self.realm else {
        return resolve(.failure(DatabaseError.databaseDoesntExists))
      }

      self.queue.async {
        do {
          try realm.write {
            realm.delete(storables)

            resolve(.success(()))
          }
        } catch {
          resolve(.failure(DatabaseError.generic(error)))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - For test purposes

extension DatabaseService {
  func setup(inMemoryIdentifier: String) -> AnyPublisher<Bool, DatabaseError> {
    Future { [unowned self] resolve in
      self.queue.sync {
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.inMemoryIdentifier = inMemoryIdentifier

        do {
          self.realmInstance = try Realm(configuration: configuration, queue: self.queue)
          resolve(.success(true))
        } catch {
          resolve(.failure(DatabaseError.generic(error)))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func setup(realmInstance: RealmInstanceProtocol?) {
    self.realmInstance = realmInstance
  }
}

// MARK: - PersistenceDataInteractorProtocol

extension DatabaseService: PersistenceDataInteractorProtocol {
  public func allCacheIdentifiableModelsPublisher<T: RunTimeModelProtocol>(
    of type: T.Type
  ) -> AnyPublisher<[T], DatabaseError> {
    getAll(of: type)
  }

  public func cacheIdentifiableModel<T: RunTimeModelProtocol>(
    for requestKey: String,
    of type: T.Type
  ) -> AnyPublisher<T, DatabaseError> {
    get(primaryKey: requestKey)
  }

  public func setCacheIdentifiable(model: RunTimeModelProtocol) -> AnyPublisher<Void, DatabaseError> {
    addOrUpdate(object: model)
  }
}
