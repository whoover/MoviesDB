//
//  MovieDetailsPresenter.swift
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

final class MovieDetailsPresenter: PresenterProtocol {
  weak var view: MovieDetailsViewInput?
  var moduleOutput: MovieDetailsModuleOutput?

  private let stateMachine: MovieDetailsStateMachine
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

  init(
    initialState: MovieDetailsState = .default(completion: nil),
    dependency: MovieDetailsPresenterDependency
  ) {
    stateMachine = MovieDetailsStateMachine(state: initialState)
    localizer = dependency.localizer
    themesManager = dependency.themeManager
  }
}

// MARK: Private

extension MovieDetailsPresenter {
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

extension MovieDetailsPresenter: MovieDetailsModuleInput {
  func setup(movieModel: MovieRuntimeModel) {
    view?.setup(movieModel: movieModel)
  }
}

// MARK: Interactor Output

extension MovieDetailsPresenter: MovieDetailsPresenterInput {
  func update(image: UIImage) {
    view?.update(image: image)
  }

  func interactorDidLoad() {
    subscribeOnThemePublisher()
    subscribeOnStatePublisher()
    localizeView()
  }

  func handle(state: MovieDetailsState) {
    stateMachine.changeStateIfNeeded(to: state)
  }

  func handleOnLoadingState() {
    let loadingState = MovieDetailsState.onLoading(
      .init(loadingText: localizer.l10n.ActivityIndicator.onLoadingTitle)
    )
    handle(state: loadingState)
  }

  func handleAlertStateWith(error: Error) {
    let configuration = AlertConfiguration(
      message: error.localizedDescription,
      actions: alertActions(with: alertActions)
    )
    let errorState = MovieDetailsState.onError([
      .alert(configuration: configuration)
    ])
    handle(state: errorState)
  }
}
