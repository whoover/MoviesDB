//
//  AlertActionReturnable.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBUtilities

public protocol StateMachineAlertStateActionType {
  var title: String { get }
}

public protocol AlertActionReturnable {
  func alertActions(with types: [StateMachineAlertStateActionType]) -> [AlertActionModel]
}

public extension AlertActionReturnable {
  func alertActions(with types: [StateMachineAlertStateActionType]) -> [AlertActionModel] {
    var actions: [AlertActionModel] = []

    for type in types {
      switch type {
      case is StateMachineAlertStateDefaultAction:
        actions.append(AlertActionModel(title: type.title, style: .default))
      case is StateMachineAlertStateCancelAction:
        actions.append(AlertActionModel(title: type.title, style: .cancel))
      default:
        break
      }
    }

    return actions
  }
}

public struct StateMachineAlertStateDefaultAction: StateMachineAlertStateActionType {
  public let title: String

  public init(title: String) {
    self.title = title
  }
}

public struct StateMachineAlertStateCancelAction: StateMachineAlertStateActionType {
  public let title: String

  public init(title: String) {
    self.title = title
  }
}
