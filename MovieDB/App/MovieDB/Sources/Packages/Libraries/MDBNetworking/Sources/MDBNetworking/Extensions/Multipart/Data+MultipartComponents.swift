//
//  Data+MultipartComponents.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}
