//
//  StateMachineProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine

/// Describes `StateMachine` states & events.
///
/// All custom states should be subscribed on it.
public protocol StateMachineTypesProtocol: Hashable {}

/// Protocol describes` StateMachine` - pattern which handles module's states.
public protocol StateMachineProtocol: AnyObject {
  /// Constraint for machine's custom state.
  ///
  /// For default machine works only with states. For empty custom states uses `StateMachineNoCustomState`.
  associatedtype State: StateMachineTypesProtocol

  /// On `State` changes publisher.
  var onStateChangePublisher: AnyPublisher<StateMachineStateType<State>, Never> { get }

  /// Default initializer with initial module's state.
  init(state: StateMachineStateType<State>)
}
