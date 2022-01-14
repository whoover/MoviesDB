//
//  MovieDetailsInteractor.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import MDBCommonUI
import MDBConstants
import MDBNetworking
import MDBServices

final class MovieDetailsInteractor: InteractorProtocol {
  var presenter: MovieDetailsPresenterInput?

  private let networkingService: NetworkingServiceProtocol
  private let saveImagesService: ImageSaveServiceProtocol

  private var subscriptions = Set<AnyCancellable>()
  private var imagesLoadingSubscriptions = [String: AnyCancellable]()
  private var imagePath = ""

  deinit {
    cancelLoadingImageIfNeeded()
  }

  init(dependency: MovieDetailsInteractorDependency) {
    networkingService = dependency.networkingProvider.networkingService
    saveImagesService = dependency.saveImagesService
  }
}

// MARK: Private

extension MovieDetailsInteractor: MovieDetailsInteractorInput {
  func viewDidLoad() {
    presenter?.interactorDidLoad()
  }

  func onAllertDismissed() {
    presenter?.handle(state: .default(completion: nil))
  }

  func loadImageIfNeeded(path: String) {
    imagePath = path
    let downloadImage = { [weak self] in
      let request = ImageRequest(imagePath: path)
      let publisher = self?.networkingService.httpTaskWith(request: request, configurationType: .default)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
          switch result {
          case .failure:
            self?.imagesLoadingSubscriptions[path] = nil
          case .finished:
            break
          }
        } receiveValue: { [weak self] imageObject in
          guard let image = imageObject.image else {
            self?.imagesLoadingSubscriptions[path] = nil
            return
          }

          _ = self?.saveImagesService.saveImage(image: image, name: path)
          self?.presenter?.update(image: image)
          self?.imagesLoadingSubscriptions[path] = nil
        }
      self?.imagesLoadingSubscriptions[path] = publisher
    }

    saveImagesService
      .getImage(name: path)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] image in
        guard let image = image else {
          downloadImage()
          return
        }

        self?.presenter?.update(image: image)
      }.store(in: &subscriptions)
  }

  func cancelLoadingImageIfNeeded() {
    imagesLoadingSubscriptions[imagePath]?.cancel()
    imagesLoadingSubscriptions[imagePath] = nil
  }
}
