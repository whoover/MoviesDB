//
//  StateMachineEventType.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// Modules events - uses only with custom `CustomEvent`.
public enum StateMachineEventType<CustomEvent: StateMachineTypesProtocol>: StateMachineTypesProtocol {
  /// Custom event.
  case custom(CustomEvent)
  /// Any event.
  case any
}

/// Empty custom events.
public struct StateMachineNoCustomEvent: StateMachineTypesProtocol {}

/// Custom events protocol. All custom events should be subscribed on it.
public protocol StateMachineCustomEvent: StateMachineTypesProtocol {}
