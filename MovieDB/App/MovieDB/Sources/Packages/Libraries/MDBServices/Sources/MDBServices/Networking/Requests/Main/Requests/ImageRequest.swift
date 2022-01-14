//
//  ImageRequest.swift
//
//
//  Created by Artem Belenkov on 20.05.2021.
//

import Foundation

import MDBModels
import MDBNetworking

public final class ImageRequest: GetHttpRequest<
  ImageResponseObject,
  ImageDecoder<ImageResponseObject>
>, HTTPRequestProtocol {
  public typealias RuntimeModelType = ImageResponseObject

  private let imagePath: String

  override public var requestDescription: String {
    imagePath
  }

  override public var headers: [String: String] {
    ["Content-Type": "image/png"]
  }

  override public func createBaseURLRequest() throws -> URLRequest {
    guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + imagePath) else {
      throw NetworkingError.missingUrl
    }
    return URLRequest(url: url)
  }

  public init(imagePath: String) {
    self.imagePath = imagePath
  }
}
