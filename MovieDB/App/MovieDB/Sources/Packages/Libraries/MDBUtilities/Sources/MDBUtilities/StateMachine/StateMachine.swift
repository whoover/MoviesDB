//
//  StateMachine.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import Foundation

/// StateMachine
public final class StateMachine<State, Event>: StateMachineProtocol
  where State: StateMachineTypesProtocol,
  Event: StateMachineTypesProtocol
{
  @Published public private(set) var state: StateMachineStateType<State>
  public var onStateChangePublisher: AnyPublisher<StateMachineStateType<State>, Never> {
    $state.eraseToAnyPublisher()
  }

  private var handler: Any?
  private var customsStatesHandlers: [CustomStateHandler] = []

  public init(state: StateMachineStateType<State>) {
    self.state = state
  }

  public func addHandlerFor(
    state: StateMachineStateType<State>,
    stateHandler: @escaping () -> Void
  ) {
    customsStatesHandlers.append(
      .init(state: state, handler: stateHandler)
    )
  }
}

// MARK: - StateMachineCustomEvent

public extension StateMachine where Event: StateMachineCustomEvent {
  typealias StateHandler = (
    StateMachineStateType<State>,
    StateMachineEventType<Event>
  ) -> StateMachineStateType<State>?

  func addRouteMapping(_ handler: @escaping StateHandler) {
    self.handler = handler
  }

  @discardableResult
  func tryChangeToNextState(for event: StateMachineEventType<Event>) -> Bool {
    guard
      let handler = handler as? StateHandler,
      let newState = handler(state, event) ?? handler(.any, event),
      state != newState
    else {
      return false
    }

    state = newState
    callCustomStateHandlerIfNeeded()

    return true
  }
}

// MARK: - StateMachineNoCustomEvent

public extension StateMachine where Event == StateMachineNoCustomEvent {
  func changeStateIfNeeded(
    to newState: StateMachineStateType<State>
  ) {
    guard state != newState else {
      return
    }

    state = newState
    callCustomStateHandlerIfNeeded()
  }
}

// MARK: - Private

private extension StateMachine {
  struct CustomStateHandler {
    let state: StateMachineStateType<State>
    let handler: () -> Void
  }

  func callCustomStateHandlerIfNeeded() {
    guard let customHandler = customsStatesHandlers
      .first(where: { $0.state == state || $0.state == .any })
    else {
      return
    }

    customHandler.handler()
  }
}
