//
//  JSONDecoder+CustomDecoder.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

extension JSONDecoder: CustomDecoder {
  public static func create() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .secondsSince1970

    return decoder
  }
}
