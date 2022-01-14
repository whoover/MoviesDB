//
//  MoviesListViewController.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import MDBCommonUI
import MDBUtilities
import UIKit

final class MoviesListViewController: UIViewController, ViewControllerProtocol {
  var interactor: MoviesListInteractorInput?
  var routingHandler: MoviesListRoutingHandlingProtocol?

  private let tableViewController = BaseTableViewController<
    MoviesListDataSource<MoviesListSection<MoviesListCellModel>>
  >()
  private let tableViewContainer = UIView()
  private let refreshControl = UIRefreshControl()

  private var subscriptions = Set<AnyCancellable>()

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    setupSubviews()
    interactor?.viewDidLoad()
    setupTableActionPublisher()
  }

  private func setupTableActionPublisher() {
    tableViewController.tableActionPublisher.sink { [weak self] action in
      switch action {
      case let .willDisplayCell(_, indexPath: indexPath):
        self?.interactor?.loadImageIfNeeded(indexPath: indexPath)
        self?.interactor?.requestNextPageIfNeeded(lastDisplayed: indexPath)
      case let .willEndDisplayCell(indexPath: indexPath, cell: _):
        self?.interactor?.cancelLoadingImageIfNeeded(indexPath: indexPath)
      case let .didSelectCell(indexPath: indexPath):
        guard let movie = self?.interactor?.movieModel(indexPath: indexPath) else {
          return
        }
        self?.routingHandler?.performRoute(ouputModel: MoviesListOutputModel(movie: movie))
      default:
        break
      }
    }.store(in: &subscriptions)
  }
}

// MARK: - Configure

extension MoviesListViewController {
  private func setupSubviews() {
    tableViewContainer.add(to: view).do {
      $0.edgesToSuperview()
    }

    addChildController(tableViewController) { view in
      view.edgesToSuperview()
    }

    tableViewController.refreshControl = refreshControl
    tableViewController.setupTableView { tableView in
      tableView.registerCellClass(MoviesListCell.self)
    }

    refreshControl.addTarget(
      self,
      action: #selector(refresh),
      for: .valueChanged
    )
  }

  func endRefreshing() {
    refreshControl.endRefreshing()
  }

  @objc
  func refresh() {
    interactor?.resetList()
    interactor?.loadNextPageIfPossible()
  }
}

// MARK: - MoviesListViewInput

extension MoviesListViewController: MoviesListViewInput {
  func setup(dataSource: MoviesListDataSource<MoviesListSection<MoviesListCellModel>>) {
    tableViewController.dataSourceModel = dataSource
  }

  func reloadData() {
    tableViewController.reloadData()
  }

  func reloadCell(indexPath: IndexPath) {
    tableViewController.reloadCell(at: indexPath)
  }

  func localize(with l10n: L10n.Type) {
    setupBackButton(title: l10n.Button.back)
    title = l10n.Main.Movies.List.title
  }

  func setupWith(state: MoviesListState) {
    switch state {
    case let .onError(types):
      if case let .alert(configuration) = types.first {
        var alertConfiguration = configuration
        alertConfiguration.completion = { [weak self] in
          self?.interactor?.onAllertDismissed()
        }
        showAlertIfNotPresentedBefore(config: alertConfiguration)
      }
    case let .default(completion):
      stopIndicator(completion: completion)
    case let .onLoading(configuration):
      startIndicatorIfNeeded(
        loadingText: configuration.loadingText,
        animationDelay: 0.5,
        dismissDelay: 1,
        colors: configuration.colors
      )
    default:
      break
    }
  }
}

// MARK: View Input

extension MoviesListViewController {}

// MARK: Button Action

extension MoviesListViewController {}
