//
//  ImageDecoder.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public struct ImageResponseObject: BaseResponseProtocol, Equatable {
  public let data: Data

  public var image: UIImage? {
    UIImage(data: data)
  }

  public init(data: Data) {
    self.data = data
  }
}

public class ImageDecoder<T>: CustomDecoder {
  public static func create() -> ImageDecoder<T> {
    ImageDecoder<T>()
  }

  public func decode<T>(_ type: T.Type, from: Data) throws -> T where T: Decodable {
    guard type is ImageResponseObject.Type,
          let model = ImageResponseObject(data: from) as? T
    else {
      throw DecodingError.typeMismatch(
        ImageResponseObject.self, DecodingError.Context(
          codingPath: [],
          debugDescription:
          "Wrong data"
        )
      )
    }

    return model
  }
}
