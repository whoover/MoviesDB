//
//  StateMachinePresenterProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBUtilities

public protocol StateMachinePresenterActivityHandlingProtocol {
  func handleOnLoadingState()
}

public protocol StateMachinePresenterAlertHandlingProtocol: AlertActionReturnable {
  var alertActions: [StateMachineAlertStateActionType] { get }

  func handleAlertStateWith(error: Error)
}

public typealias AlertAndActivityIndicatorHandlingPresenter =
  StateMachinePresenterAlertHandlingProtocol &
  StateMachinePresenterActivityHandlingProtocol
