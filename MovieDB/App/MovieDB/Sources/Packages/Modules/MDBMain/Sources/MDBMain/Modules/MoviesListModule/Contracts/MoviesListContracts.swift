//
//  MoviesListContracts.swift
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
public typealias MoviesListState = StateMachineStateType<StateMachineNoCustomState>
/// Module "StateMachine" typealias
public typealias MoviesListStateMachine = StateMachine<StateMachineNoCustomState, StateMachineNoCustomEvent>

struct MoviesListOutputModel: ModuleOutputModelProtocol {
  let movie: MovieRuntimeModel
}

/// Module Input
/// Represents input to the module. Should be used to setup/update module from the parent coordinator.
public protocol MoviesListModuleInput {}

/// Module Output
/// Represents output to the module. Should be used if module used inside another composite module ONLY.
public protocol MoviesListModuleOutput: AnyObject {}

/// View Input
/// Represents view's input. In most cases it's UIViewController.
public typealias MoviesListViewAlias = AnyObject
  & LocalizableProtocol
  & AlertRoutableProtocol
  & ActivityIndicatorRoutable
/// @mockable
public protocol MoviesListViewInput: MoviesListViewAlias {
  func setup(dataSource: MoviesListDataSource<MoviesListSection<MoviesListCellModel>>)
  func reloadData()
  func reloadCell(indexPath: IndexPath)

  func setupWith(state: MoviesListState)
  func endRefreshing()
}

/// Presenter Input
/// Represents presenters's input.
/// @mockable
public protocol MoviesListPresenterInput: AnyObject, AlertActionReturnable {
  var numberOfCells: Int { get }

  func interactorDidLoad()

  func resetList()
  func update(movies: [MovieRuntimeModel])

  func getImagePath(indexPath: IndexPath) -> String?
  func isImageLoadingNeeded(indexPath: IndexPath) -> Bool
  func update(image: UIImage, indexPath: IndexPath)

  func movieModel(indexPath: IndexPath) -> MovieRuntimeModel?

  func handle(state: MoviesListState)
  func handleOnLoadingState()

  func handleAlertStateWith(error: Error)
}

/// Interactor Input
/// Represents interactor's input.
/// @mockable
public protocol MoviesListInteractorInput {
  func movieModel(indexPath: IndexPath) -> MovieRuntimeModel?

  func loadImageIfNeeded(indexPath: IndexPath)
  func cancelLoadingImageIfNeeded(indexPath: IndexPath)

  func viewDidLoad()
  func onAllertDismissed()

  func loadNextPageIfPossible()
  func resetList()
  func requestNextPageIfNeeded(lastDisplayed indexPath: IndexPath)
}

/// Routing Handling
/// Represents routing handler. Module's coordinator conforms to this protocol
public protocol MoviesListRoutingHandlingProtocol: ModuleRoutingHandlingProtocol {
  func performRoute(ouputModel: ModuleOutputModelProtocol)
}

/// Coordinator Routing Handling
/// Represents coordinator's exit point. Parent flow coordinator should conforms to this protocol if exists. If not just send `ExpressibleByNilLiteral` as generic parameter.
public protocol MoviesListCoordinatorExitRoutingProtocol: FlowExitPointProtocol {
  func performRoute(_ coordinator: CoordinatorProtocol, ouputModel: ModuleOutputModelProtocol)
}
