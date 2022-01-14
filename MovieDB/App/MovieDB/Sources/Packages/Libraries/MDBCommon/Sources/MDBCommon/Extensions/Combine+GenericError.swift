//
//  Combine+GenericError.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine

public extension Publisher {
  /**
   Operator for mapping any type of `Error` to the type of `GenericError`.

   Upstream `Publisher.Failure` any type of `Error`. T should conforms to `GenericError`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - ofType: the type of `T`.

   ### Usage Example: ###
   ```
     ...
       .anyPublisherWithMappedError(ofType: SomeError.self)
     ...
   ```

   - Returns: `Self` with mapped error erased to `AnyPublisher`.
   */
  func anyPublisherWithMappedError<T>(ofType _: T.Type) -> AnyPublisher<Self.Output, T>
    where T: GenericError,
    T.ErrorType == T
  {
    mapError { T.genericError(with: $0) }.eraseToAnyPublisher()
  }

  /**
   Operator for mapping any type of `Error` to the type of `GenericError`.

   Upstream `Publisher.Failure`is `T`. T should conforms to `GenericError`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - ofType: the type of `T`.

   ### Usage Example: ###
   ```
     ...
       .anyPublisherWithMappedError(ofType: SomeError.self)
     ...
   ```

   - Returns: `Self` erased to `AnyPublisher`.
   */
  func anyPublisherWithMappedError<T>(ofType _: T.Type) -> AnyPublisher<Self.Output, T>
    where T: GenericError,
    T.ErrorType == T,
    Self.Failure == T
  {
    eraseToAnyPublisher()
  }

  /**
   Operator for mapping any type of `Error` to the type of `GenericError`.

   Upstream `Publisher.Failure` is `Never`. T should conforms to `GenericError`.
   Operator maps any `Error` to `DatabaseError` itself.

   - Parameters:
     - ofType: the type of `T`.

   ### Usage Example: ###
   ```
     ...
       .anyPublisherWithMappedError(ofType: SomeError.self)
     ...
   ```

   - Returns: `Self` with mapped error erased to `AnyPublisher`.
   */
  func anyPublisherWithMappedError<T>(ofType _: T.Type) -> AnyPublisher<Self.Output, T>
    where T: GenericError,
    T.ErrorType == T,
    Self.Failure == Never
  {
    setFailureType(to: T.self).eraseToAnyPublisher()
  }
}
