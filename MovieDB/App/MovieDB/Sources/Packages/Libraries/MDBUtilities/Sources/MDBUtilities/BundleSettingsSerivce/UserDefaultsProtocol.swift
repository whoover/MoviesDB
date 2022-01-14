//
//  UserDefaultsProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// @mockable
public protocol UserDefaultsProtocol {
  func set<V: Codable>(_ value: V?, _ key: String)
  func getValue<V: Codable>(forKey defaultName: String) -> V?
  func getValue(forKey defaultName: String) -> Any?

  func register(defaults registrationDictionary: [String: Any])
  func publisher<Value>(for keyPath: KeyPath<UserDefaults, Value>)
    -> NSObject.KeyValueObservingPublisher<UserDefaults, Value>

  func setValue(_ value: Any?, forKey key: String)
  func string(forKey defaultName: String) -> String?
  func array(forKey defaultName: String) -> [Any]?
  func bool(forKey: String) -> Bool

  func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {
  public func publisher<Value>(for keyPath: KeyPath<UserDefaults, Value>) -> NSObject
    .KeyValueObservingPublisher<UserDefaults, Value>
  {
    publisher(for: keyPath, options: [.initial, .new])
  }
}

public extension UserDefaults {
  func set<V>(_ value: V?, _ key: String) where V: Codable {
    guard let value = value else {
      removeObject(forKey: key)
      return
    }

    do {
      let data = try JSONEncoder().encode(value)
      setValue(data, forKey: key)
    } catch {
      set(value, forKey: key)
    }
  }

  func getValue<V>(forKey defaultName: String) -> V? where V: Codable {
    guard let valueData = data(forKey: defaultName) else {
      return nil
    }

    do {
      let value = try JSONDecoder().decode(V.self, from: valueData)
      return value
    } catch {
      return object(forKey: defaultName) as? V
    }
  }

  func getValue(forKey defaultName: String) -> Any? {
    value(forKey: defaultName)
  }
}
