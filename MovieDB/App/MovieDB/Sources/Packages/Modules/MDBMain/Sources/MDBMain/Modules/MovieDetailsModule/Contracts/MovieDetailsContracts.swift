//
//  MovieDetailsContracts.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import Foundation
import MDBCommonUI
import MDBComponents
import MDBModels
import MDBUtilities

/// Module state typealias
public typealias MovieDetailsState = StateMachineStateType<StateMachineNoCustomState>
/// Module "StateMachine" typealias
public typealias MovieDetailsStateMachine = StateMachine<StateMachineNoCustomState, StateMachineNoCustomEvent>

struct MovieDetailsOutputModel: ModuleOutputModelProtocol {}

/// Module Input
/// Represents input to the module. Should be used to setup/update module from the parent coordinator.
public protocol MovieDetailsModuleInput {
  func setup(movieModel: MovieRuntimeModel)
}

/// Module Output
/// Represents output to the module. Should be used if module used inside another composite module ONLY.
public protocol MovieDetailsModuleOutput: AnyObject {}

/// View Input
/// Represents view's input. In most cases it's UIViewController.
public typealias MovieDetailsViewAlias = AnyObject
  & LocalizableProtocol
  & AlertRoutableProtocol
  & ActivityIndicatorRoutable

/// @mockable
public protocol MovieDetailsViewInput: MovieDetailsViewAlias {
  func setupWith(state: MovieDetailsState)
  func setup(movieModel: MovieRuntimeModel)
  func update(image: UIImage)
}

/// Presenter Input
/// Represents presenters's input.
/// @mockable
public protocol MovieDetailsPresenterInput: AnyObject, AlertActionReturnable {
  func interactorDidLoad()
  func handle(state: MovieDetailsState)
  func handleOnLoadingState()
  func handleAlertStateWith(error: Error)
  func update(image: UIImage)
}

/// Interactor Input
/// Represents interactor's input.
/// @mockable
public protocol MovieDetailsInteractorInput {
  func viewDidLoad()
  func onAllertDismissed()
  func loadImageIfNeeded(path: String)
}

/// Routing Handling
/// Represents routing handler. Module's coordinator conforms to this protocol
public protocol MovieDetailsRoutingHandlingProtocol: ModuleRoutingHandlingProtocol {
  func performRoute(ouputModel: ModuleOutputModelProtocol)
}

/// Coordinator Routing Handling
/// Represents coordinator's exit point. Parent flow coordinator should conforms to this protocol if exists. If not just send `ExpressibleByNilLiteral` as generic parameter.
public protocol MovieDetailsCoordinatorExitRoutingProtocol: FlowExitPointProtocol {
  func performRoute(_ coordinator: CoordinatorProtocol, ouputModel: ModuleOutputModelProtocol)
}
