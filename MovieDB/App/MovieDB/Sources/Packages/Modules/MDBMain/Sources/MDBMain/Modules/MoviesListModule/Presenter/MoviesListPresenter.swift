//
//  MoviesListPresenter.swift
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

final class MoviesListPresenter: PresenterProtocol {
  weak var view: MoviesListViewInput?
  var moduleOutput: MoviesListModuleOutput?

  private let stateMachine: MoviesListStateMachine
  private let localizer: LocalizerProtocol
  private let themesManager: ThemeManagerProtocol
  var alertActions: [StateMachineAlertStateActionType] {
    [
      StateMachineAlertStateDefaultAction(
        title: localizer.l10n.Button.ok
      )
    ]
  }

  private var subscriptions: Set<AnyCancellable> = []
  private var dataSource = MoviesListDataSource<MoviesListSection<MoviesListCellModel>>()

  init(
    initialState: MoviesListState = .default(completion: nil),
    dependency: MoviesListPresenterDependency
  ) {
    stateMachine = MoviesListStateMachine(state: initialState)
    localizer = dependency.localizer
    themesManager = dependency.themeManager
  }
}

// MARK: Private

extension MoviesListPresenter {
  private func subscribeOnThemePublisher() {
//    themesManager.themePublisher
//      .sink { [weak self] _ in
//        guard let self = self,
//              let view = self.view
//        else {
//          return
//        }
//
//        view.setup(theme: theme.colors.authorization)
//        view.setup(images: theme.images.authorization)
//      }
//      .store(in: &subscriptions)
  }

  private func subscribeOnStatePublisher() {
    stateMachine.onStateChangePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.view?.setupWith(state: state)
      }
      .store(in: &subscriptions)
  }

  private func localizeView() {
    view?.localize(with: localizer.l10n)
  }
}

// MARK: Module Input

extension MoviesListPresenter: MoviesListModuleInput {}

// MARK: Interactor Output

extension MoviesListPresenter: MoviesListPresenterInput {
  var numberOfCells: Int {
    dataSource.sections[safe: 0]?.cells.count ?? 0
  }

  func getImagePath(indexPath: IndexPath) -> String? {
    dataSource
      .sections[safe: indexPath.section]?
      .cells[safe: indexPath.row]?.model.posterPath
  }

  func isImageLoadingNeeded(indexPath: IndexPath) -> Bool {
    dataSource
      .sections[safe: indexPath.section]?
      .cells[safe: indexPath.row]?.image == nil
  }

  func update(image: UIImage, indexPath: IndexPath) {
    guard dataSource.sections.count > indexPath.section else {
      return
    }
    let section = dataSource.sections[indexPath.section]

    guard section.cells.count > indexPath.row else {
      return
    }
    section.cells[indexPath.row].image = image
    view?.reloadCell(indexPath: indexPath)
  }

  func resetList() {
    dataSource.resetList()
    view?.reloadData()
  }

  func movieModel(indexPath: IndexPath) -> MovieRuntimeModel? {
    dataSource.movieModel(indexPath: indexPath)
  }

  func update(movies: [MovieRuntimeModel]) {
    dataSource
      .sections[0]
      .cells.append(
        contentsOf: movies.map { MoviesListCellModel(model: $0) }
      )

    view?.endRefreshing()
    view?.reloadData()
  }

  func interactorDidLoad() {
    subscribeOnThemePublisher()
    subscribeOnStatePublisher()
    localizeView()
    view?.setup(dataSource: dataSource)
  }

  func handle(state: MoviesListState) {
    stateMachine.changeStateIfNeeded(to: state)
  }

  func handleOnLoadingState() {
    let loadingState = MoviesListState.onLoading(
      .init(loadingText: localizer.l10n.ActivityIndicator.onLoadingTitle)
    )
    handle(state: loadingState)
  }

  func handleAlertStateWith(error: Error) {
    let configuration = AlertConfiguration(
      message: error.localizedDescription,
      actions: alertActions(with: alertActions)
    )
    let errorState = MoviesListState.onError([
      .alert(configuration: configuration)
    ])
    handle(state: errorState)
  }
}
