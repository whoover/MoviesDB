//
//  Publisher+Additions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine

public extension Publisher {
  func receiveOutput(
    _ handler: @escaping () -> Void
  ) -> AnyPublisher<Self.Output, Self.Failure> {
    handleEvents(receiveOutput: { _ in handler() })
      .eraseToAnyPublisher()
  }
}
