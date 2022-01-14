//
//  ImageSaveService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import UIKit

public struct ImageSaveResult {
  public let image: UIImage
  public let imageKey: String
}

public protocol ImageSaveServiceProtocol {
  var didSaveResultPublisher: AnyPublisher<ImageSaveResult, Never> { get }

  func getImage(name: String) -> AnyPublisher<UIImage?, Never>
  func saveImage(image: UIImage, name: String) -> AnyPublisher<Bool, Never>
}

public final class ImageSaveService: ImageSaveServiceProtocol {
  private let queue = DispatchQueue(label: "MDBServices.ImageSaveService")
  private let fileManager = FileManager.default
  private let cache = NSCache<NSString, UIImage>()

  private let didSaveResultSubject = PassthroughSubject<ImageSaveResult, Never>()
  public var didSaveResultPublisher: AnyPublisher<ImageSaveResult, Never> {
    didSaveResultSubject.eraseToAnyPublisher()
  }

  public init() {}

  public func getImage(name: String) -> AnyPublisher<UIImage?, Never> {
    if let dir = try? fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    ) {
      return Future<UIImage?, Never> { [weak self] promise in
        guard let self = self else {
          promise(.success(nil))
          return
        }

        self.queue.async {
          promise(
            .success(
              UIImage(
                contentsOfFile: URL(
                  fileURLWithPath: dir.absoluteString
                ).appendingPathComponent(name).path
              )
            )
          )
        }
      }.eraseToAnyPublisher()
    }
    return Just(nil).eraseToAnyPublisher()
  }

  public func saveImage(image: UIImage, name: String) -> AnyPublisher<Bool, Never> {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
      return Just(false).eraseToAnyPublisher()
    }

    guard let directory = try? fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    ) else {
      return Just(false).eraseToAnyPublisher()
    }

    return Future<Bool, Never> { [weak self] promise in
      guard let self = self else {
        promise(.success(false))
        return
      }

      self.queue.async {
        do {
          try data.write(to: directory.appendingPathComponent(name))
          promise(.success(true))
          self.didSave(image: image, name: name)
        } catch {
          promise(.success(false))
        }
      }
    }.eraseToAnyPublisher()
  }

  private func didSave(image: UIImage, name: String) {
    didSaveResultSubject.send(.init(image: image, imageKey: name))
  }
}
