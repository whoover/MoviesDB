//
//  MoviesListInteractor.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import MDBCommonUI
import MDBConstants
import MDBDataLayer
import MDBNetworking
import MDBServices

private final class ListModel {
  var page = 1
  var isLoadingInProgress = false
  var isFullyLoaded = false

  func reset() {
    isFullyLoaded = false
    page = 1
    isLoadingInProgress = false
  }
}

final class MoviesListInteractor: InteractorProtocol {
  var presenter: MoviesListPresenterInput?

  private let networkingService: NetworkingServiceProtocol
  private let databaseService: DatabaseServiceProtocol & PersistenceDataInteractorProtocol
  private let saveImagesService: ImageSaveServiceProtocol

  private var subscriptions = Set<AnyCancellable>()
  private var imagesLoadingSubscriptions = [String: AnyCancellable]()
  private var listModel = ListModel()
  private var storedLocally: [MovieRuntimeModel] = []

  init(dependency: MoviesListInteractorDependency) {
    networkingService = dependency.networkingProvider.networkingService
    saveImagesService = dependency.saveImagesService
    databaseService = dependency.databaseService
  }
}

// MARK: Private

extension MoviesListInteractor: MoviesListInteractorInput {
  func movieModel(indexPath: IndexPath) -> MovieRuntimeModel? {
    presenter?.movieModel(indexPath: indexPath)
  }

  func viewDidLoad() {
    presenter?.interactorDidLoad()
    loadNextPageIfPossible()
  }

  func onAllertDismissed() {
    presenter?.handle(state: .default(completion: nil))
  }

  func requestNextPageIfNeeded(lastDisplayed indexPath: IndexPath) {
    if indexPath.row + 1 == presenter?.numberOfCells {
      loadNextPageIfPossible()
    }
  }

  func loadNextPageIfPossible() {
    guard !listModel.isLoadingInProgress, !listModel.isFullyLoaded else {
      return
    }

    guard networkingService.httpService?.isReachable() == true,
          presenter?.numberOfCells == 0
    else {
      databaseService.getAll(of: MovieRuntimeModel.self)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
          switch result {
          case let .failure(error):
            self?.presenter?.handleAlertStateWith(error: error)
          case .finished:
            break
          }
        } receiveValue: { [weak self] models in
          guard let self = self else {
            return
          }

          self.storedLocally = models
          self.presenter?.update(movies: models)
          self.presenter?.handle(state: .default(completion: nil))
          self.listModel.isFullyLoaded = models.isEmpty
          self.listModel.page += 1
          self.listModel.isLoadingInProgress = false
        }.store(in: &subscriptions)

      return
    }

    listModel.isLoadingInProgress = true
    presenter?.handleOnLoadingState()
    networkingService.httpTaskWith(
      request: MoviesListRequest(page: listModel.page, apiKey: MDBConstants.ApiKey),
      configurationType: .default
    )
    .flatMap { response -> AnyPublisher<[MovieRuntimeModel], Error> in
      Just(response.convertToRuntimeModels())
        .setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    .receive(on: DispatchQueue.main)
    .sink { [weak self] result in
      switch result {
      case let .failure(error):
        self?.presenter?.handleAlertStateWith(error: error)
      case .finished:
        break
      }
    } receiveValue: { [weak self] models in
      guard let self = self else {
        return
      }

      var models = models
      models.removeAll(where: {
        let index = self.storedLocally.firstIndex(of: $0)
        if let index = index {
          self.storedLocally.remove(at: index)
        }
        return index != nil
      })
      _ = self.databaseService.addOrUpdate(objects: models)
      self.presenter?.update(movies: models)
      self.presenter?.handle(state: .default(completion: nil))
      self.listModel.isFullyLoaded = models.isEmpty
      self.listModel.page += 1
      self.listModel.isLoadingInProgress = false
    }.store(in: &subscriptions)
  }

  func resetList() {
    listModel.reset()
    presenter?.resetList()
  }

  func loadImageIfNeeded(indexPath: IndexPath) {
    guard let imagePath = presenter?.getImagePath(indexPath: indexPath) else {
      return
    }

    if presenter?.isImageLoadingNeeded(indexPath: indexPath) == true {
      let downloadImage = { [weak self] in
        let request = ImageRequest(imagePath: imagePath)
        let publisher = self?.networkingService.httpTaskWith(request: request, configurationType: .default)
          .receive(on: DispatchQueue.main)
          .sink { [weak self] result in
            switch result {
            case .failure:
              self?.imagesLoadingSubscriptions[imagePath] = nil
            case .finished:
              break
            }
          } receiveValue: { [weak self] imageObject in
            guard let self = self else {
              return
            }
            guard let image = imageObject.image else {
              self.imagesLoadingSubscriptions[imagePath] = nil
              return
            }

            self.presenter?.update(image: image, indexPath: indexPath)
            self.imagesLoadingSubscriptions[imagePath] = nil
            self.saveImagesService
              .saveImage(image: image, name: imagePath)
              .receive(on: DispatchQueue.main)
              .sink(receiveValue: { isSuccess in
                print("image succeed saved: \(isSuccess)")
              })
              .store(in: &self.subscriptions)
          }
        self?.imagesLoadingSubscriptions[imagePath] = publisher
      }

      saveImagesService
        .getImage(name: imagePath)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] image in
          guard let image = image else {
            downloadImage()
            return
          }

          self?.presenter?.update(image: image, indexPath: indexPath)
        }.store(in: &subscriptions)
    }
  }

  func cancelLoadingImageIfNeeded(indexPath: IndexPath) {
    guard let imageURLString = presenter?
      .getImagePath(indexPath: indexPath)
    else {
      return
    }

    imagesLoadingSubscriptions[imageURLString]?.cancel()
    imagesLoadingSubscriptions[imageURLString] = nil
  }
}

private extension MoviesListResponse {
  func convertToRuntimeModels() -> [MovieRuntimeModel] {
    results.map {
      MovieRuntimeModel(
        adult: $0.adult,
        id: $0.id,
        title: $0.title,
        overview: $0.overview,
        popularity: $0.popularity,
        posterPath: $0.posterPath,
        releaseDate: DateFormatter.formatter(
          withFormat: "yyyy-MM-dd"
        ).date(from: $0.releaseDate),
        voteAverage: $0.voteAverage,
        voteCount: $0.voteCount
      )
    }
  }
}
