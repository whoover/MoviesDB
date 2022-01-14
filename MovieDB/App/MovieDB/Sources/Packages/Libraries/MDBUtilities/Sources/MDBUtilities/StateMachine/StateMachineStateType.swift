//
//  StateMachineStateType.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// Default modules states. Can be extended by custom `CustomState`.
public enum StateMachineStateType<CustomState: StateMachineTypesProtocol>: StateMachineTypesProtocol {
  public static func == (lhs: StateMachineStateType<CustomState>, rhs: StateMachineStateType<CustomState>) -> Bool {
    switch (lhs, rhs) {
    case (`default`, `default`):
      return true
    case let (onLoading(lft), onLoading(rht)):
      return lft == rht
    case let (onError(lft), onError(rht)):
      return lft == rht
    case let (custom(lft), custom(rht)):
      return lft == rht
    case (any, any):
      return true
    default:
      return false
    }
  }

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .any:
      hasher.combine("any")
    case .default:
      hasher.combine("default")
    case let .onLoading(configurator):
      hasher.combine("onLoading")
      hasher.combine(configurator)
    case let .onError(errors):
      hasher.combine("onError")
      hasher.combine(errors)
    case let .custom(type):
      hasher.combine("custom")
      hasher.combine(type)
    }
  }

  /// Default (initial) state.
  case `default`(completion: (() -> Void)?)
  /// On loading state.
  case onLoading(OnLoadingStateConfigurator)
  /// On error state. Constrained by `Array<StateMachineOnErrorStateType>`.
  case onError([StateMachineOnErrorStateType])
  /// Custom states.
  case custom(CustomState)
  /// Any state.
  case any
}

/// Default modules `onError` state behavior.
public enum StateMachineOnErrorStateType: StateMachineTypesProtocol {
  /// On error state alert.
  case alert(configuration: AlertConfiguration)
  /// On validation error
  case validation(AnyHashable)
  /// On error state view update.
  case viewUpdate
}

/// Empty custom states.
public struct StateMachineNoCustomState: StateMachineTypesProtocol {}

/// Custom states protocol. All custom states should be subscribed on it.
public protocol StateMachineCustomState: StateMachineTypesProtocol {}
