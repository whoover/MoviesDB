//
//  Publishers.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import Foundation

/// @mockable
public typealias EmptyPassthroughSubject = PassthroughSubject<Void, Never>

/// @mockable
public typealias EmptyCurrentValueSubject = CurrentValueSubject<Void, Never>

/// @mockable
public typealias EmptyPublisher = AnyPublisher<Void, Never>

public enum Publishers {
  public static func createDirectPublisher<T>(_ value: T) -> AnyPublisher<T, Never> {
    Future<T, Never> { $0(.success(value)) }.eraseToAnyPublisher()
  }
}

public typealias IndexPathCompletion = ((IndexPath) -> Void)?
public typealias EmptyCompletion = (() -> Void)?
public typealias BoolIndexPathCompletion = ((Bool, IndexPath) -> Void)?
public typealias BoolCompletion = ((Bool) -> Void)?
