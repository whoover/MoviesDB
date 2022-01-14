//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import MDBCommonUI
import MDBComponents
import MDBModels
import MDBUtilities
import UIKit

final class MovieDetailsViewController: UIViewController, ViewControllerProtocol {
  var interactor: MovieDetailsInteractorInput?
  var routingHandler: MovieDetailsRoutingHandlingProtocol?

  private let scrollView = UIScrollView()
  private let imageView = ImageViewWithLoadingIndicator()
  private let nameLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let ratingLabel = UILabel()
  private let dateLabel = UILabel()

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
  }
}

// MARK: - Configure

extension MovieDetailsViewController {
  private func setupSubviews() {
    view.backgroundColor = .white

    scrollView.add(to: view).do {
      $0.edgesToSuperview()
    }

    nameLabel.add(to: scrollView).do {
      $0.topToSuperview(offset: 16)
      $0.leadingToSuperview(offset: 16)
      $0.trailingToSuperview(offset: -16)
      $0.leading(to: view, offset: 16, relation: .equalOrGreater)
      $0.trailing(to: view, offset: -16, relation: .equalOrLess)
      $0.centerX(to: view)
      $0.centerXToSuperview()
      $0.textAlignment = .center
      $0.numberOfLines = 0
    }

    imageView.add(to: scrollView).do {
      $0.topToBottom(of: nameLabel, offset: 16)
      $0.centerX(to: view)
      $0.width(to: view, multiplier: 0.7)
      $0.aspectRatio(0.67)
    }

    descriptionLabel.add(to: scrollView).do {
      $0.topToBottom(of: imageView, offset: 16)
      $0.leading(to: view, offset: 16)
      $0.trailing(to: view, offset: -16)
      $0.numberOfLines = 0
    }

    ratingLabel.add(to: scrollView).do {
      $0.topToBottom(of: descriptionLabel, offset: 16)
      $0.leading(to: view, offset: 16)
      $0.bottomToSuperview(offset: -50)
    }

    dateLabel.add(to: scrollView).do {
      $0.topToBottom(of: descriptionLabel, offset: 16)
      $0.trailing(to: view, offset: -16)
    }
  }
}

// MARK: - MovieDetailsViewInput

extension MovieDetailsViewController: MovieDetailsViewInput {
  func update(image: UIImage) {
    imageView.stop()
    imageView.setup(image: image)
  }

  func setup(movieModel: MovieRuntimeModel) {
    title = movieModel.title
    nameLabel.text = movieModel.title
    descriptionLabel.text = movieModel.overview
    ratingLabel.text = "\(movieModel.voteAverage)"
    if let releaseDate = movieModel.releaseDate {
      dateLabel.text = DateFormatter.formatter(
        withFormat: "dd.MM.yyyy"
      ).string(from: releaseDate)
    } else {
      dateLabel.isHidden = true
    }
    imageView.start()
    interactor?.loadImageIfNeeded(path: movieModel.posterPath)
  }

  func localize(with l10n: L10n.Type) {
    setupBackButton(title: l10n.Button.back)
  }

  func setupWith(state: MovieDetailsState) {
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

extension MovieDetailsViewController {}

// MARK: Button Action

extension MovieDetailsViewController {}
